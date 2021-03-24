all: test_UNO jouer_UNO
CC=gcc
CFLAGS=-Wextra -pedantic -c
LDFLAGS=

jouer_UNO: UNO.c carte.c main.c jeu.c jouer_UNO.c
	$(CC) $(LDFLAGS) $^ -o $@

test_UNO: UNO.c carte.c main.c jeu.c test_UNO.c
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm test_UNO jouer_UNO
.PHONY: clean all
