#!/usr/bin/bash
# update_geo_geofabrik.sh
# update travellerapi GEO information from Open Street Map via Geofabrik site
# target db: PostGIS (could be a local,container or network)
Write-Output "Update PostGIS geo database with world data ...";
#list of zip files to retrieve
# Planet Latest is the full planet file 129GB
$fileslist=
	'antarctica-latest.osm.bz2',
	'asia-latest.osm.bz2',
	'europe-latest.osm.bz2',
	'north-america-latest.osm.bz2',
	'central-america-latest.osm.bz2',
	'australia-oceania-latest.osm.bz2',
	'africa-latest.osm.bz2',
	'south-america-latest.osm.bz2'

$path = https://download.geofabrik.de

# control first time to create the structures, after that append data
$firsttime=1

# loop over the list of files
foreach ($f in $fileslist)
{
    Write-Output "working: $f ..."
# download from Open Street Map (geofabrik)
    Invoke-WebRequest -Uri “$path/$f”
# extract file
#    echo "uncompressing: $f ..."
#    bzip2 -d $f
# calculate un-compress filename
#filename="${f%.*}"

# create blank tables if it is the first data file
#   if [[ "$first_time" -eq 1 ]]
#   then
# create new tables & update the database info.
#      echo "creating new tables & updating db: $filename ..."
      # Memory parameter --cache=24576
#      osm2pgsql --create --slim --output-pgsql-schema=geo -d traveller -C 60000 --flat-nodes ~/nodes.cache -U postgres -H localhost -S default.style $filename    
#      first_time=0
#   else
# update the database info.
#      echo "updating db: $filename ..."
      # cache memory set to 75% of 64GB (49152)
#      osm2pgsql --append --slim --output-pgsql-schema=geo -d traveller -C 60000 --flat-nodes ~/nodes.cache -U postgres -H localhost -S default.style $filename    
#   fi
# erase the file, the zip file was eliminated once decompressed
#   echo "erasing: $filename"
#   rm $filename
}
# single load for whole planet (64GB RAM): osm2pgsql --create --output-pgsql-schema=geo -d traveller -C 49152 --flat-nodes /home/jon/nodes.cache -U postgres -H localhost -S default.style planet-latest.osm.pbf
