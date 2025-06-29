# Универсальная раскладка

Универсальная раскладка - пакет из английской и русской раскладок для Windows и Linux.

Цель создания - повышение удобства ввода спецсимволов без переключения между языковыми раскладками. Все спецсимволы находятся на слоях AltGr и AltGr+Shift. Представленные раскладки совместимы с оригинальными QWERTY и ЙЦУКЕН раскладками (базовый и Shift слой без изменений).

Раскладка предназначается для использования со сплит клавиатурами, поскольку использование слоев AltGr- и AltGr+Shift-слоев контринтуитивно для пользователя стандартной клавиатуры. При печати на стандартной клавиатуре, опыт использования не меняется.

## Слои

### AltGr

![](.github/altgr.png?raw=true)

### AltGr + Shift

![](.github/altgr-shift.png?raw=true)

## Установка

### Windows

- Клонировать репозиторий
- Выполнить установку через файлы `setup.exe` в [QWERTY](./layouts/windows/qwerty/installer/) И [ЙЦУКЕН](./layouts/windows/jcuken/installer/)
- Выбери новые раскладки - `Русская/США - расширенная`

### Linux

- Перенести файлы из [symbols](./layouts/linux/xkb/symbols/) в папку `/usr/share/X11/xkb/symbols/`
- Перенести layouts из файла [evdev.xml](./layouts/linux/xkb/rules/evdev.xml) в конец тега `layoutList` файла `/usr/share/X11/xkb/rules/evdev.xml`
- Перезапусти ПК
- Выбери новые раскладки в настройках клавиатуры - `English/Russian (custom AltGr)`

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
