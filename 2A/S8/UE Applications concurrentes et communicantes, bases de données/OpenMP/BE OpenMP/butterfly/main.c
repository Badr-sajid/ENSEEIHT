#include "aux.h"

void butterfly_seq(int n, int l, int *array);
void butterfly_par(int n, int l, int *array);

int main(int argc, char **argv){
  long   t_start, t_end;
  int    i, n, l, res;
  int    *array_seq, *array_par;

  if ( argc == 2 ) {
    l = atoi(argv[1]); 
  } else {
    printf("Usage:\n\n ./main l\n\nwhere l defines the size of the array  n=2^l.\n");
    return 1;
  }

  n = pow(2,l);
  
  printf("\nGenerating an array with %d elements\n",n);
  generate_array(n, &array_seq, &res);

  array_par = (int*)malloc(n*sizeof(int));
  for(i=0; i<n; i++)
    array_par[i] = array_seq[i];
    
  if(n<=32){
    printf("array_seq=[");
    for(i=0; i<n; i++){
      printf("%d ",array_seq[i]);
    }
    printf("]\n");
  }
  printf("The expected result is : %d\n\n\n\n",res);

  
  t_start = usecs();
  butterfly_seq(n, l, array_seq);
  t_end = usecs();
  
  printf("Sequential time : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  if(n<=32){
    printf("The result of the sequential reduction is\n");
    printf("array_seq=[");
    for(i=0; i<n; i++)
      printf("%d ",array_seq[i]);
    printf("]\n");
  }
  printf("\n\n\n");
  
  
  t_start = usecs();
  butterfly_par(n, l, array_par);
  t_end = usecs();
  
  printf("Parallel   time : %8.2f msec.\n",((double)t_end-t_start)/1000.0);
  
  if(n<=32){
    printf("The result of the parallel reduction is\n");
    printf("array_par=[");
    for(i=0; i<n; i++)
      printf("%d ",array_par[i]);
    printf("]\n\n");
  }
  
  check_result(n, array_par, res);
  
}
  
void butterfly_seq(int n, int l, int *array){

  int p, i, j, s;

  p = 0;
  
  while(p<l){
    s = pow(2,p);
    for(i=0; i<n; i+=2*s){
      for(j=0; j<s; j++){
        int r = operator(array[i+j],array[i+j+s]);
        array[i+j]   = r;
        array[i+j+s] = r;
      }
    }
    p+=1;
  }
}




void butterfly_par(int n, int l, int *array){

  int p, i, j, s;

  p = 0;

  #pragma omp parallel private(p) num_threads(4)
  {
  #pragma omp single
  while(p<l){
    s = pow(2,p);
    for(i=0; i<n; i+=2*s){
      for(j=0; j<s; j++){
        #pragma omp task depend(inout:array[i+j],array[i+j+s]) firstprivate(i,j,s)
        {
        int r = operator(array[i+j],array[i+j+s]);
        array[i+j]   = r;
        array[i+j+s] = r;
        }
      }
    }
    p+=1;
  }
  }
}

/* Réponse :
-- Pour num_threads(1) et n = 4 :

	Sequential time :     3.20 msec.

	Parallel   time :     3.21 msec.
-- Pour num_threads(1) et n = 8 :
	Sequential time :   102.44 msec.
	
	Parallel   time :   102.54 msec.

Donc pour n = 1 on a le même temps d'execution et ce qui est normal car on fait le parallelisme avec un seul processus

--------------------------------------------------------------------------------------------------

-- Pour num_threads(2) et n = 4 :
	Sequential time :     3.20 msec.

	Parallel   time :     1.76 msec.

-- Pour num_threads(2) et n = 8 :
	Sequential time :   102.64 msec.

	Parallel   time :    53.38 msec.

On remarque qu'avec deux processus le temps est amelioré.

--------------------------------------------------------------------------------------------------

-- Pour num_threads(4) et n = 4 :
	Sequential time :     3.20 msec.
	
	Parallel   time :     1.04 msec.

-- Pour num_threads(4) et n = 8 :
	Sequential time :   105.05 msec.

	Parallel   time :    48.84 msec.

On remarque que par rapport à 2 processus, le temps diminue plus et qui est dû à l'execution à l'aide de 4 processus qui se font au meme temps.
*/



