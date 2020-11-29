#include <iostream>
#include <thread>
#include <fstream>
#include <vector>
#include <mutex>
#include <string>
#include <ctime>
#include <omp.h>
using namespace std;
void MakeResult(vector<string>* v,int k, int a, int b, int c, int d){
    string str = "Thread + " + to_string(k)+":  { " +to_string(a)+ " " + to_string(b) + " "
                 + to_string(c) + " " + to_string(d) +
                 " " +" }\n";
    v->push_back(str);
}
int main(int argc, char** args) {
    int threadNumber;
    vector<int> A1;
    vector<int> A2;
    vector<int> A3;
    vector<int> A4;
    ifstream in;
    in.open(args[1]);
    in >> threadNumber;
    cout << threadNumber << endl;
    int counter;
    int elem;
    in >> counter;
    for (int i = 0; i < counter; i++) {
        in >> elem;
        A1.push_back(elem);
    }
    in >> counter;
    for (int i = 0; i < counter; i++) {
        in >> elem;
        A2.push_back(elem);
    }
    in >> counter;
    for (int i = 0; i < counter; i++) {
        in >> elem;
        A3.push_back(elem);
    }
    in >> counter;

    for (int i = 0; i < counter; i++) {
        in >> elem;
        A4.push_back(elem);
    }
    in.close();
    int x, i, j, k;
    vector<string>* result = new vector<string>();
#pragma omp shared(result)
    {
#pragma omp parallel for private(x, i , j, k) num_threads(threadNumber)
        for (x = 0; x < A1.size(); x++) {
            for (i = 0; i < A2.size(); i++) {
                for (j = 0; j < A3.size(); j++) {
                    for (k = 0; k < A4.size(); k++) {

                        MakeResult(result, omp_get_thread_num(),A1[x], A2[i], A3[j], A4[k]);

                    }
                }
            }
        }
#pragma barrier
        {
            for(int i = 0; i < result->size(); i++){
                cout << (*result)[i] << endl;
            }
        }
    }

    return 0;
}