#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void pipeline(data *datas, resource *resources, int ndatas, int nsteps);


int main(int argc, char **argv){
  int   n, i, s, d, ndatas, nsteps;
  long  t_start, t_end;
  data *datas;
  resource *resources;

  // Command line arguments
  if ( argc == 3 ) {
    ndatas  = atoi(argv[1]);    /* num of datas */
    nsteps  = atoi(argv[2]);    /* num of steps */
  } else {
    printf("Usage:\n\n ./main ndatas nsteps\n where ndatas is the number of data and nsteps the number of steps.\n");
    return 1;
  }

  init_data(&datas, &resources, ndatas, nsteps);
  
  /* Process all the data */
  t_start = usecs();
  pipeline(datas, resources, ndatas, nsteps);
  t_end = usecs();
  printf("Execution   time    : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  
  check_result(datas, ndatas, nsteps);
  
  return 0;
  
}



void pipeline(data *datas, resource *resources, int ndatas, int nsteps){

  int d, s;

  omp_lock_t *lock;
  lock = (omp_lock_t *)malloc(nsteps*sizeof(omp_lock_t));
  for(int i=0;i<nsteps;i++)
    omp_init_lock(lock+i);
  
  /* Loop over all the data */
  #pragma omp parallel for private(s) num_threads(2)
  for (d=0; d<ndatas; d++){
    /* Loop over all the steps */
    for (s=0; s<nsteps; s++){
      omp_set_lock(lock+s);
      process_data(datas, d, s, &(resources[s]));
      omp_unset_lock(lock+s);
    }
  }
    
  for(int i=0;i<nsteps;i++)
    omp_destroy_lock(lock+i);
}


/* Réponse :
Pour la version séquentielle le temps d'execution est :

-- Pour ndatas = 5 nsteps = 10 :  Execution   time    :  1000.00 msec.
-- Pour ndatas = 10 nsteps = 2 :  Execution   time    :  2000.00 msec.
-- Pour ndatas = 15 nsteps = 20 :  Execution   time    :  3000.00 msec.
-- Pour ndatas = 20 nsteps = 10 :  Execution   time    :  4000.00 msec.



Pour la version parallèle et pour num_threads(2), le temps d'execution est :

-- Pour ndatas = 5 nsteps = 10 :  Execution   time    :  600.13 msec.
-- Pour ndatas = 10 nsteps = 2 :  Execution   time    :  1100.18 msec.
-- Pour ndatas = 15 nsteps = 20 :  Execution   time    :  1600.32 msec.
-- Pour ndatas = 15 nsteps = 2 :  Execution   time    :  1600.16 msec.
-- Pour ndatas = 15 nsteps = 200 :  Execution   time    :  1600.30 msec.
-- Pour ndatas = 20 nsteps = 10 :  Execution   time    :  2020.13 msec.



Pour la version parallèle et pour num_threads(4), le temps d'execution est :

-- Pour ndatas = 5 nsteps = 10 :  Execution   time    :  1460.32 msec.
-- Pour ndatas = 10 nsteps = 2 :  Execution   time    :  1100.35 msec.
-- Pour ndatas = 15 nsteps = 20 :  Execution   time    :  854.20 msec.
-- Pour ndatas = 15 nsteps = 2 :  Execution   time    :  1700.36msec.
-- Pour ndatas = 15 nsteps = 200 :  Execution   time    :  805.79 msec.
-- Pour ndatas = 20 nsteps = 10 :  Execution   time    :  1074.43 msec.



Conclusion :
On remarque que pour des données faibles, moins est le nombre de processus plus le temps d'execution est rapide, par contre pour des données assez grande la version parallele avec plus de processus est beaucoup plus meilleure en terme de temps.

*/

