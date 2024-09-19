all: kernel.o boot.o box.o libos.a
	aarch64-linux-gnu-ld -g -N -Ttext=0x10000 -o kernel.elf  kernel.o  boot.o box.o libos.a

kernel.o: kernel.c
	aarch64-linux-gnu-gcc -g -pedantic -Wall -Wextra -fPIC -std=gnu2x -MMD -c kernel.c -o kernel.o

box.o: box.S
	aarch64-linux-gnu-gcc -g -MMD -c box.S -o box.o

boot.o: boot.S
	aarch64-linux-gnu-gcc -g -MMD -c boot.S -o boot.o

clean:
	rm -f *.o *.d

run: kernel.elf
	qemu-system-aarch64 -machine raspi3b   -kernel kernel.elf

debug: kernel.elf
	qemu-system-aarch64 -machine raspi3b  -S -s -kernel kernel.elf &
	ddd --debugger 'gdb-multiarch -ex "target remote localhost:1234" -ex "break main" -ex "continue"' kernel.elf