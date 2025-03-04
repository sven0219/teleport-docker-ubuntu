Here is a README file for your project to explain how to build the Docker image:


# Teleport Docker Ubuntu

This repository contains a Dockerfile to build a Docker image for Teleport on Ubuntu 20.04.

## Prerequisites

- Docker installed on your machine.

## Build the Docker Image

1. Clone the repository:
   ```sh
   git clone https://github.com/sven0219/teleport-docker-ubuntu.git
   cd teleport-docker-ubuntu
   ```

2. Set the `PACKAGE_URL` argument to the URL of the Teleport `.deb` package you want to install. For example:
   ```sh
    export PACKAGE_URL=https://cdn.teleport.dev/teleport_16.4.16_amd64.deb
   ```

3. Build the Docker image:
   ```sh
   docker build --build-arg PACKAGE_URL=$PACKAGE_URL -t teleport-ubuntu .
   ```

## Usage

To run the Docker container:
```sh
docker run -d --name teleport-ubuntu-container teleport-ubuntu
```

## Notes

- The `PACKAGE_URL` should be updated to point to the desired version of the Teleport `.deb` package.
- The image is based on Ubuntu 20.04 and includes several tools for debugging and network operations.
- The `dumb-init` package is used to handle signals and orphaned processes correctly.

## License

This project is licensed under the MIT License.


This README provides step-by-step instructions on how to build the Docker image and includes additional details about the prerequisites and usage.
