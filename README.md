# Универсальная раскладка

Универсальная раскладка - пакет из английской и русской раскладок для Windows и Linux.

Цель создания - повышение удобства ввода спецсимволов без переключения между языковыми раскладками. Все спецсимволы находятся на слоях AltGr и AltGr+Shift. Представленные раскладки совместимы с оригинальными QWERTY и ЙЦУКЕН раскладками (буквенные клавиши базового и Shift слоя без изменений).

Раскладка предназначается для использования со сплит клавиатурами, поскольку использование слоев AltGr- и AltGr+Shift-слоев контринтуитивно для пользователя стандартной клавиатуры. При печати на стандартной клавиатуре, опыт использования не меняется.

## Слои

### AltGr

![](.github/altgr.png?raw=true)

### AltGr + Shift

![](.github/altgr-shift.png?raw=true)

## Установка

Обе раскладки используют единые имена: `universal-us` и `universal-ru`.
В MSKLC 1.4 внутреннее имя раскладки ограничено 8 символами, поэтому
в Windows используются внутренние имена `univ-us` / `univ-ru` и DLL
`univ-us.dll` / `univ-ru.dll`. Имена исходников и установочных пакетов — полные.

### Windows

- Клонировать репозиторий
- Выполнить установку через файлы `setup.exe` в [universal-us](./layouts/windows/universal-us/installer/) И [universal-ru](./layouts/windows/universal-ru/installer/)
- Выбери новые раскладки - `США - Universal Layout` и `Русский - Universal Layout`

Для пересборки DLL и обновления MSI установи Microsoft Keyboard Layout Creator 1.4
и выполни `powershell -ExecutionPolicy Bypass -File scripts/build-windows.ps1`.
Скрипт использует MSI из репозитория как шаблоны и обновляет внешние DLL для всех
четырёх архитектур. Проверка сборки не устанавливает раскладки в систему.

### Linux

- Перенести файлы из [symbols](./layouts/linux/xkb/symbols/) в папку `/usr/share/X11/xkb/symbols/`
- Перенести layouts из файла [evdev.xml](./layouts/linux/xkb/rules/evdev.xml) в конец тега `layoutList` файла `/usr/share/X11/xkb/rules/evdev.xml`
- Перезапусти ПК
- Выбери новые раскладки в настройках клавиатуры - `English (Universal Layout)` и `Russian (Universal Layout)`

## Точка и запятая на нумпаде

В обеих раскладках клавиша нумпада `.`/`Del` вводит `.`, а с правым Alt
(AltGr) — `,`. В Linux это работает независимо от Num Lock, в Windows —
при включённом Num Lock. Отдельная клавиша Delete сохраняет своё назначение.

## Клавиши

| Спецсимвол         | Комбинация                  |
| ------------------ | --------------------------- |
| `` ` ``            | `AltGr` + `` ` ``           |
| `~`                | `AltGr` + `Shift` + `` ` `` |
| `@`                | `AltGr` + `2`               |
| `#`                | `AltGr` + `3`               |
| `№`                | `AltGr` + `Shift` + `3`     |
| `$`                | `AltGr` + `4`               |
| `₽`                | `AltGr` + `Shift` + `4`     |
| `^`                | `AltGr` + `6`               |
| `&`                | `AltGr` + `7`               |
| Неразрывное тире   | `AltGr` + `-`               |
| `[`                | `AltGr` + `[`               |
| `{`                | `AltGr` + `Shift` + `[`     |
| `]`                | `AltGr` + `]`               |
| `}`                | `AltGr` + `Shift` + `]`     |
| `;`                | `AltGr` + `;`               |
| `:`                | `AltGr` + `Shift` + `;`     |
| `'`                | `AltGr` + `'`               |
| `"`                | `AltGr` + `Shift` + `'`     |
| `,`                | `AltGr` + `,`               |
| `<`                | `AltGr` + `Shift` + `,`     |
| `.`                | `AltGr` + `.`               |
| `>`                | `AltGr` + `Shift` + `.`     |
| `\`                | `AltGr` + `\`               |
| `\|`               | `AltGr` + `Shift` + `\`     |
| `/`                | `AltGr` + `/`               |
| `?`                | `AltGr` + `Shift` + `/`     |
| Неразрывный пробел | `AltGr` + `<пробел>`        |

## Альтернативы

- [Раскладка Никиты Широкова](https://github.com/braindefender/universal-layout)
- [Раскладка Никиты Прокопова](https://github.com/tonsky/Universal-Layout)
