# Tomcat Demo
###### an example of running a Java web app on Tomcat in a Docker container

  * [Terms](#terms)
    + [Images](#images)
    + [Containers](#containers)
  * [Usage](#usage)
    + [Development](#development)
    + [Production](#production)
  * [Explaination](#explaination)
    + [Dockerfile](#dockerfile)
    + [Docker Compose](#docker-compose)

## Terms

Credit: https://docs.docker.com/get-started/overview/
### Images
An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization. For example, you may build an image which is based on the ubuntu image, but installs the Apache web server and your application, as well as the configuration details needed to make your application run.

You might create your own images or you might only use those created by others and published in a registry. To build your own image, you create a Dockerfile with a simple syntax for defining the steps needed to create the image and run it. Each instruction in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild the image, only those layers which have changed are rebuilt. This is part of what makes images so lightweight, small, and fast, when compared to other virtualization technologies.

### Containers
A container is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI. You can connect a container to one or more networks, attach storage to it, or even create a new image based on its current state.

By default, a container is relatively well isolated from other containers and its host machine. You can control how isolated a container’s network, storage, or other underlying subsystems are from other containers or from the host machine.

A container is defined by its image as well as any configuration options you provide to it when you create or start it. When a container is removed, any changes to its state that are not stored in persistent storage disappear.

---
# Usage
### Developemnt

For this demo we're using the default webapps.dist that ships with Tomcat 9 as the source code for our web app.

spin up a docker container running the /src web app with Tomcat
```sh
$ docker-compose up
```
navigate to `localhost:8080` in your browser. 

You can try making an edit to `src/ROOT/index.html` and reload the page to see your changes

### Production
Once you have your image in a repo like [Docker hub](https://hub.docker.com/), you can pull it from anywhere
```bash
$ docker pull badal/tomcat-example:1.0.0
```
Then spin up a container, bind the necessary ports and your app is live
```bash
$ docker run -p 80:8080 badal/tomcat-example:1.0.0
```
## Explaination
#### Dockerfile
the `Dockerfile` contains a list of instructions for building a Docker image layer by layer.

We will be using the official Docker image for [Apache Tomcat](https://hub.docker.com/_/tomcat) v9.0.40 as the base of our image. This image was built [with its own Dockerfile](https://github.com/docker-library/tomcat/blob/f284ec11dc580bff5adec3f4b0b1c9bf5f2d5b18/9.0/jdk11/openjdk-buster/Dockerfile ) 
```docker
FROM tomcat:9.0.40
```

Next we install Image Magick and Mariadb as arbitrary examples of dependencies
```docker
RUN apt-get update \
    && apt-get install -y jmagick mariadb-client
```

Next we will copy our example web page to the tomcat webapps directory in the image
```docker
COPY src/ /usr/local/tomcat/webapps
```


We could now build a Docker image from this dockerfile and tag it with the name `badal/tomcat-example` and version `1.0.0`
```bash
$ docker build . -t badal/tomcat-example:1.0.0
```

Once the image is built it can be pushed to an image repo. Then it can be pulled from a machine which can then spin a container from it.

Using Docker, we can ensure that all developers are using the exact same environment as each other as well as the productin machines. This eliminates "It worked on _my_ machine"

#### Docker Compose
the [docker-compose.yaml](docker-compose.yaml) file defines a simple setup to use in development. 

We bind container port 8080 to port 8080 of the host machine
```docker
    ports:
      - "8080:8080"
```

And mount the source code as a volume inside the container. This way when the code is modified, it will also change inside the container
```docker
    volumes:
      - ./src:/usr/local/tomcat/webapps
```

