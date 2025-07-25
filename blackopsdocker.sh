#!/bin/bash

# ================= DETECTAR RUTA RAÍZ DEL PROYECTO ================= #

# Ruta absoluta del script (resuelve symlinks si es instalado globalmente)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
PROJECT_ROOT="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"

COMPOSE_FILE="$PROJECT_ROOT/docker-compose.yml"

# ================= FUNCIONES ================= #

function print_header() {
  echo -e "\e[36m==> $1\e[0m"
}

function print_error() {
  echo -e "\e[31m[ERROR]\e[0m $1"
}

function check_compose_file() {
  if [[ ! -f "$COMPOSE_FILE" ]]; then
    print_error "No se encontró docker-compose.yml en $PROJECT_ROOT"
    exit 1
  fi
}

# ================= COMANDOS ================= #

case "$1" in
  up)
    check_compose_file
    print_header "Levantando servicios desde $COMPOSE_FILE"
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
  down)
    check_compose_file
    print_header "Deteniendo servicios desde $COMPOSE_FILE"
    docker compose -f "$COMPOSE_FILE" down
    ;;
  restart)
    check_compose_file
    print_header "Reiniciando servicios desde $COMPOSE_FILE"
    docker compose -f "$COMPOSE_FILE" down
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
  logs)
    check_compose_file
    docker compose -f "$COMPOSE_FILE" logs
    ;;
  ps)
    check_compose_file
    docker compose -f "$COMPOSE_FILE" ps
    ;;
  env)
    if [[ -f "$PROJECT_ROOT/.env" ]]; then
      echo "Contenido del archivo .env:"
      echo "----------------------------"
      cat "$PROJECT_ROOT/.env"
    else
      echo "No existe archivo .env en el proyecto."
    fi
    ;;
  prune)
    echo -e "\e[31m¡ADVERTENCIA!\e[0m Esto eliminará todos los volúmenes, redes y contenedores detenidos."
    read -p "¿Estás seguro? (s/N): " confirm
    if [[ "$confirm" == "s" || "$confirm" == "S" ]]; then
      docker system prune -a --volumes
    else
      echo "Cancelado."
    fi
    ;;
  help|--help|-h|"")
    echo -e "\e[36mBlackOpsDocker CLI\e[0m - Gestión de docker-compose principal"
    echo
    echo "Uso:"
    echo "  blackopsdocker <comando>"
    echo
    echo "Comandos disponibles:"
    echo "  up         - Levanta los servicios"
    echo "  down       - Detiene los servicios"
    echo "  restart    - Reinicia los servicios"
    echo "  logs       - Muestra los logs"
    echo "  ps         - Lista contenedores"
    echo "  env        - Muestra el archivo .env"
    echo "  prune      - Elimina recursos Docker detenidos"
    echo "  help       - Muestra esta ayuda"
    ;;
  *)
    print_error "Comando desconocido: $1"
    echo "Usa 'blackopsdocker help' para ver los comandos disponibles."
    exit 1
    ;;
esac
