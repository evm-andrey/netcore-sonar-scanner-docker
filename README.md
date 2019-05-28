# .Net Core Sonar Scanner on Docker Container

As a basis for building my image, I used some parts from https://hub.docker.com/r/burakince/docker-dotnet-sonarscanner

## Using Example

First of all you need a sonarqube server. If you haven't one, run this code;

```
docker run -d --name sonarqube -p 9000:9000 sonarqube
```

Take login token from sonarqube server, change working directory to project directory and run this code;

```
docker run --name dotnet-scanner -it --rm -v $(pwd):/project --link="sonarqube" \
  -e PROJECT_KEY=TestApp \
  -e PROJECT_NAME=TestApp \
  -e PROJECT_VERSION=1.0 \
  -e HOST=http://sonarqube:9000 \
  -e SONAR_TOKEN=CHANGE_THIS_ONE \
  gans13/netcore-sonar-scanner-docker:latest
```