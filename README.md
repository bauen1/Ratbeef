# Ratbeef
An IRC bot written in lua to marry Ratbot
(Also includes a lot of hacks regarding the package library for lua)

## Requirements
* Lua 5.3
* Luarocks 2.3 (Apparently this installs luasockets for 5.3)

## Notes
Ratbeef utilizes ANSI control codes for colored output, these might not work on windows, you can disable them by chainging line 27 in ```core/ansicolors.lua```

from
```local escape = string.char(27) .. '[%dm'```
to
```local escape = ''```

## Disclaimer
For educational pupose only!

## License
Look at the file ```LICENSE```
