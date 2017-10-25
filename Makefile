all: run

run:
	love .

moon:
	moonc *.moon
	moonc */*.moon
