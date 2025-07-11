# FTP Server con Docker Compose

Este proyecto crea un contenedor FTP utilizando la imagen `anthonyx82/ftp_antoniomartin`, configurado para múltiples usuarios y puertos pasivos.

## Uso

1. Renombra `.env.example` a `.env` y edita tus credenciales:
   ```bash
   cp .env.example .env
   ````

2. Levanta el contenedor:

   ```bash
   docker compose up -d
   ```

3. Verifica que esté corriendo:

   ```bash
   docker compose ps
   ```

## Variables de entorno

* `ADDRESS`: IP del host.
* `USERS`: Lista de usuarios en el formato `usuario|contraseña|ruta`.

## Puertos

* Puerto 21 para control FTP.
* Puertos 21000-21010 para transferencia pasiva.

## Volúmenes

El directorio `/raid0/ftpsv/ftp` del host se monta dentro del contenedor como almacenamiento compartido para los usuarios.
