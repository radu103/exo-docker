# Docker Image for EXO

This project provides a Docker image that runs exo

## Usage:

To use this Docker image, you can run the following command:
```
docker run -p 52415:80 -e HF_TOKEN=token radu103/exo-docker:latest 
```
This will start a new Docker container using the `exo-docker` image, and map port 52416 on the host machine to port 52416 on the container.

## Building the Docker Image:

To build the Docker image yourself, you can use the following command:
```
docker build -t exo-docker .
```
This will build the Docker image using the `Dockerfile` in the current directory, and tag it with the name `exo-docker`.

## Docker Tag and Publish Image

```
docker tag exo-docker radu103/exo-docker
docker push radu103/exo-docker
```

## Exo Service:

The service is started automatically when the Docker container is launched. It will be available at `http://localhost:52415` on the host machine.
