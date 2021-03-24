#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <signal.h>   /* traitement des signaux */
#include <sys/wait.h>
#include <fcntl.h>
#include "readcmd.h"
#include "readcmd.c"
#include "listProcessus.h"
#include "listProcessus.c"

listProcessus ** LesProcessus;              // Liste des processus lancés
pid_t processus = 0;                        // Le processus en cours
bool ctrl_Z;
bool ctrl_c;
void handler_SIGCHLD(){
    int fils_termine, wstatus ;
    do {
        fils_termine = (int) waitpid(-1, &wstatus, WNOHANG | WUNTRACED | WCONTINUED);
        if ((fils_termine == -1) && (errno != ECHILD)) {
            perror("waitpid");
            exit(EXIT_FAILURE);
        } else if (fils_termine > 0){
            if WIFEXITED(wstatus) {
                if (Est_present(LesProcessus,fils_termine)){
                    modifierEtatCmd(LesProcessus,fils_termine,Termine);
                    processus = 0;
                }
            } else if (WIFCONTINUED(wstatus)) {
                if (Est_present(LesProcessus,fils_termine) && (ctrl_Z == false)){
                    modifierEtatCmd(LesProcessus,fils_termine,EnCours);
                }
            } else if (WIFSTOPPED(wstatus)) {
                if (ctrl_Z == false) {
                    if (Est_present(LesProcessus,fils_termine)){
                        modifierEtatCmd(LesProcessus,fils_termine,suspendu);
                    }
                }
            }
        }
    } while(fils_termine > 0);
}

void handler_SIGTSTP(){
    if (processus != 0) {
        kill(processus,SIGSTOP);
        printf("\n");
        printf("[%d]+ KILLED\n", processus);
        modifierEtatCmd(LesProcessus,processus,suspendu);
        ctrl_Z = true;
    }
    fflush(stdin);
}

void handler_SIGINT() {
    if (processus != 0) {
        kill(processus,SIGKILL);
        printf("\n");
        printf("[%d]+ KILLED\n", processus);
        modifierEtatCmd(LesProcessus,processus,Killed);
        ctrl_c = true;
    }
    fflush(stdin);
}

