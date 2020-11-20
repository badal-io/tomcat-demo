# Use official Apache Tomcat image (v9.0.40) as base image
FROM tomcat:9.0.40

# Install imagemagick for java
RUN apt-get update \
    && apt-get install -y jmagick
 
# Copy webapp source code into the image
COPY src/ /usr/local/tomcat/webapps