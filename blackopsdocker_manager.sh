#!/bin/bash

# Colores para mensajes
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

LOCAL_SCRIPT="blackopsdocker.sh"
TARGET="/usr/local/bin/blackopsdocker"

function print_info() {
  echo -e "${CYAN}[INFO]${RESET} $1"
}

function print_success() {
  echo -e "${GREEN}[OK]${RESET} $1"
}

function print_warn() {
  echo -e "${YELLOW}[WARN]${RESET} $1"
}

function print_error() {
  echo -e "${RED}[ERROR]${RESET} $1"
}

function animate_dots() {
  for i in {1..3}; do
    echo -n "."
    sleep 0.5
  done
  echo ""
}

function install() {
  print_info "Verificando que el script '${LOCAL_SCRIPT}' exista en la carpeta actual..."
  if [[ ! -f "$LOCAL_SCRIPT" ]]; then
    print_error "No se encontró el archivo '${LOCAL_SCRIPT}'. Asegúrate de ejecutarlo desde la raíz del proyecto."
    exit 1
  fi

  print_info "Copiando '${LOCAL_SCRIPT}' a '${TARGET}'"
  sudo cp "$LOCAL_SCRIPT" "$TARGET"
  animate_dots

  print_info "Asignando permisos ejecutables a '${TARGET}'"
  sudo chmod +x "$TARGET"
  animate_dots

  print_info "Verificando que el comando 'blackopsdocker' esté disponible en el PATH"
  if command -v blackopsdocker >/dev/null 2>&1; then
    print_success "¡blackopsdocker instalado correctamente! 🎉"
    echo ""
    echo -e "${CYAN}Puedes usarlo ahora desde cualquier carpeta con el comando:${RESET}"
    echo -e "  ${GREEN}blackopsdocker <comando>${RESET}"
    echo ""
    echo -e "Ejemplo:"
    echo -e "  ${GREEN}blackopsdocker up${RESET}"
  else
    print_error "blackopsdocker no está disponible en el PATH. Revisa la instalación."
  fi
}

function uninstall() {
  print_warn "Comenzando proceso de desinstalación..."

  if [[ -f "$TARGET" ]]; then
    print_info "Eliminando '${TARGET}'"
    sudo rm "$TARGET"
    animate_dots
    print_success "blackopsdocker ha sido desinstalado correctamente. 👋"
  else
    print_warn "No se encontró '${TARGET}'. ¿Ya estaba desinstalado?"
  fi
}

function usage() {
  cat <<EOF
${CYAN}Uso:${RESET} $0 {install|uninstall|help}

  ${GREEN}install${RESET}   - Instala blackopsdocker en /usr/local/bin
  ${RED}uninstall${RESET} - Elimina blackopsdocker de /usr/local/bin
  help      - Muestra esta ayuda

Ejemplo:
  ${GREEN}./blackopsdocker_manager.sh install${RESET}
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  install)
    install
    ;;
  uninstall)
    uninstall
    ;;
  help|--help|-h)
    usage
    ;;
  *)
    print_error "Parámetro desconocido: $1"
    usage
    exit 1
    ;;
esac
