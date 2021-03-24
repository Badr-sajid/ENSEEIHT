#include <stdbool.h>
#ifndef _LISTEPROCESSUS_H
#define _LISTEPROCESSUS_H

// Les etats possible d'un processeur
enum Etat{EnCours,Termine,Killed,suspendu};
typedef enum Etat Etat;

// liste des commandes
struct listProcessus {
    int Identifiant;
    pid_t pid;
    Etat etat;
    char commande[200];
};
typedef struct listProcessus listProcessus;

int positionprocessus(listProcessus **LesProcessus, pid_t pidProcessus);

pid_t pidcmd(listProcessus **LesProcessus, int id);

bool Est_present(listProcessus **LesProcessus, pid_t pid);

void AddCmd(listProcessus **LesProcessus, listProcessus *processus);

void SupprimerCmd(listProcessus **LesProcessus, pid_t pid);

//void modifierEtatCmd(Lalist **list, pid_t pid, char *newEtat);
void modifierEtatCmd(listProcessus **LesProcessus, pid_t pid, Etat newEtat);

void afficherListe(listProcessus **LesProcessus);

Etat etatcmd(listProcessus **LesProcessus,pid_t pid);

#endif

