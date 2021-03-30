#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <omp.h>

long usecs (){
  struct timeval t;

  gettimeofday(&t,NULL);
  return t.tv_sec*1000000+t.tv_usec;
}

double dnorm2_seq(double *x, int n);
double dnorm2_par_red(double *x, int n);
double dnorm2_par_nored(double *x, int n);


int main(int argc, char *argv[]){

  int n, i;
  double *x;
  double n2_seq, n2_par_red, n2_par_nored;
  long    t_start,t_end;

  
  if(argc!=2){
    printf("Wrong number of arguments.\n Usage:\n\n\
./main n \n\n where n is the size of the vector x whose 2-norm has to be computed.\n");
    return 1;
  }

  
  sscanf(argv[1],"%d",&n);

  
  x = (double*)malloc(sizeof(double)*n);

  for(i=0; i<n; i++)
    x[i] = ((double) rand() / (RAND_MAX));


  printf("\n================== Sequential version ==================\n");
  t_start = usecs();
  n2_seq       = dnorm2_seq(x, n);
  t_end = usecs();
  printf("Time (msec.) : %7.1f\n",(t_end-t_start)/1e3);
  printf("Computed norm is: %10.3lf\n",n2_seq);

  printf("\n\n=========== Parallel version with reduction  ===========\n");
  t_start = usecs();
  n2_par_red   = dnorm2_par_red(x, n);
  t_end = usecs();
  printf("Time (msec.) : %7.1f\n",(t_end-t_start)/1e3);
  printf("Computed norm is: %10.3lf\n",n2_par_red);


  printf("\n========== Parallel version without reduction ==========\n");
  t_start = usecs();
  n2_par_nored = dnorm2_par_nored(x, n);
  t_end = usecs();
  printf("Time (msec.) : %7.1f\n",(t_end-t_start)/1e3);
  printf("Computed norm is: %10.3lf\n",n2_par_nored);


  printf("\n\n");
  if(fabs(n2_seq-n2_par_red)/n2_seq > 1e-10) {
    printf("The parallel version with reduction is numerically wrong! \n");
  } else {
    printf("The parallel version with reduction is numerically okay!\n");
  }
  
  if(fabs(n2_seq-n2_par_nored)/n2_seq > 1e-10) {
    printf("The parallel version without reduction is numerically wrong!\n");
  } else {
    printf("The parallel version without reduction is numerically okay!\n");
  }
  
  return 0;

}



double dnorm2_seq(double *x, int n){
  int i;
  double res;

  res = 0.0;

  for(i=0; i<n; i++)
    res += x[i]*x[i];

  return sqrt(res);
  
}

double dnorm2_par_red(double *x, int n){
  int i;
  double res;

  res = 0.0;
  #pragma omp parallel for reduction(+:res) num_threads(4)
  for(i=0; i<n; i++)
    res += x[i]*x[i];
  
  return sqrt(res);
  
}

double dnorm2_par_nored(double *x, int n){
  int i;
  double res, tmp;

  res = 0.0;
  tmp = 0.0;
  
  #pragma omp parallel firstprivate(tmp) num_threads(4)
  {
  #pragma omp for
  for(i=0; i<n; i++)
    tmp += x[i]*x[i];
  #pragma omp atomic update
  res += tmp;
  }
  return sqrt(res);
  
}



/* Réponse :
-- Pour num_threads(2) et n = 100 :

	================== Sequential version ==================
	Time (msec.) :     0.0
	Computed norm is:      6.161


	=========== Parallel version with reduction  ===========
	Time (msec.) :     0.1
	Computed norm is:      6.161

	========== Parallel version without reduction ==========
	Time (msec.) :     0.0
	Computed norm is:      6.161



-- Pour num_threads(2) et n = 100000 :
	================== Sequential version ==================
	Time (msec.) :     0.4
	Computed norm is:    182.526


	=========== Parallel version with reduction  ===========
	Time (msec.) :     0.3
	Computed norm is:    182.526

	========== Parallel version without reduction ==========
	Time (msec.) :     0.2
	Computed norm is:    182.526


-- Pour num_threads(2) et n = 10000000 :

	================== Sequential version ==================
	Time (msec.) :    11.9
	Computed norm is:   1825.795


	=========== Parallel version with reduction  ===========
	Time (msec.) :     6.3
	Computed norm is:   1825.795

	========== Parallel version without reduction ==========
	Time (msec.) :     6.2
	Computed norm is:   1825.795



--------------------------------------------------------------------------------------------------

-- Pour num_threads(4) et n = 100 :

	================== Sequential version ==================
	Time (msec.) :     0.0
	Computed norm is:      6.161


	=========== Parallel version with reduction  ===========
	Time (msec.) :     0.2
	Computed norm is:      6.161

	========== Parallel version without reduction ==========
	Time (msec.) :     0.1
	Computed norm is:      6.161


-- Pour num_threads(4) et n = 100000 :
	================== Sequential version ==================
	Time (msec.) :     0.4
	Computed norm is:    182.526


	=========== Parallel version with reduction  ===========
	Time (msec.) :     0.4
	Computed norm is:    182.526

	========== Parallel version without reduction ==========
	Time (msec.) :     0.1
	Computed norm is:    182.526

-- Pour num_threads(4) et n = 10000000 :

	================== Sequential version ==================
	Time (msec.) :    11.9
	Computed norm is:   1825.795


	=========== Parallel version with reduction  ===========
	Time (msec.) :     3.3
	Computed norm is:   1825.795

	========== Parallel version without reduction ==========
	Time (msec.) :     3.2
	Computed norm is:   1825.795


On remarque que temps que plus n est grand plus les version parallel deviennent plus rapide et ce qui est logique car avec un nombre n petit on a un surcoût pour la creation des region parallel.
Par contre on remarque que la version without reduction est plus rapide que celle with reduction et cela est du à l'execution parallel de toute la boucle et non pas seulement que celle de la reduction. Car on peut avoir des processus qui calcul le produit alors que d'autre font la somme et comme ça on attend pas la fin de tout les processus pour faire la somme ce qui nous fait perdre le temps.
*/
