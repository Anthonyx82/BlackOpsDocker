#!/bin/bash

# PROJECT_ROOT será inyectado por el instalador. No editar manualmente.
PROJECT_ROOT="${PROJECT_ROOT:-}"

# ================= FUNCIONES ================= #

function print_header() {
  echo -e "\e[36m==> $1\e[0m"
}

function print_error() {
  echo -e "\e[31m[ERROR]\e[0m $1"
}

function check_project_root() {
  if [[ -z "$PROJECT_ROOT" || ! -d "$PROJECT_ROOT" || ! -f "$PROJECT_ROOT/.env" ]]; then
    print_error "No se pudo encontrar la raíz del proyecto (se espera carpeta con .env y subdirectorios con docker-compose)."
    exit 1
  fi
}

function list_services() {
  echo "Servicios detectados:"
  find "$PROJECT_ROOT" -mindepth 2 -maxdepth 2 -name "docker-compose.yml" -exec dirname {} \; | sed "s|$PROJECT_ROOT/|- |"
}

function run_in_services() {
  local cmd="$1"
  shift
  find "$PROJECT_ROOT" -mindepth 2 -maxdepth 2 -name "docker-compose.yml" | while read -r compose_file; do
    local dir
    dir=$(dirname "$compose_file")
    print_header "Ejecutando 'docker compose $cmd' en $(basename "$dir")"
    (cd "$dir" && docker compose "$cmd" "$@")
    echo
  done
}

# ================= COMANDOS ================= #

case "$1" in
  up)
    check_project_root
    run_in_services up -d
    ;;
  down)
    check_project_root
    run_in_services down
    ;;
  restart)
    check_project_root
    run_in_services down
    run_in_services up -d
    ;;
  logs)
    check_project_root
    run_in_services logs
    ;;
  ps)
    check_project_root
    run_in_services ps
    ;;
  env)
    check_project_root
    echo "Contenido del archivo .env:"
    echo "----------------------------"
    cat "$PROJECT_ROOT/.env"
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
  list)
    check_project_root
    list_services
    ;;
  help|--help|-h|"")
    echo -e "\e[36mBlackOpsDocker CLI\e[0m - Gestión centralizada de múltiples docker-compose"
    echo
    echo "Uso:"
    echo "  blackopsdocker <comando>"
    echo
    echo "Comandos disponibles:"
    echo "  up         - Levanta todos los servicios"
    echo "  down       - Detiene todos los servicios"
    echo "  restart    - Reinicia todos los servicios"
    echo "  logs       - Muestra los logs de todos los servicios"
    echo "  ps         - Lista contenedores en ejecución"
    echo "  env        - Muestra el archivo .env actual"
    echo "  prune      - Elimina recursos de Docker detenidos"
    echo "  list       - Lista servicios docker-compose encontrados"
    echo "  help       - Muestra esta ayuda"
    ;;
  *)
    print_error "Comando desconocido: $1"
    echo "Usa 'blackopsdocker help' para ver los comandos disponibles."
    exit 1
    ;;
esac
