param(
    [string]$MsklcPath = "${env:ProgramFiles(x86)}/Microsoft Keyboard Layout Creator 1.4"
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$compiler = Join-Path $MsklcPath 'bin/i386/kbdutool.exe'
if (!(Test-Path -LiteralPath $compiler)) { throw "MSKLC compiler not found: $compiler" }
$installer = New-Object -ComObject WindowsInstaller.Installer

function Get-MsiString($Record, [int]$Field) {
    $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, @($Field))
}

function Invoke-Sql($Database, [string]$Sql) {
    try { $view = $Database.OpenView($Sql) } catch { throw "Invalid MSI SQL: $Sql ($_)" }
    try { $view.Execute() } finally { $view.Close() }
}

foreach ($language in @('us', 'ru')) {
    $name = "universal-$language"
    $dllName = "univ-$language.dll"
    $folder = Join-Path $root "layouts/windows/$name"
    $source = Join-Path $folder "$name.klc"
    $description = ([regex]::Match((Get-Content -LiteralPath $source -Raw -Encoding Unicode), '^KBD\s+\S+\s+"([^"]+)"')).Groups[1].Value
    if (!$description) { throw "Missing KBD description: $source" }
    $upgradeCode = '{' + [guid]::NewGuid().ToString().ToUpperInvariant() + '}'
    $work = Join-Path ([IO.Path]::GetTempPath()) ('universal-layout-build-' + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $work | Out-Null
    try {
        foreach ($target in @(@('i386', '-x'), @('amd64', '-m'), @('ia64', '-i'), @('wow64', '-o'))) {
            Push-Location $work
            try {
                $output = & $compiler -u $target[1] $source 2>&1
                if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $dllName)) {
                    throw "Compilation failed for $name/$($target[0]): $output"
                }
                Copy-Item -LiteralPath $dllName -Destination (Join-Path $folder "installer/$($target[0])/$dllName") -Force
                Remove-Item -LiteralPath $dllName
            } finally { Pop-Location }
        }

        foreach ($architecture in @('i386', 'amd64', 'ia64')) {
            $msi = Join-Path $folder "installer/${name}_$architecture.msi"
            $database = $installer.OpenDatabase($msi, 1)
            try {
                $view = $database.OpenView('SELECT `Value` FROM `Property` WHERE `Property` = ''LayoutFile''')
                $view.Execute()
                $oldDll = Get-MsiString ($view.Fetch()) 1
                $view.Close()
                $newIdentity = $oldDll -cne $dllName
                Invoke-Sql $database "UPDATE ``Property`` SET ``Value`` = '$dllName' WHERE ``Property`` = 'LayoutFile'"
                Invoke-Sql $database "UPDATE ``Property`` SET ``Value`` = '$($description.Replace("'", "''"))' WHERE ``Property`` = 'ProductName'"

                $view = $database.OpenView('SELECT `File`, `Directory_` FROM `File`, `Component` WHERE `File`.`Component_` = `Component`.`Component`')
                $view.Execute()
                $files = @()
                while ($record = $view.Fetch()) {
                    $files += ,@((Get-MsiString $record 1), (Get-MsiString $record 2))
                }
                $view.Close()
                foreach ($file in $files) {
                    $platform = $file[1].Replace('SYSTEMFOLDER', '').ToLowerInvariant()
                    $dll = Join-Path $folder "installer/$platform/$dllName"
                    $size = (Get-Item -LiteralPath $dll).Length
                    $info = [Diagnostics.FileVersionInfo]::GetVersionInfo($dll)
                    $version = @($info.FileMajorPart, $info.FileMinorPart, $info.FileBuildPart, $info.FilePrivatePart) -join '.'
                    Invoke-Sql $database "UPDATE ``File`` SET ``FileName`` = '$dllName', ``FileSize`` = $size, ``Version`` = '$version' WHERE ``File`` = '$($file[0])'"
                }
                if ($newIdentity) {
                    $productCode = '{' + [guid]::NewGuid().ToString().ToUpperInvariant() + '}'
                    Invoke-Sql $database "UPDATE ``Property`` SET ``Value`` = '$productCode' WHERE ``Property`` = 'ProductCode'"
                    Invoke-Sql $database "UPDATE ``Property`` SET ``Value`` = '$upgradeCode' WHERE ``Property`` = 'UpgradeCode'"
                    $view = $database.OpenView('SELECT `Component` FROM `Component`')
                    $view.Execute()
                    $components = @()
                    while ($record = $view.Fetch()) { $components += Get-MsiString $record 1 }
                    $view.Close()
                    foreach ($component in $components) {
                        $id = '{' + [guid]::NewGuid().ToString().ToUpperInvariant() + '}'
                        Invoke-Sql $database "UPDATE ``Component`` SET ``ComponentId`` = '$id' WHERE ``Component`` = '$component'"
                    }
                }
                $summary = $database.SummaryInformation(4)
                foreach ($property in @(@(2, $description), @(3, $description), @(9, ('{' + [guid]::NewGuid().ToString().ToUpperInvariant() + '}')))) {
                    $summary.GetType().InvokeMember('Property', 'SetProperty', $null, $summary, @([int]$property[0], [string]$property[1])) | Out-Null
                }
                $summary.Persist()
                $database.Commit()
            } finally {
                [Runtime.InteropServices.Marshal]::FinalReleaseComObject($database) | Out-Null
            }
            Write-Output "Built $name ($architecture)"
        }
    } finally {
        # Only remove the uniquely created build directory under the system temp directory.
        $resolvedWork = [IO.Path]::GetFullPath($work)
        $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
        if (!$resolvedWork.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) { throw "Unexpected build directory: $resolvedWork" }
        Remove-Item -LiteralPath $resolvedWork -Recurse -Force
    }
}
