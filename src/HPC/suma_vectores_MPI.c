#define _GNU_SOURCE
#include <mpi/mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char** argv) {
    long long n = 1000000002; // Cambia el tamaño si lo deseas
    int rank, size;
    long long local_n, start, end;
    long long local_sum = 0, total_sum = 0;
    char hostname[256];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    gethostname(hostname, sizeof(hostname));

    local_n = n / size;
    start = rank * local_n;
    end = (rank == size - 1) ? n : start + local_n;

    // Reservar memoria solo para la parte local
    int *a = malloc(local_n * sizeof(int));
    int *b = malloc(local_n * sizeof(int));
    for (long long i = 0; i < local_n; i++) {
        a[i] = 1;
        b[i] = 1;
    }

    double total_start = 0;
    if (rank == 0) {
        total_start = MPI_Wtime();
    }

    double t0 = MPI_Wtime();
    for (long long i = 0; i < local_n; i++) {
        local_sum += a[i] + b[i];
    }
    double t1 = MPI_Wtime();

    printf("Nodo %s (rank %d): suma local = %lld, tiempo = %f segundos\n",
           hostname, rank, local_sum, t1 - t0);

    MPI_Reduce(&local_sum, &total_sum, 1, MPI_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        double total_end = MPI_Wtime();
        printf("\n--- RESUMEN ---\n");
        printf("La suma total es: %lld\n", total_sum);
        printf("Tiempo total de ejecución: %f segundos\n", total_end - total_start);
    }

    free(a);
    free(b);
    MPI_Finalize();
    return 0;
}