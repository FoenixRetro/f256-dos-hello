TARGET = hello

$(TARGET): test.asm
	@motor6502 -w0008 -fb -o$@ -mc2 $^

clean:
	@rm -f $(TARGET)
