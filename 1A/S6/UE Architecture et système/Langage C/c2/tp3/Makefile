all: ephemeride EDT

# Ceci est un commentaire pour introdure la variable CC qui comporte le nom du compilateur utilisé :
CC=gcc

# Les variables CFLAGS et LDFLAGS comportent les options de compilation et d'édition des liens :
CFLAGS=-Wextra -pedantic -c
LDFLAGS=

depend: 
	makedepend *.c -Y.

ephemeride: date.o ephemeride.o
	$(CC) $(LDFLAGS) $^ -o $@	

EDT: salle.c date.c enseignant.c EDT.c 
	$(CC) $(LDFLAGS) $^ -o $@
clean:
	rm *.o ephemeride EDT
.PHONY: clean all
# DO NOT DELETE

EDT.o: cours.h salle.h date.h enseignant.h
cours.o: cours.h salle.h date.h enseignant.h
date.o: date.h
enseignant.o: enseignant.h date.h
ephemeride.o: date.h
salle.o: salle.h date.h
