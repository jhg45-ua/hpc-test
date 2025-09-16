# Mostrar ayuda de los comandos disponibles
help:
	@echo "\033[1;36mComandos disponibles en este Makefile:\033[0m"
	@echo "  \033[1;33mall\033[0m      : Compila todos los programas y distribuye binarios MPI a los nodos."
	@echo "  \033[1;33mrun_seq\033[0m  : Ejecuta solo el programa secuencial."
	@echo "  \033[1;33mrun_hpc\033[0m  : Ejecuta solo el programa HPC en paralelo."
	@echo "  \033[1;33mclean\033[0m    : Elimina los binarios compilados."
	@echo "  \033[1;33mhelp\033[0m     : Muestra esta ayuda."

# Compilador y flags
CC = gcc
CFLAGS = -std=c23 -O3
MPICC = mpicc
BINDIR = bin
NODOS = user1@hpc-node1 user1@hpc-node2 user1@hpc-node3 user1@hpc-node4
NODE1 = user1@hpc-node1

# Fuentes
SEQ_SRC = $(wildcard src/Sequential/*.c)
MPI_SRC = $(wildcard src/HPC/*.c)

# Binarios
SEQ_BIN = $(patsubst src/Sequential/%.c,$(BINDIR)/%,$(SEQ_SRC))
MPI_BIN = $(patsubst src/HPC/%.c,$(BINDIR)/%,$(MPI_SRC))
BIN = $(SEQ_BIN) $(MPI_BIN)

$(BINDIR):
	mkdir -p $(BINDIR)

all: $(BINDIR) $(BIN)
	@echo "Distribuyendo binarios MPI a todos los nodos..."
	@for exe in $(MPI_BIN); do \
		for nodo in $(NODOS); do \
			scp $$exe $$nodo:~/hpc-test/bin/; \
		done; \
	done
	@echo "Distribuyendo binarios secuenciales al node1..."
	@for exe in $(SEQ_BIN); do \
		scp $$exe $(NODE1):~/hpc-test/bin/; \
	done

# Regla para secuenciales
$(BINDIR)/%: src/Sequential/%.c | $(BINDIR)
	$(CC) $(CFLAGS) $< -o $@

# Regla para MPI
$(BINDIR)/%: src/HPC/%.c | $(BINDIR)
	$(MPICC) $(CFLAGS) $< -o $@

clean:
	rm -rf $(BINDIR)/*