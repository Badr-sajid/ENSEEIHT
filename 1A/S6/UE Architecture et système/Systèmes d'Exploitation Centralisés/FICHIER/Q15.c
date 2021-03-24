#include <stdio.h>    /* Input & Output */
#include <stdlib.h>   /* exit */
#include <unistd.h>   /* Basic primitives : fork, read, write, ...*/
#include <sys/wait.h> /* wait */
#include <string.h>   /* String operations */
#include <fcntl.h>    /* Files operations */


int main(int argc, char** argv) {
    
    int desc;
    int i;                        
    char file_temp[] = "temp.txt";
    pid_t retour;
    int n;
    
    retour = fork();
    /* Bonne pratique : tester systématiquement le retour des appels système */
    if (retour < 0) {   /* échec du fork */
        printf("Erreur fork\n") ;
        /* Convention : s'arrêter avec une valeur > 0 en cas d'erreur */
        exit(1) ;
    }

    /* fils */
    if (retour == 0) {
        // Ouverture du fichier
        desc = open(file_temp, O_WRONLY|O_CREAT|O_TRUNC, 0640);

        /* traiter systématiquement les retours d'erreur des appels */
        if (desc < 0) {
            perror("Erreur ouverture temp.txt ");
            exit(1);
        }
	
        for (i = 1; i <= 30; i++) {
            sleep(1);
            if (write(desc, &i, sizeof(int)) < 0) {
                perror("Erreur ecriture ");
                exit(1);
            }
            printf("CHILD = %d\n", i);
            if (i == 10 || i == 20) {
                if (lseek(desc, 0, SEEK_SET) < 0) {
                    perror("Erreur LSEEK ");
                    exit(1);
                }
            }
        }
        // Fermiture du fichier
        if (close(desc) < 0) {
            perror("Erreur fermiture temp.txt ");
            exit(1);
        }
        exit(0);
    }

    if (retour > 0) {
        // Ouverture du fichier
        desc = open(file_temp, O_RDONLY|O_CREAT, 0640);
        
        /* traiter systématiquement les retours d'erreur des appels */
        if (desc < 0) {
            perror("Erreur ouverture temp.txt ");
            exit(1);
        }
        
        sleep(1);
        for (i = 1; i <= 3; i++) {
            sleep(10);
            while(read(desc, &n, sizeof(int))) {
                printf("%d\n", n);
            }
            if (lseek(desc, 0, SEEK_SET) < 0) {
                perror("Erreur LSEEK ");
                exit(1);
            }
        }

        // Fermiture du fichier
        if (close(desc) < 0) {
            perror("Erreur fermiture temp.txt ");
            exit(1);
        }

    }
    return EXIT_SUCCESS;
}
