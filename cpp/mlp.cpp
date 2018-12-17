#include <cstdlib>
#include <ctime>
#include <cmath>
#include <iostream>
using namespace std;

const int numpats = 4;
const int numinputs = 2;
float rate = 1;
float inputs [numinputs+1][numpats];
float desired [numpats];
float weights [numinputs+1];
float output [numpats];
float error [numpats];
float correction [numinputs+1];
float TSS = 1;
int setup = 1;

int main(){
srand((unsigned)time(0));
//SETUP
if(setup == 1){	
  for(int i=0;i<numinputs+1;i++){
    for(int j=0;j<numpats;j++){
      if(i == 0){
         inputs[i][j] = 1;
         weights[i] = ((floor(rand()%10000)/10000)*2)-1;
      }
      else{
        inputs[i][j] = ((floor(rand()%10000)/10000)*2)-1;
        weights[i] = ((floor(rand()%10000)/10000)*2)-1;
      }
      desired[j] = ((floor(rand()%10000)/10000));
    }
  }
  setup = 0;
}
//LOOP
for(int k=0;k<10000;k++){
  for(int j=0;j<numpats;j++){
    output[j] = 0;
    for(int i=0;i<numinputs+1;i++){
      output[j] = output[j] + weights[i] * inputs[i][j];
    }
    output[j] = 1 / (1+exp(-output[j]));
    if(TSS < 0.0001){
      cout << TSS << endl;
      cout << "done" << endl;
      return 0;
    }else{
      error[j] = desired[j] - output[j];
      TSS = 0;
      for(int a=0;a<numpats;a++){
        TSS = TSS + pow(error[a],2);
      }
      for(int i=0;i<numinputs+1;i++){
        correction[i] = error[j] * output[j]*(1-output[j])*inputs[i][j];
        weights[i] = weights[i] + correction[i];
      }
      cout << TSS << endl;
      }
  }
}   
}
