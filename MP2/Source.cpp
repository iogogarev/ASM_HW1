#include <semaphore.h>
#include <ctime>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>
#include <thread>
#include <chrono>

using namespace std;

const int n = 3;
bool endMoment = false;
vector<int> table;
sem_t sem_fill;
sem_t sem_smoke;
pthread_mutex_t mutex_smoking;
bool isOnTable(vector<int> items, int item) {
	for (auto i : items) {
		if (item == i) {
			return true;
		}
	}
	return false;
}
void* Smoker(void* param) {
	int num = *((int*)param);
	while(!endMoment){
		sem_wait(&sem_smoke);
		if (table.size() == 0 || isOnTable(table, num)) {
			continue;
		}
		pthread_mutex_lock(&mutex_smoking);
		printf("Time %d. Smoker %d is making a cigarette and smoking. There were on table %d and %d\n",
			(int)clock(), num, table[0], table[1]);
		this_thread::sleep_for(chrono::milliseconds(rand() % 3000 + 2000));
		sem_post(&sem_fill);
		pthread_mutex_unlock(&mutex_smoking);
	}
	return nullptr;
}
void* Shoper(void* param) {
	int num = *((int*)param);
	for(int i = 0; i < num; i++){
		int item1 = (rand() % 3) + 1;
		int item2 = (rand() % 3) + 1;
		if (item1 == item2) {
			if (item1 == 3) {
				item2 = 2;
			}
			if (item1 == 2) {
				item2 = 1;
			}
			if (item1 == 1) {
				item2 = 3;
			}
		}
		table.clear();
		table.push_back(item1);
		table.push_back(item2);
		printf("Time %d. The Shoper go sleep. Now there are %d and %d on the table\n",
			(int)clock(), table[0], table[1]);
		this_thread::sleep_for(chrono::milliseconds(rand() % 3000 + 2000));
		sem_post(&sem_smoke);
		sem_post(&sem_smoke);
		sem_post(&sem_smoke);
		sem_wait(&sem_fill);
		
		
	}
	endMoment = true;
	table.clear();
	sem_post(&sem_smoke);
	sem_post(&sem_smoke);
	sem_post(&sem_smoke);
	return nullptr;
}
int main(int argc, char** argv) {
	printf("How many times times should Shoper fill the table?\n");
	int N;
	cin >> N;
	if (N < 0) {
		printf("Incorrect value! It should be >= 0\n");
		return 0;
	}
	printf("Let's start smoking process!\n");
	sem_init(&sem_fill, 0, 0);
	sem_init(&sem_smoke, 0, 0);
	pthread_mutex_init(&mutex_smoking, NULL);
	pthread_t thread_cook;
	pthread_create(&thread_cook, NULL, Shoper, (void*)&N);
	pthread_t thread_cannibals[n - 1];
	int thread_nums[n];
	for (int i = 0; i < n - 1; i++) {
		thread_nums[i] = i + 1;
		pthread_create(&thread_cannibals[i], NULL, Smoker, (void*)&thread_nums[i]);
	}
	thread_nums[n - 1] = n;
	Smoker((void*)&thread_nums[n - 1]);
	printf("Time %d. The smoke evening ended.", (int)clock());
	return 0;
}