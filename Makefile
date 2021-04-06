all: jag2.out

jag2.out: jag2.s
	arm-linux-gnueabi-gcc jag2.s -o jag2.out -static

