#define _GNU_SOURCE
#include <stdio.h>
#include <time.h>
#include <unistd.h>

int main() {
    long long n = 1000000002; // Array de 9 mil millones de elementos - 10ˆ9
    long long sum = 0;
    char hostname[256];

    gethostname(hostname, sizeof(hostname));

    clock_t start = clock();
    for (long long i = 0; i < n; i++) {
        sum += 1;
    }
    clock_t end = clock();

    double tiempo = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Nodo %s (secuencial): suma local = %lld, tiempo = %f segundos\n", hostname, sum, tiempo);
    printf("\n--- RESUMEN ---\n");
    printf("La suma total es: %lld\n", sum);
    printf("Tiempo total de ejecución: %f segundos\n", tiempo);

    return 0;
}