KUP_TARGET = hello.kup
PGZ_TARGET = hello.pgz

all: $(KUP_TARGET) $(PGZ_TARGET)

$(KUP_TARGET): test.o
	@xlink -cfxf256jrs -ffxkup -sEntry -o$@ $^

$(PGZ_TARGET): test.o
	@xlink -cfxf256jrs -ffxpgz -sEntry -o$@ $^

test.o: test.asm
	@motor6502 -w0008 -fx -o$@ -mc2 $^

clean:
	@rm -f $(KUP_TARGET) $(PGZ_TARGET) test.o
