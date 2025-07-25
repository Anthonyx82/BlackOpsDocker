#!/bin/bash

# Colores para mensajes
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

SOURCE_FILE="blackopsdocker.sh"
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
  print_info "🔍 Verificando que el script '${SOURCE_FILE}' exista en la carpeta actual..."
  if [[ ! -f "$SOURCE_FILE" ]]; then
    print_error "❌ No se encontró '${SOURCE_FILE}'. Asegúrate de ejecutar este instalador desde la raíz del proyecto."
    exit 1
  fi

  print_info "🔧 Copiando script a '$TARGET' como comando global 'blackopsdocker'..."
  sudo cp "$SOURCE_FILE" "$TARGET"
  sudo chmod +x "$TARGET"
  animate_dots

  print_success "✅ ¡Instalación completada!"
  echo -e "\n🎉 Ya puedes ejecutar el comando desde cualquier parte con:"
  echo -e "   ${GREEN}blackopsdocker up${RESET} (por ejemplo)"
  echo -e "\nℹ️ Ejecuta ${CYAN}blackopsdocker help${RESET} para ver todos los comandos disponibles.\n"
}

function uninstall() {
  print_warn "🧹 Comenzando desinstalación de blackopsdocker..."
  if [[ -f "$TARGET" ]]; then
    sudo rm "$TARGET"
    animate_dots
    print_success "✅ Comando 'blackopsdocker' eliminado de /usr/local/bin"
  else
    print_warn "No se encontró el comando instalado. ¿Ya estaba desinstalado?"
  fi
}

function usage() {
  echo -e "${CYAN}Uso:${RESET} ./blackopsdocker_manager.sh {install|uninstall|help}\n"
  echo -e "  ${GREEN}install${RESET}    - Instala el comando global blackopsdocker"
  echo -e "  ${RED}uninstall${RESET}  - Desinstala el comando global blackopsdocker"
  echo -e "  help        - Muestra esta ayuda\n"
  echo -e "Ejemplo:"
  echo -e "  ${GREEN}./blackopsdocker_manager.sh install${RESET}"
}

# ========== MAIN ========== #

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
