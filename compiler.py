import sys

class ForthCompiler:
    def __init__(self):
        self.assembly = []
        self.vars = {}
        self.var_address = 0x10
        self.last_token = ""

    def compile_token(self, token):
        if token.isdigit():
            self.assembly.append(f"    LDA #{token}")
            self.assembly.append("    JSR push")
        elif token == "+":
            self.assembly.append("    JSR add")
        elif token == "-":
            self.assembly.append("    JSR sub")
        elif token == "*":
            self.assembly.append("    JSR mul")
        elif token == "dup":
            self.assembly.append("    JSR dup")
        elif token == "swap":
            self.assembly.append("    JSR swap")
        elif token == "tack":
            self.assembly.append("    JSR tack")
        elif token == "neg":
            self.assembly.append("    JSR neg")
        elif token == "drop":
            self.assembly.append("    JSR drop")
        elif token == "over":
            self.assembly.append("    JSR over")
        elif token == "mod":
            self.assembly.append("    JSR mod")
        elif token == "nip":
            self.assembly.append("    JSR nip")
        elif token == ".":
            self.assembly.append("    JSR print")
        elif token == ".s":
            self.assembly.append("    JSR print_stack")
        elif token == "variable":
            self.last_token = "variable"
        elif token == "!":
            self.assembly.append("    JSR pop")
            self.assembly.append(f"    STA {self.last_var}")
        elif token == "@":
            self.assembly.append(f"    LDA {self.last_var}")
            self.assembly.append("    JSR push")
        elif token in self.vars:
            self.last_var = self.vars[token]
        else:
            if self.last_token == "variable":
                self.vars[token] = f"${self.var_address:02X}"
                self.last_var = self.vars[token]
                self.var_address += 1
            self.last_token = token

    def compile(self, source_code):
        tokens = source_code.replace('\n', ' ').split()
        self.assembly.append("    JSR init")
        for token in tokens:
            if token.startswith("\\"):  # skip comments
                continue
            self.compile_token(token)

        code = [
            ".org $8000",
            '.include "runtime.s"',
        ] + self.assembly + [
            "    RTS"
        ]
        return "\n".join(code)

if __name__ == "__main__":
    src_file = sys.argv[1]
    out_file = sys.argv[2]
    with open(src_file) as f:
        source = f.read()
    compiler = ForthCompiler()
    asm = compiler.compile(source)
    with open(out_file, "w") as f:
        f.write(asm)
