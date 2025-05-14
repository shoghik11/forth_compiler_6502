# Forth6502 Compiler

This is a simple Forth-to-6502 compiler written in Python that generates `.s` (assembly) files, which are assembled and linked using the cc65 toolchain. The final output is a `.prg` file that can be run in the VICE Commodore 64 emulator.

---

## 📁 Project Structure

### File Descriptions:
- **`compiler.py`**: The Python script that compiles Forth source code into 6502 assembly.
- **`runtime.s`**: 6502 assembly file that contains the runtime functions, including stack operations, math functions, and print routines.
- **`none.cfg`**: Configuration file used by `cc65` to specify memory and segment layout for the 6502 program.
- **`example.fs`**: A sample Forth source code file that demonstrates the functionality of the compiler.
- **`test.s`**: The generated assembly file after compiling the Forth source.
---

## ⚙️ Requirements

- Python 3
- cc65 toolchain ([https://cc65.github.io/](https://cc65.github.io/)):
  - `ca65` (assembler)
  - `ld65` (linker)
- VICE C64 emulator ([http://vice-emu.sourceforge.net/](http://vice-emu.sourceforge.net/))

---

## 🛠️ Compilation Steps

### 1. Compile Forth source to assembly

```bash
# 1. Convertion
python3 compiler.py example.fs test.s

# 2. Assemble the runtime
ca65 runtime.s -o runtime.o

# 3. Link the object file
ld65 runtime.o -C none.cfg -o forth.prg
```
## 🧪 Running in VICE Emulator

To run the program in the VICE emulator, follow these steps:

1. **Open the VICE Emulator** (e.g., `x64` or `x64sc`).
   
2. **Attach the generated `forth.prg`:**
   - Go to `File > Smart Attach Disk/Tape`.
   - Select `forth.prg`.

3. **At the BASIC prompt**, type the following:

   ```basic
   LOAD "FORTH.PRG",8
   RUN

This will load and run the forth.prg program in the emulator.



