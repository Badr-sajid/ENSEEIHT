#include "aux.h"


void bottom_up(int nleaves, struct node **leaves, int nnodes);

int main(int argc, char **argv){
  long   t_start, t_end;
  int    nnodes, nleaves;
  struct node **leaves;

  // Command line argument: number of nodes in the tree
  if ( argc == 2 ) {
    nnodes = atoi(argv[1]); 
  } else {
    printf("Usage:\n\n ./main n\n\nwhere n is the number of nodes in the tree.\n");
    return 1;
  }

  printf("\nGenerating a tree with %d nodes\n\n",nnodes);
  generate_tree(nnodes, &leaves, &nleaves);
  
  t_start = usecs();
  bottom_up(nleaves, leaves, nnodes);
  t_end = usecs();
  
  printf("Parallel time : %8.2f msec.\n\n",((double)t_end-t_start)/1000.0);

  check_result();
  
}
  

/* You can change the number and type of arguments if needed.     */
/* Just don't forget to update the interface declaration above.   */
void bottom_up(int nleaves, struct node **leaves, int nnodes){

  /* Implement this routine */
  int i, j;
  int *tmp;
  struct node *mynode;

  tmp = (int *)malloc(nnodes*sizeof(int));
  for(i=0;i<nnodes;i++)
    *(tmp+i) = 0;

  #pragma omp parallel for private(mynode,j)
  for(i=0;i<nleaves;i++) {
    mynode = *(leaves+i);
    while(mynode != NULL) {
      j = 0;
      #pragma omp critical
      {
      if (*(tmp+(mynode->id - 1)) == 0) {
        *(tmp+(mynode->id - 1)) = 1;
        j = 1;
      }
      }
      if (j == 1) {
        process_node(mynode);
      }
      mynode = mynode->parent;
      
    }
  }
}
