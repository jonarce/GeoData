#!/usr/bin/bash
# update_geo_geofabrik.sh
# update travellerapi GEO information from Open Street Map via Geofabrik site
# target db: PostGIS (could be a local,container or network)
echo off
#list of zip files to retrieve
# Planet Latest is the full planet file 129GB
fileslist=(
	antarctica-latest.osm.bz2
	asia-latest.osm.bz2
	europe-latest.osm.bz2
	north-america-latest.osm.bz2
	central-america-latest.osm.bz2
	australia-oceania-latest.osm.bz2
	africa-latest.osm.bz2
	south-america-latest.osm.bz2
)
path=https://download.geofabrik.de

# control first time to create the structures, after that append data
first_time=1

# loop over the list of files
for f in ${fileslist[@]}
do
    echo
    echo "working: $f ..."
# download from Open Street Map (geofabrik) using wget
    wget $path/$f
# extract file
    echo "uncompressing: $f ..."
    bzip2 -d $f
# calculate un-compress filename
filename="${f%.*}"

# create blank tables if it is the first data file
   if [[ "$first_time" -eq 1 ]]
   then
# create new tables & update the database info.
      echo "creating new tables & updating db: $filename ..."
      # Memory parameter --cache=24576
      # EwplacingL ~ for: /mnt/2TB_ssd/
      # osm2pgsql --create --output-pgsql-schema=geo -d traveller --number-processes 16 -C 60000  -U postgres -H localhost -S default.style planet-240115.osm
      osm2pgsql --create --slim --output-pgsql-schema=geo -d traveller --number-processes 16 -C 60000 --flat-nodes /mnt/4TBraid0/nodes.cache -U postgres -H localhost -S default.style $filename    
      first_time=0
   else
# update the database info.
      echo "updating db: $filename ..."
      # cache memory set to 75% of 64GB (49152)
      osm2pgsql --append --slim --output-pgsql-schema=geo -d traveller --number-processes 16 -C 60000 --flat-nodes /mnt/4TBraid0/nodes.cache -U postgres -H localhost -S default.style $filename   
#      osm2pgsql --output-pgsql-schema=geo -d traveller --number-processes 16 -C 60000 --flat-nodes ~/nodes.cache -U postgres -H localhost -S default.style $filename   
   fi
# erase the file, the zip file was eliminated once decompressed
   echo "erasing: $filename"
   rm $filename
done
# single load for whole planet (64GB RAM): 
# curl -OL https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf
#+


