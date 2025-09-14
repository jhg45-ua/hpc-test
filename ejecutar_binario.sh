BOLD="\033[1m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"
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


# Si se pasan argumentos, ejecuta cada uno; si no, muestra la lista y pide selección
if [ $# -gt 0 ]; then
    SELECCIONES=("$@")
else
    echo -e "${CYAN}Binarios disponibles:${RESET}"
    for i in "${!BINARIOS[@]}"; do
        echo -e "  ${YELLOW}$((i+1)).${RESET} ${BOLD}${BINARIOS[$i]}${RESET}"
    done
    read -p "Elige el/los número(s) de binario a ejecutar (separados por espacio): " -a SELECCIONES
fi

for SELECCION in "${SELECCIONES[@]}"; do
    if ! [[ "$SELECCION" =~ ^[0-9]+$ ]] || [ "$SELECCION" -lt 1 ] || [ "$SELECCION" -gt ${#BINARIOS[@]} ]; then
        echo "Selección inválida: $SELECCION"
        continue
    fi
    BIN_ELEGIDO="${BINARIOS[$((SELECCION-1))]}"
    if [[ "$BIN_ELEGIDO" == *_MPI ]]; then
        echo -e "${CYAN}Ejecutando $BIN_ELEGIDO con mpirun...${RESET}"
        mpirun -np 3 --hostfile hosts "$BINDIR/$BIN_ELEGIDO" | awk -v c="${YELLOW}" -v r="${RESET}" '{print c"[HPC] "r $0}'
    else
        echo -e "${GREEN}Ejecutando $BIN_ELEGIDO...${RESET}"
        "$BINDIR/$BIN_ELEGIDO" | awk -v c="${GREEN}" -v r="${RESET}" '{print c"[SEQ] "r $0}'
    fi
    echo -e "${BOLD}-----------------------------${RESET}"
done
