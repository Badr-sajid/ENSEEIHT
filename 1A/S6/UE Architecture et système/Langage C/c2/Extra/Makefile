# Définition des Variables (à compléter)
CC = gcc
CFLAGS = -Wextra -pedantic -c
LDFLAGS = 
EXE = -o
FILE = file_GEN
CAT = cat
CHAR = | sed -e 's/T_GEN/char/g' | sed -e 's/_GEN/_char/g' >

# Règles (à compléter avec des variables automatiques)
all: file_char.c test_file exemple_file

test_file: file_char.o test_file.o
	$(CC) $(LDFLAGS) $^ $(EXE) $@

exemple_file: file_char.o exemple_file.o
	$(CC) $(LDFLAGS) $^ $(EXE) $@

file_char.o: file_char.c
	$(CC) $(CFLAGS) $<

test_file.o: test_file.c
	$(CC) $(CFLAGS) $<

exemple_file.o: exemple_file.c
	$(CC) $(CFLAGS) $<

file_char.c: file_char.h
	$(CAT) $(FILE).c $(CHAR) $@

file_char.h:
	$(CAT) $(FILE).h $(CHAR) $@


makedepend:
	makedepend *.c -Y

clean:
	rm *.o test_file exemple_file file_char.c file_char.h
.PHONY: clean all makedepend

