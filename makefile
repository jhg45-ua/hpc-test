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
CFLAGS = -std=c23
MPICC = mpicc
BINDIR = bin
NODOS = user1@hpc-node1 user1@hpc-node2

SRC = $(wildcard *.c)
BIN = $(patsubst %.c,$(BINDIR)/%,$(SRC))

GREEN = \\033[1;32m
CYAN = \\033[1;36m
YELLOW = \\033[1;33m
RESET = \\033[0m

$(BINDIR):
	mkdir -p $(BINDIR)

all: $(BINDIR) $(BIN)
	@for exe in $(BIN); do \
        if echo $$exe | grep -q '_MPI$$'; then \
            for nodo in $(NODOS); do \
                scp $$exe $$nodo:~/hpc-test/bin/; \
            done; \
        fi; \
    done

$(BINDIR)/%: %.c | $(BINDIR)
	@if echo $@ | grep -q '_MPI$$'; then \
        $(MPICC) $(CFLAGS) $< -o $@; \
    else \
        $(CC) $(CFLAGS) $< -o $@; \
    fi


# Ejecutar solo el programa secuencial
run_seq:
	@for exe in $(BIN); do \
		if ! echo $$exe | grep -q '_MPI$$'; then \
			printf "\033[1;32mEjecutando $$exe...\033[0m\n"; \
			$$exe | awk '{print "\033[1;32m[SEQ] \033[0m" $$0}'; \
		fi; \
	done

# Ejecutar solo el programa MPI
run_hpc:
	@for exe in $(BIN); do \
		if echo $$exe | grep -q '_MPI$$'; then \
			printf "\033[1;36mEjecutando $$exe con mpirun...\033[0m\n"; \
			mpirun -np 3 --hostfile hosts $$exe | awk '{print "\033[1;33m[MPI] \033[0m" $$0}'; \
		fi; \
	done

clean:
	rm -rf $(BINDIR)/*