#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

int main() {
    long long n = 900000; // Cambia el tamaño si lo deseas
    long long sum = 0;
    char hostname[256];

    int *a = malloc(n * sizeof(int));
    int *b = malloc(n * sizeof(int));
    for (long long i = 0; i < n; i++) {
        a[i] = 1;
        b[i] = 1;
    }

    gethostname(hostname, sizeof(hostname));

    clock_t start = clock();
    for (long long i = 0; i < n; i++) {
        sum += a[i] + b[i];
    }
    clock_t end = clock();

    double tiempo = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Nodo %s (secuencial): suma local = %lld, tiempo = %f segundos\n", hostname, sum, tiempo);
    printf("\n--- RESUMEN ---\n");
    printf("La suma total es: %lld\n", sum);
    printf("Tiempo total de ejecución: %f segundos\n", tiempo);

    free(a);
    free(b);
    return 0;
}