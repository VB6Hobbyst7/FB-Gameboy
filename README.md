# FB-Gameboy
Gameboy emulator written in FreeBasic.
Sound and savegames aren't supported at the moment.

#### Usage
Run "fbgb" from command line and pass the rom-file as the parameter:
```
./fbgb rom.gb
```

#### Controls
- [WASD] Moving
- [Q / E] A / B
- [SPACE] Start
- [CTRL] Select

- [F1] Changes the color palette
- [F2] Changes the speed
- [F3] Displays the memory
- [F4] Displays a disassembly of the code, aswell as the current state of the CPU-registers
- [F5] Displays a log of the last "interesting" actions, aswell as some misc. infos

#### Screenshots
![Bild](https://github.com/IchMagBier/FB-Gameboy/blob/master/screens/bild1.png)![Bild](https://github.com/IchMagBier/FB-Gameboy/blob/master/screens/bild3.png)![Bild](https://github.com/IchMagBier/FB-Gameboy/blob/master/screens/bild2.png)![Bild](https://github.com/IchMagBier/FB-Gameboy/blob/master/screens/bild4.png)

#### How to compile
- Download the latest FreeBasic-compiler from here (works with 1.05.0):
https://sourceforge.net/projects/fbc/files/
- Be sure to have GTK installed
- Compile with:
```
(Linux) fbc src/fbgb.bas -x fbgb
( Win ) fbc.exe src\fbgb.bas -x fbgb.exe
```

