#!/bin/bash
# Script para listar y ejecutar binarios de la carpeta bin

BINDIR="$(dirname "$0")/bin"

if [ ! -d "$BINDIR" ]; then
    echo "No existe la carpeta bin. Compila primero."
    exit 1
fi

BINARIOS=($(ls "$BINDIR"))

if [ ${#BINARIOS[@]} -eq 0 ]; then
    echo "No hay binarios en $BINDIR."
    exit 1
fi

echo "Binarios disponibles:"
for i in "${!BINARIOS[@]}"; do
    echo "  $((i+1)). ${BINARIOS[$i]}"
done

if [ -n "$1" ]; then
    SELECCION=$1
else
    read -p "Elige el número del binario a ejecutar: " SELECCION
fi

if ! [[ "$SELECCION" =~ ^[0-9]+$ ]] || [ "$SELECCION" -lt 1 ] || [ "$SELECCION" -gt ${#BINARIOS[@]} ]; then
    echo "Selección inválida."
    exit 2
fi

BIN_ELEGIDO="${BINARIOS[$((SELECCION-1))]}"

# Detectar si es MPI por el nombre
if [[ "$BIN_ELEGIDO" == *_MPI ]]; then
    echo "Ejecutando $BIN_ELEGIDO con mpirun..."
    mpirun -np 3 --hostfile hosts "$BINDIR/$BIN_ELEGIDO"
else
    echo "Ejecutando $BIN_ELEGIDO..."
    "$BINDIR/$BIN_ELEGIDO"
fi
