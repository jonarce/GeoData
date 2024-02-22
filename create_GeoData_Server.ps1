##################################################################################
## PowerShell Script to create from scratch the Docker Postgis image
## then you can load the geo data from GEOFABRIK
##
## You need to install: docker, postgresql-client-16
##
##################################################################################
Write-Output "Creating Data Container using Docker";
#sudo docker login --username=0000011111222223333344444 --password-stdin < ~/docker_password.txt
cat ~/docker_password.txt | docker login --username 0000011111222223333344444 --password-stdin
#sudo docker image pull postgis/postgis:1latest
docker build -t geo_postgis:1.7 .
Write-Output "Running Image Container with Data Volume";
# run base image and NOT the created geo_postgis:1.7
docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=Pass@word1 -e PGDATA=/var/lib/postgresql/data/pgdata -v d:\postgres-data:/var/lib/postgresql/data -d postgis/postgis
Write-Output "please wait ... 1m delay for DB Engine to startup";
Start-Sleep -Seconds 60
Read-Host -Prompt "Press any key to continue ...";
Write-Output "create Database traveller...";
psql -h localhost -U postgres -d postgres -c "CREATE DATABASE traveller;"
Write-Output "create Database Objects and add extension PostGIS...";
psql -h localhost -U postgres -d traveller -c "CREATE SCHEMA geo; CREATE EXTENSION postgis; SET search_path = geo, public; SELECT PostGIS_Full_Version();"
Write-Output "Docker stop {container_id}";
Write-Output "done.";
docker logout
