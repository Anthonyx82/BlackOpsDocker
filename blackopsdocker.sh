#!/bin/bash
# blackopsdocker - CLI dinámico para gestionar todos los docker-compose en BlackOpsDocker

function find_root_dir() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" && -f "$dir/.env" ]]; then
      echo "$dir"
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}

ROOT_DIR=$(find_root_dir)

if [[ -z "$ROOT_DIR" ]]; then
  echo "ERROR: No se pudo encontrar la raíz del proyecto (se busca carpeta con .git y archivo .env)."
  exit 1
fi

# Detectar carpetas en el primer nivel con docker-compose.yml
COMPOSE_DIRS=()
while IFS= read -r -d '' dir; do
  COMPOSE_DIRS+=("$(basename "$dir")")
done < <(find "$ROOT_DIR" -maxdepth 1 -mindepth 1 -type d -exec test -f '{}/docker-compose.yml' \; -print0)

if [[ ${#COMPOSE_DIRS[@]} -eq 0 ]]; then
  echo "ERROR: No se encontraron docker-compose.yml en carpetas de primer nivel del proyecto."
  exit 1
fi

function docker_compose_in_dirs() {
  local cmd=$1
  for d in "${COMPOSE_DIRS[@]}"; do
    local compose_file="$ROOT_DIR/$d/docker-compose.yml"
    if [[ -f "$compose_file" ]]; then
      echo -e "\n==> Ejecutando 'docker-compose $cmd' en $d"
      docker-compose -f "$compose_file" $cmd
    else
      echo "Aviso: No se encontró docker-compose.yml en $d, se omite."
    fi
  done
}

function volumes_list() {
  echo "Listando volúmenes usados por los stacks:"
  local volumes
  volumes=$(docker volume ls --format '{{.Name}}')
  local found=0
  for d in "${COMPOSE_DIRS[@]}"; do
    local matched=$(echo "$volumes" | grep "$d")
    if [[ -n "$matched" ]]; then
      echo "$matched"
      found=1
    fi
  done
  if [[ $found -eq 0 ]]; then
    echo "(No se encontraron volúmenes relacionados)"
  fi
}

function volumes_remove() {
  local volname=$1
  if [[ "$volname" == "all" ]]; then
    echo "Borrando todos los volúmenes relacionados..."
    local volumes
    volumes=$(docker volume ls --format '{{.Name}}')
    local to_delete=()
    for d in "${COMPOSE_DIRS[@]}"; do
      mapfile -t matched < <(echo "$volumes" | grep "$d")
      to_delete+=("${matched[@]}")
    done
    if [[ ${#to_delete[@]} -eq 0 ]]; then
      echo "No se encontraron volúmenes para borrar."
    else
      echo "Volúmenes a borrar:"
      printf '%s\n' "${to_delete[@]}"
      docker volume rm "${to_delete[@]}"
    fi
  else
    echo "Borrando volumen: $volname"
    docker volume rm "$volname"
  fi
}

function env_list() {
  local envfile="$ROOT_DIR/.env"
  if [[ -f "$envfile" ]]; then
    echo "Contenido de $envfile:"
    cat "$envfile"
  else
    echo "No se encontró el archivo .env en $envfile"
  fi
}

function show_help() {
  cat << EOF
Uso: blackopsdocker <comando> [opciones]

Comandos:
  up                Levanta todos los stacks (modo detach)
  down              Para todos los stacks
  restart           Reinicia todos los stacks
  volumes list      Lista volúmenes usados por los stacks
  volumes rm <name> Borra un volumen por nombre
  volumes rm all    Borra todos los volúmenes usados por los stacks
  env list          Muestra el archivo .env unificado
  help              Muestra esta ayuda

Ejemplo:
  blackopsdocker up
  blackopsdocker volumes rm blackopsdocker_akuma_data
EOF
}

if [[ $# -lt 1 ]]; then
  show_help
  exit 1
fi

case "$1" in
  up)
    docker_compose_in_dirs "up -d"
    ;;
  down)
    docker_compose_in_dirs "down"
    ;;
  restart)
    docker_compose_in_dirs "restart -t 5"
    ;;
  volumes)
    if [[ "$2" == "list" ]]; then
      volumes_list
    elif [[ "$2" == "rm" ]]; then
      if [[ -z "$3" ]]; then
        echo "ERROR: Debes indicar el nombre del volumen o 'all'"
        exit 1
      fi
      volumes_remove "$3"
    else
      echo "Comando inválido para volumes."
      show_help
      exit 1
    fi
    ;;
  env)
    if [[ "$2" == "list" ]]; then
      env_list
    else
      echo "Comando inválido para env."
      show_help
      exit 1
    fi
    ;;
  help|-h|--help)
    show_help
    ;;
  *)
    echo "Comando desconocido: $1"
    show_help
    exit 1
    ;;
esac
