/* version 0.2 (PM, 13/5/19) :
	Le serveur de conversation
	- crée un tube (fifo) d'écoute (avec un nom fixe : ./ecoute)
	- gère un maximum de maxParticipants conversations : select
		* tube d'écoute : accepter le(s) nouveau(x) participant(s) si possible
			-> initialiser et ouvrir les tubes de service (entrée/sortie) fournis
		* tubes (fifo) de service en entrée -> diffuser sur les tubes de service en sortie
	- détecte les déconnexions lors du select
	- se termine à la connexion d'un client de pseudo "fin"
	Protocole
	- suppose que les clients ont créé les tube d'entrée/sortie avant
		la demande de connexion, nommés par le nom du client, suffixés par _C2S/_S2C.
	- les échanges par les tubes se font par blocs de taille fixe, dans l'idée d'éviter
	  le mode non bloquant
*/

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

#include <stdbool.h>
#include <sys/stat.h>

#define MAXPARTICIPANTS 5			/* seuil au delà duquel la prise en compte de nouvelles
								 						 	   connexions sera différée */
#define TAILLE_MSG 128				/* nb caractères message complet (nom+texte) */
#define TAILLE_NOM 25					/* nombre de caractères d'un pseudo */
#define NBDESC FD_SETSIZE-1		/* pour le select (macros non definies si >= FD_SETSIZE) */
#define TAILLE_RECEPTION 512	/* capacité du tampon de messages reçus */

typedef struct ptp { 					/* descripteur de participant */
    bool actif;
    char nom [TAILLE_NOM];
    int in;		/* tube d'entrée (C2S) */
    int out;	/* tube de sortie (S2C) */
} participant;


participant participants [MAXPARTICIPANTS];

char buf[TAILLE_RECEPTION]; 	/* tampon de messages reçus/à rediffuser */
int nbactifs = 0;

void effacer(int i) { /* efface le descripteur pour le participant i */
    participants[i].actif = false;
    bzero(participants[i].nom, TAILLE_NOM*sizeof(char));
    participants[i].in = -1;
    participants[i].out = -1;
}

void diffuser(char *dep) { /* envoi du message référencé par dep à tous les actifs */
    /* à faire */
    for(int i = 0; i <= nbactifs; i++){
      write(participants[i].out,dep,TAILLE_MSG);
    }
}

void desactiver (int p) {
    /* traitement d'un participant déconnecté (à faire) */
    nbactifs--;
    snprintf(buf, TAILLE_MSG, "[SERVEUR] %s a quitté la conversation.\n", participants[p].nom);
    close(participants[p].in);
    close(participants[p].out);
    effacer(p);
}

void ajouter(char *dep) { // traite la demande de connexion du pseudo référencé par dep
/*  Si le participant est "fin", termine le serveur (et gère la terminaison proprement)
	Sinon, ajoute le participant de pseudo référencé par dep
	(à faire)
*/
        int C2S, S2C;
        char tubeC2S[TAILLE_NOM+5];
        char tubeS2C[TAILLE_NOM+5];
        char err_msg[80];

        sprintf(tubeC2S, "%s_C2S", dep);
        sprintf(tubeS2C, "%s_S2C", dep);
        
        if ((C2S = open(tubeC2S, O_RDONLY)) < 0){
            sprintf(err_msg, "open C2S: %s\n", tubeC2S);
            perror(err_msg);
            exit(1);
        }
        if ((S2C = open(tubeS2C, O_WRONLY, 0666)) < 0){
            sprintf(err_msg, "open S2C: %s\n", tubeS2C);
            perror(err_msg);
            exit(4);
        }
        
        participants[nbactifs].actif = true;
        strcpy(participants[nbactifs].nom, dep);
        participants[nbactifs].in = C2S;
        participants[nbactifs].out = S2C;
        
        nbactifs++;
    
}

int main (int argc, char *argv[]) {
    int i,nlus,necrits,res;
    int ecoute;					/* descripteur d'écoute */
    fd_set readfds; 		/* ensemble de descripteurs écoutés par le select */
    char * buf0; 				/* pour parcourir le contenu du tampon de réception */
	char bufDemandes [TAILLE_NOM*sizeof(char)*MAXPARTICIPANTS]; 
	/* tampon requêtes de connexion. Inutile de lire plus de MAXPARTICIPANTS requêtes */
    char pseudo[TAILLE_NOM];    // Pseudo entré
    /* création (puis ouverture) du tube d'écoute */
    mkfifo("./ecoute",S_IRUSR|S_IWUSR); // mmnémoniques sys/stat.h: S_IRUSR|S_IWUSR = 0600
    ecoute=open("./ecoute",O_RDONLY);

    for (i=0; i<= MAXPARTICIPANTS; i++) {
        effacer(i);
    }
		
    while (true) {
        printf("participants actifs : %d\n",nbactifs);

		/* boucle du serveur : traiter les requêtes en attente 
				 * sur le tube d'écoute : lorsqu'il y a moins de MAXPARTICIPANTS actifs.
				 	ajouter de nouveaux participants et les tubes d'entrée.			  
				 * sur les tubes de service : lire les messages sur les tubes c2s, et les diffuser.
				   Note : tous les messages comportent TAILLE_MSG caractères, et les constantes
           sont fixées pour qu'il n'y ait pas de message tronqué, ce qui serait  pénible 
           à gérer. Enfin, on ne traite pas plus de TAILLE_RECEPTION/TAILLE_MSG*sizeof(char)
           à chaque fois.
           - dans le cas où la terminaison d'un participant est détectée, gérer sa déconnexion
			
			(à faire)
		*/
        FD_ZERO(&readfds);
        FD_SET(ecoute, &readfds);
        
        for (i=0; i<nbactifs; i++) {
            FD_SET(participants[i].in, &readfds);
        }
        
        if (select(NBDESC, &readfds, NULL, NULL, NULL) > 0) {
            
            for (i=0; i<nbactifs; i++) {
                if (FD_ISSET(participants[i].in, &readfds)) {
                    bzero(buf,TAILLE_MSG);
                    if (read(participants[i].in, buf, TAILLE_MSG) < 0) {
                        perror("Lecture de message client");
                        exit(6);
                    } else {
                        diffuser(buf);
                    }
                }
            }
            
            if (FD_ISSET(ecoute, &readfds)) {
                bzero(pseudo,TAILLE_NOM);
                if (nbactifs < MAXPARTICIPANTS) {
                    if (read(ecoute, pseudo, TAILLE_NOM) < 0) {
                        perror("Fin de conversation\n");
                        exit(4);
                    } else {
                        if (strcmp(pseudo, "fin") == 0) {
                            bzero(buf,TAILLE_MSG);
                            const char * message = "[SERVEUR] Fermeture du serveur.\n"; 
                            strncpy(buf,message,TAILLE_RECEPTION);
                            diffuser(buf);
                            printf("Terminaison de la conversation.\n");
                            exit(3);
                        } else {
                            /* Sinon on ajoute le participant */
                            ajouter(pseudo);
                            printf("%s a rejoint la conversation.\n",pseudo);
                        }
                    }
                } else {
                    /* Si le chat est plein, on notifie l'utilisateur */
                    printf("Le chat est plein, veuillez patienter.\n");
                }
            }
            
        }
    }
    
    /* nettoyage */
    close(ecoute);
    unlink("./ecoute");
    return 0;
}
