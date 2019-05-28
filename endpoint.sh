#!/bin/bash

set -x

PROJECT_KEY="${PROJECT_KEY:-TestApp}"
PROJECT_NAME="${PROJECT_NAME:-TestApp}"
PROJECT_VERSION="${PROJECT_VERSION:-1.0}"
SONAR_HOST="${HOST:-http://localhost:9000}"
SONAR_TOKEN="${SONAR_TOKEN:-PAST_TOKEN_HERE}"

dotnet $SONAR_SCANNER_MSBUILD_HOME/SonarScanner.MSBuild.dll begin /d:sonar.host.url=$SONAR_HOST /k:$PROJECT_KEY /n:"$PROJECT_NAME" /v:$PROJECT_VERSION /d:sonar.login=$SONAR_TOKEN
dotnet build $PWD/$PROJECT_NAME.sln
dotnet $SONAR_SCANNER_MSBUILD_HOME/SonarScanner.MSBuild.dll end /d:sonar.login=$SONAR_TOKEN
