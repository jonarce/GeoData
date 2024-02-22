##################################################################################
## UNIX Script to create from scratch the Docker Postgis image
## and load the geo data from GEOFABRIK
##
## You need to install: docker, postgresql-client-16
##
##################################################################################
echo Creating Data Container using Docker
sudo docker login --username=0000011111222223333344444 --password-stdin < /home/jon/docker_password.txt
#sudo docker build -t geo_postgis:1.7 .
echo Running Image Container with Data Volume
# run the created geo_postgis:1.7
#sudo docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=Pass@word1 -e PGDATA=/var/lib/postgresql/data/pgdata -v /mnt/2TB_ssd/postgres-data:/var/lib/postgresql/data -t geo_postgis:1.7
sudo docker compose up -d
echo please wait ... delay for DB Engine to startup
sleep 60
# read -p "Press enter to continue"
echo create Database traveller...
psql -h localhost -U postgres -d postgres -c "CREATE DATABASE traveller;"
echo create Database Objects and add extension PostGIS...
psql -h localhost -U postgres -d traveller -c "CREATE SCHEMA import; CREATE SCHEMA geo; CREATE EXTENSION postgis; SET search_path = geo, public; SELECT PostGIS_Full_Version();"
echo Docker stop {container_id}
# FOR BACKUP: pg_dump -Fc traveller -h localhost -U postgres -W > traveller-$(date +%d-%m-%y_%H-%M).out
sudo docker logout
echo done.
