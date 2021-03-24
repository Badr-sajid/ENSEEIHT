#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <string.h>
#include "listProcessus.h"


int tailleListe(listProcessus **LesProcessus){
    int i = 0;
    while(!(LesProcessus[i] == NULL)){
        i++;
    }
    return i;
}

int positionprocessus(listProcessus **LesProcessus, pid_t pidProcessus){
    int i = 0;
    int pos = -1;
    while(!(LesProcessus[i] == NULL)){
        if (LesProcessus[i]->pid == pidProcessus) {
            pos = i;
            break;
        }
        i++;
    }
    return pos;
}

pid_t pidcmd(listProcessus **LesProcessus, int id){
    int i = 0;
    int pid = -1;
    while(!(LesProcessus[i] == NULL)){
        if (LesProcessus[i]->Identifiant == id) {
            pid = LesProcessus[i]->pid;
            break;
        }
        i++;
    }
    return pid;
}

bool Est_present(listProcessus **LesProcessus, pid_t pid){
    return !(positionprocessus(LesProcessus,pid) == -1);
}

void AddCmd(listProcessus **LesProcessus, listProcessus *processus) {
    if (! Est_present(LesProcessus,processus->pid)) {
        int n = tailleListe(LesProcessus);
        LesProcessus[n] = xmalloc(512);
        LesProcessus[n]->Identifiant = processus->Identifiant;
        LesProcessus[n]->pid = processus->pid;
        LesProcessus[n]->etat = EnCours;
        strcpy(LesProcessus[n]->commande,processus->commande);
    }
}

void SupprimerCmd(listProcessus **LesProcessus, pid_t pid){
    if (Est_present(LesProcessus,pid)) {
        int n = tailleListe(LesProcessus);
        int pos = positionprocessus(LesProcessus,pid);
        for (int i = pos+1; i < n; i++){
            *(LesProcessus[i-1]) = *(LesProcessus[i]);
        }
        free(LesProcessus[n-1]);
        LesProcessus[n-1] = NULL;
        LesProcessus = calloc(n-1,sizeof(LesProcessus));
    }
}

void modifierEtatCmd(listProcessus **LesProcessus, pid_t pid, Etat newEtat){
    if (Est_present(LesProcessus,pid)) {
        int pos = positionprocessus(LesProcessus, pid);
        LesProcessus[pos]->etat = newEtat;
    }
}

void afficherListe(listProcessus **LesProcessus){
    int n = tailleListe(LesProcessus);
    if (n>0){
        printf("id\t pid\t etat\t\tcommande\n");
        for (int i = 0; i<n; i++) {
            int id = LesProcessus[i]->Identifiant;
            int pid = LesProcessus[i]->pid;
            char *status;
            switch (LesProcessus[i]->etat){
                case EnCours : status = "En cours"; break;
                case Termine : status = "Termine"; break;
                case suspendu : status = "suspendu"; break;
                case Killed : status = "Killed"; break;
            }
            printf("[%d]\t %d\t %s\t",id,pid, status);
            if (LesProcessus[i]->etat == Killed){
                printf("\t");
            }
            printf("%s\n",LesProcessus[i]->commande);
        }
    } else {
        printf("La liste est vide !\n");
    }
}

Etat etatcmd(listProcessus **LesProcessus,pid_t pid) {
    Etat etat;
    if (Est_present(LesProcessus,pid)) {
        int pos = positionprocessus(LesProcessus, pid);
        etat = LesProcessus[pos]->etat;
    }
    return etat;
}
