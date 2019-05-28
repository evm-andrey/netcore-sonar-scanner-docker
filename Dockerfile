FROM openjdk:8u212-jdk-slim-stretch 

LABEL maintainer="Evmenenko Andrey <mail@gbunker.org>"

ENV SONAR_SCANNER_MSBUILD_VERSION=4.6.1.2049 \
    SONAR_SCANNER_MSBUILD_HOME=/opt/sonar-scanner \
    SONAR_SCANNER_VERSION=3.3.0.1492 \
    DOTNET_SDK_VERSION=2.2 \
    DOTNET_PROJECT_DIR=/project \
    DOTNET_CLI_TELEMETRY_OPTOUT=true

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      wget \
      curl \
      unzip \
      apt-transport-https \
      gnupg2 \
      curl \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/9/prod stretch main" > /etc/apt/sources.list.d/microsoft-prod.list' \
    && apt-get update \
    && apt-get install dotnet-sdk-$DOTNET_SDK_VERSION -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/$SONAR_SCANNER_MSBUILD_VERSION/sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp2.0.zip -O /opt/sonar-scanner.zip \
    && mkdir -p $SONAR_SCANNER_MSBUILD_HOME \
    && unzip /opt/sonar-scanner.zip -d $SONAR_SCANNER_MSBUILD_HOME \
    && rm /opt/sonar-scanner.zip \
    && chmod 775 $SONAR_SCANNER_MSBUILD_HOME/**/bin/* \
    && chmod 775 $SONAR_SCANNER_MSBUILD_HOME/**/lib/*.jar

ENV PATH="$SONAR_SCANNER_MSBUILD_HOME:$SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin:${PATH}"

COPY endpoint.sh $SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin/
RUN chmod +x $SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin/endpoint.sh

VOLUME $DOTNET_PROJECT_DIR
WORKDIR $DOTNET_PROJECT_DIR

CMD ["endpoint.sh"]