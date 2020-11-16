#include <iostream>
#include <thread>
#include <fstream>
#include <vector>
#include <mutex>
#include <ctime>
using namespace std;
mutex t_mutex;
void threadFunction(int sliceSize, int index, vector<int> first, int firstL, vector<int> second, int secondL, vector<int> third,
	int thirdL, vector<int> fourth, int fourthL, string path) {

	if (index != -1) {
		for (int x = index * sliceSize; x < (index * sliceSize + sliceSize); x++) {
			for (int i = 0; i < secondL; i++) {
				for (int j = 0; j < thirdL; j++) {
					for (int k = 0; k < fourthL; k++) {
						t_mutex.lock();
						cout << "{ " << first[x] << " " << second[i] << " " << third[j] << " " << fourth[k] <<
							" " << " }" << endl;
						t_mutex.unlock();
					}
				}
			}
		}
	}
	else {

		for (int x = sliceSize; x < firstL; x++) {
			for (int i = 0; i < secondL; i++) {
				for (int j = 0; j < thirdL; j++) {
					for (int k = 0; k < fourthL; k++) {
						t_mutex.lock();
						cout << "{ " << first[x] << " " << second[i] << " " << third[j] << " " << fourth[k] <<
							" " << " }" << endl;
						t_mutex.unlock();
					}
				}
			}
		}

	}
}
int main() {
	int threadNumber;
	vector<int> A1;
	vector<int> A2;
	vector<int> A3;
	vector<int> A4;
	ifstream in;
	in.open("../test4.txt");
	in >> threadNumber;
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
	vector<thread> thr;
	//thread *thr = new thread[threadNumber];
	thr.resize(threadNumber);
	int coun = 0;
	    for (int i=0 ; i<threadNumber; i++) {
			if (i != threadNumber - 1) {
				thr[i] = (thread{ threadFunction, A1.size() / (threadNumber-1), i, A1, A1.size(), A2, A2.size(), A3, A3.size(), A4, A4.size(), "../answer2.txt" });
				coun += A1.size() / (threadNumber - 1);
			}
			else {
				thr[i] = thread{ threadFunction,coun, -1, A1, A1.size(), A2, A2.size(), A3, A3.size(), A4, A4.size(),"../answer2.txt" };
			}
		}
		for (int i=0 ; i<threadNumber ; i++) {
			thr[i].join();

		}
	return 0;
}
	