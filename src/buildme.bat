
REM build POI from the src\POI directory...
cd poi
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="$(Get-Date((Get-Date).ToUniversalTime()) -UFormat '%Y-%m-%dT%H:%M:%SZ')" --build-arg IMAGE_SOURCE_REVISION="$(git rev-parse HEAD)" -f ..\..\dockerfiles\Dockerfile_3 -t "tripinsights/poi:1.0" .
cd ..

REM build trips fromt the src\trips directory...
cd trips
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="$(Get-Date((Get-Date).ToUniversalTime()) -UFormat '%Y-%m-%dT%H:%M:%SZ')" --build-arg IMAGE_SOURCE_REVISION="$(git rev-parse HEAD)" -f ..\..\dockerfiles\Dockerfile_4 -t "tripinsights/trips:1.0" .
cd ..

REM build tripviewer from the src\tripviewer directory...
cd tripviewer
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="$(Get-Date((Get-Date).ToUniversalTime()) -UFormat '%Y-%m-%dT%H:%M:%SZ')" --build-arg IMAGE_SOURCE_REVISION="$(git rev-parse HEAD)" -f ..\..\dockerfiles\Dockerfile_1 -t "tripinsights/tripviewer:1.0" .
cd ..

REM build user-java from the src\user-java directory...
cd user-java
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="$(Get-Date((Get-Date).ToUniversalTime()) -UFormat '%Y-%m-%dT%H:%M:%SZ')" --build-arg IMAGE_SOURCE_REVISION="$(git rev-parse HEAD)" -f ..\..\dockerfiles\Dockerfile_0 -t "tripinsights/user-java:1.0" .
cd ..

REM build userprofile from the src\userprofile directory...
cd userprofile
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="$(Get-Date((Get-Date).ToUniversalTime()) -UFormat '%Y-%m-%dT%H:%M:%SZ')" --build-arg IMAGE_SOURCE_REVISION="$(git rev-parse HEAD)" -f ..\..\dockerfiles\Dockerfile_2 -t "tripinsights/userprofile:1.0" .
cd ..


