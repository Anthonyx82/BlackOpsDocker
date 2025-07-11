#!/bin/bash

# Carpeta base
BASE_DIR="."
OUTPUT_FILE="docker-compose.unificado.yml"

# Reinicia el archivo de salida
echo "# Archivo docker-compose combinado" > "$OUTPUT_FILE"

# Buscar todos los docker-compose*.yml en subdirectorios
find "$BASE_DIR" -type f \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) | while read file; do
    echo -e "\n# ----------------------------------------" >> "$OUTPUT_FILE"
    echo "# Archivo original: $file" >> "$OUTPUT_FILE"
    echo "# ----------------------------------------" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"
done

echo "Combinación completa. Archivo guardado en: $OUTPUT_FILE"
