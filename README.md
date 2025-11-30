# HPC Test Project

Este proyecto contiene ejemplos de algoritmos implementados de forma **secuencial** y **paralela (MPI)** para probar el rendimiento en un clúster de computación de alto rendimiento (HPC).

## Estructura del Proyecto

```text
.
├── makefile                # Script de compilación y distribución
├── run.sh                  # Script interactivo para ejecución
├── hosts                   # Archivo de definición de hosts para MPI
├── src/
│   ├── HPC/                # Códigos fuente paralelos (MPI)
│   │   ├── mult_vectores_MPI.c
│   │   ├── suma_vector_MPI.c
│   │   └── suma_vectores_MPI.c
│   └── Sequential/         # Códigos fuente secuenciales
│       ├── mult_vectores.c
│       ├── suma_vector.c
│       └── suma_vectores.c
└── bin/                    # Binarios compilados (generado automáticamente)
```

## Prerrequisitos

*   **Compilador C**: `gcc` (soporte para C2x recomendado).
*   **MPI**: Una implementación de MPI como `mpich` o `openmpi` (`mpicc` y `mpirun` deben estar en el PATH).
*   **Acceso SSH**: El entorno debe tener configurado el acceso SSH sin contraseña a los nodos definidos en el `makefile` (`hpc-node1` a `hpc-node4`).

## Compilación

El proyecto utiliza un `makefile` para compilar tanto las versiones secuenciales como las paralelas y distribuir los ejecutables a los nodos del clúster.

Para compilar todo y distribuir los binarios:

```bash
make all
```

Esto realizará las siguientes acciones:
1.  Creará el directorio `bin/`.
2.  Compilará los archivos de `src/Sequential/` usando `gcc`.
3.  Compilará los archivos de `src/HPC/` usando `mpicc`.
4.  Copiará los ejecutables MPI a todos los nodos (`user1@hpc-node[1-4]`).
5.  Copiará los ejecutables secuenciales al `node1`.

Para limpiar los archivos compilados:

```bash
make clean
```

## Ejecución

Se proporciona un script `run.sh` para facilitar la ejecución de los programas. Este script detecta automáticamente si el programa es secuencial o paralelo y utiliza el comando adecuado.

1.  Ejecuta el script:
    ```bash
    ./run.sh
    ```

2.  Verás un menú con los binarios disponibles. Ingresa el número del programa que deseas ejecutar.
    *   **Programas MPI** (terminan en `_MPI`): Se ejecutarán usando `mpirun` con 4 procesos distribuidos según el archivo `hosts`.
    *   **Programas Secuenciales**: Se ejecutarán remotamente en `hpc-node1` mediante SSH.

También puedes pasar el número de selección directamente como argumento:
```bash
./run.sh 1
```

## Descripción de los Programas

### Multiplicación de Vectores (Producto Punto)
*   **Archivos**: `mult_vectores.c` / `mult_vectores_MPI.c`
*   **Descripción**: Calcula la suma del producto de dos vectores de gran tamaño.
*   **Lógica MPI**: El vector se divide en partes iguales entre los procesos. Cada proceso calcula su suma local y luego se reducen los resultados en el proceso raíz (`MPI_Reduce`).

### Suma de Vector
*   **Archivos**: `suma_vector.c` / `suma_vector_MPI.c`
*   **Descripción**: Suma todos los elementos de un vector.

### Suma de Vectores
*   **Archivos**: `suma_vectores.c` / `suma_vectores_MPI.c`
*   **Descripción**: Suma dos vectores elemento a elemento y almacena el resultado en un tercer vector (o imprime verificación).
