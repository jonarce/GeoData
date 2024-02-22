##################################################################################
## UNIX Script to bring up the Docker Postgis image
## that contain geo data from GEOFABRIK
##
## You need to install: docker, postgresql-client-16
##
##################################################################################
echo Running Image Container with Data Volume geo_postgis:1.7
# run the created image geo_postgis:1.7
sudo docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=Pass@word1 -e PGDATA=/var/lib/postgresql/data/pgdata -v /mnt/2TB_ssd/postgres-data:/var/lib/postgresql/data -t docker run -i -t geo_postgis:1.7
echo please wait ... delay for DB Engine to startup
sleep 60
echo Docker stop {container_id}
echo done.