int main() {
    char repertoire[250];
    int retour;
    int p1[2], p2[2];           // Descripteur de pipe
    int n = 0;
    LesProcessus = malloc(200);
    struct cmdline* cmd;
    signal(SIGCHLD,handler_SIGCHLD);
    signal(SIGTSTP,handler_SIGTSTP);
    signal(SIGINT,handler_SIGINT);
    while(1) {
        printf("Badr@Sajid:%s ", getcwd(repertoire,250));
        cmd = readcmd();
        processus = 0;
        ctrl_Z = false;
        ctrl_c = false;
        
        signal(SIGCHLD,handler_SIGCHLD);
        signal(SIGTSTP,handler_SIGTSTP);
        signal(SIGINT,handler_SIGINT);
        
        if (cmd->seq[0] != NULL) {
            // ajoutant deux commandes internes (cd ,exit)
            if (strcmp(cmd->seq[0][0], "cd") == 0){
                chdir(cmd->seq[0][1]);
            } else if (strcmp(cmd->seq[0][0], "exit") == 0){
                exit(0);
                
            } else if (strcmp(cmd->seq[0][0], "list") == 0){
                afficherListe(LesProcessus);
                
            } else if (strcmp(cmd->seq[0][0], "stop") == 0){
                if (cmd->seq[0][1] == NULL){
                    printf("Error : identifiant de processus introuvable !\n");
                } else {
                    pid_t pid = pidcmd(LesProcessus,atoi(cmd->seq[0][1]));
                    
                    if ((Est_present(LesProcessus,pid))) {
                        if (etatcmd(LesProcessus,pid) == EnCours) {
                            printf("[%d]+ KILLED\n", pid);
                            kill(pid,SIGSTOP);
                            modifierEtatCmd(LesProcessus,pid,suspendu);
                        } else {
                            printf("Error : Processus is not Running !\n");
                        }
                    } else {
                        printf("Error : Processus introuvable !\n");
                    }
                }
                processus = 0;
                
            } else if (strcmp(cmd->seq[0][0], "bg") == 0){
                
                if (cmd->seq[0][1] == NULL){
                    printf("Error : identifiant de processus introuvable !\n");
                } else {
                    pid_t pid = pidcmd(LesProcessus,atoi(cmd->seq[0][1]));
                    if(Est_present(LesProcessus,pid)){
                        printf("Reprise du processus en arrière-plant !\n");
                        modifierEtatCmd(LesProcessus,pid,EnCours);
                        kill(pid,SIGCONT);
                    } else {
                        printf("Error : Processus introuvable !\n");
                    }
                }
                
            } else if (strcmp(cmd->seq[0][0], "fg") == 0){
                if (cmd->seq[0][1] == NULL){
                    printf("Error : identifiant de processus introuvable !\n");
                } else {
                    pid_t pid = pidcmd(LesProcessus,atoi(cmd->seq[0][1]));
                    if(Est_present(LesProcessus,pid)){
                        kill(pid,SIGCONT);
                        printf("Reprise du processus en avant-plant !\n");
                        modifierEtatCmd(LesProcessus,pid,EnCours);
                        processus = pid;
                        int status;
                        waitpid(pid,&status,WUNTRACED);
                        continue;
                    } else {
                        printf("Error : Processus introuvable !\n");
                        continue;
                    }
                    processus = pid;
                }
                processus = 0;
            } else {
                retour = fork() ;
                /* Bonne pratique : tester systématiquement le retour des appels système */
                if (retour < 0) {   /* échec du fork */
                    printf("Erreur fork\n") ;
                    /* Convention : s'arrêter avec une valeur > 0 en cas d'erreur */
                    exit(1);
                }
                
                /* fils */
                if (retour == 0) {
                    
                    if (!(cmd->in == NULL)) {
                        if( (int) freopen(cmd->in,"r",stdin) == -1){
                            fprintf(stderr, "%s\n",strerror(errno));
                        }
                    }
                    
                    if (!(cmd->out == NULL)) {
                        if( (int) freopen(cmd->out,"w",stdout) == -1){
                            fprintf(stderr, "%s\n",strerror(errno));
                        }
                    }
                    
                    // Q9. Tubes simples
                    if (!(cmd->seq[1] == NULL)){
                        // creation du pipe
                        if (pipe(p1) == -1){
                            perror("Error pipe\n");     /* échec du pipe */
                            exit(1);
                        }
                        int retour1 = fork();
                        /* Bonne pratique : tester systématiquement le retour des appels système */
                        if (retour1 < 0) {   /* échec du fork */
                            printf("Erreur fork\n") ;
                            exit(1);
                        }
                        /* fils */
                        else if (retour1 == 0) {
                            close(p1[0]);
                            if (dup2(p1[1],STDOUT_FILENO) == -1) {   /* échec du dup2 */
                                printf("Erreur dup2\n") ;
                                exit(EXIT_FAILURE) ;
                            }
                            if (execvp(cmd->seq[0][0], cmd->seq[0]) < 0) {
                                printf("Error\n");
                                exit(EXIT_FAILURE);
                            }
                            /* pere */
                        } else {
                            close(p1[1]);
                            if (dup2(p1[0],STDIN_FILENO) == -1) {   /* échec du dup2 */
                                printf("Erreur dup2\n") ;
                                exit(EXIT_FAILURE) ;
                            }
                            
                            if (execvp(cmd->seq[1][0], cmd->seq[1]) < 0) {
                                printf("Error\n");
                                exit(EXIT_FAILURE);
                            }
                        }
                    } else {
                        if (execvp(cmd->seq[0][0], cmd->seq[0]) < 0){
                            printf("Error\n");
                            exit(EXIT_FAILURE);
                        }
                    }
                    
                    // Q10. Pipelines
                    if (pipe(p1) == -1){
                        perror("Error pipe\n");     /* échec du pipe */
                        exit(1);
                    }
                    
                    int retour2 = fork();
                    /* Bonne pratique : tester systématiquement le retour des appels système */
                    if (retour2 < 0) {   /* échec du fork */
                        printf("Erreur fork\n") ;
                        exit(1);
                    }
                    /* fils */
                    else if (retour2 == 0) {
                        close(p1[0]);
                        if (dup2(p1[1],STDOUT_FILENO) == -1) {   /* échec du dup2 */
                            printf("Erreur dup2\n") ;
                            exit(EXIT_FAILURE) ;
                        }
                        close(p1[1]);
                        
                        if (pipe(p2) == -1){
                            perror("Error pipe\n");     /* échec du pipe */
                            exit(1);
                        }
                        int retour3 = fork();
                        /* Bonne pratique : tester systématiquement le retour des appels système */
                        if (retour3 < 0) {   /* échec du fork */
                            printf("Erreur fork\n") ;
                            exit(1);
                        }
                        /* fils */
                        else if (retour3 == 0) {
                            close(p2[0]);
                            if (dup2(p2[1],STDOUT_FILENO) == -1) {   /* échec du dup2 */
                                printf("Erreur dup2\n") ;
                                exit(EXIT_FAILURE) ;
                            }
                            close(p2[1]);
                            if (execvp(cmd->seq[0][0], cmd->seq[0]) < 0){
                                printf("Error\n");
                                exit(EXIT_FAILURE);
                            }
                        } else {
                            close(p2[1]);
                            if (dup2(p2[0],STDIN_FILENO) == -1) {   /* échec du dup2 */
                                printf("Erreur dup2\n") ;
                                exit(EXIT_FAILURE) ;
                            }
                            close(p2[0]);
                            
                            if (execlp(cmd->seq[1][0],cmd->seq[1][0],cmd->seq[1][1],NULL) < 0){
                                printf("Error\n");
                                exit(EXIT_FAILURE);
                            }
                        }
                    }
                    
                    /* pere */
                } else {
                    listProcessus *proc = malloc(512);
                    proc->pid = retour;
                    proc->Identifiant = ++n;
                    proc->etat = EnCours;
                    strcat(proc->commande,cmd->seq[0][0]);
                    AddCmd(LesProcessus,proc);
                    // Q5. L'ajout de commandes en tâche de fond
                    if (cmd->backgrounded == NULL){
                        processus = retour;
                        int status;
                        waitpid(retour,&status,WUNTRACED);
                        if (!WIFSTOPPED(status)) {
                            if ((Est_present(LesProcessus,retour)) && (ctrl_c != true) && (ctrl_Z != true)){
                                modifierEtatCmd(LesProcessus,retour,Termine);
                            }
                        }
                        processus = 0;
                    }
                }
            }
        }
    }
    exit(EXIT_SUCCESS);
}
