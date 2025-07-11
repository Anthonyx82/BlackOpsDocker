<p align="right">
  <a href="README.md">English 🇬🇧</a> | **Español 🇪🇸**
</p>

# BlackOpsDocker

Repositorio con múltiples servicios Docker organizados en carpetas independientes, cada uno con su propio `docker-compose.yml`.

Para facilitar la gestión conjunta, incluye el script `blackopsdocker` que permite controlar todos los servicios a la vez con un único comando, desde cualquier lugar del sistema.

---

## Estructura del Proyecto

```
.
├── akuma/
│   └── docker-compose.yml
├── blackopsdocker\_manager.sh
├── blackopsdocker.sh
├── ftp-server/
│   └── docker-compose.yml
├── glances/
│   └── docker-compose.yml
├── jaeger/
│   ├── docker-compose.yml
│   └── nginx.conf
├── portainer/
│   └── docker-compose.yml
├── prometheus/
│   ├── docker-compose.yml
│   └── prometheus.yml
├── README.md
├── traefik/
│   ├── acme.json
│   ├── docker-compose.yml
│   ├── dynamic\_conf.yml
│   ├── fullchain.pem
│   ├── logs/
│   └── traefik.yml
├── .env.example
└── .env (NO versionado)
```

---

## Configuración de Variables de Entorno

El archivo `.env` **no está versionado** por seguridad. Para configurar tu entorno:

1. Copia el archivo de ejemplo:

```bash
cp .env.example .env
````

2. Edita `.env` con tus valores reales (IPs, usuarios, contraseñas, rutas, etc.):

```bash
nano .env
```

Guarda y cierra.

---

## Uso del Script `blackopsdocker`

El script `blackopsdocker` permite gestionar todos los servicios Docker definidos en las carpetas del proyecto de forma unificada. Puedes:

* Levantar todos los servicios con `blackopsdocker up`
* Parar todos los servicios con `blackopsdocker down`
* Reiniciar todos los servicios con `blackopsdocker restart`
* Ver logs combinados con `blackopsdocker logs`
* Limpiar volúmenes con `blackopsdocker prune volumes`
* Y otros comandos útiles

El script detecta automáticamente la raíz del proyecto desde cualquier ubicación.

---

## Instalación del Comando `blackopsdocker`

Para poder ejecutar el comando desde cualquier directorio, usa el script instalador/desinstalador:

### Pasos para instalar

1. Desde la raíz del proyecto, da permisos al gestor:

```bash
chmod +x blackopsdocker_manager.sh
```

2. Ejecuta el instalador:

```bash
./blackopsdocker_manager.sh install
```

Esto copiará `blackopsdocker.sh` a `/usr/local/bin/blackopsdocker` y le pondrá permisos ejecutables.

3. Verifica la instalación:

```bash
which blackopsdocker
# Debe devolver /usr/local/bin/blackopsdocker
```

---

## Desinstalación

Para eliminar el comando:

```bash
./blackopsdocker_manager.sh uninstall
```

---

## Recomendaciones

* Asegúrate de tener Docker y Docker Compose instalados.
* Siempre crea y configura tu `.env` antes de usar el script.
* El script funciona desde cualquier carpeta, detectando automáticamente el directorio raíz del proyecto.
* Consulta la ayuda con `blackopsdocker help` para ver todos los comandos disponibles.

---

## Licencia

MIT License

---

¡Gracias por usar BlackOpsDocker! 🚀

---
