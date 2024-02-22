#!/usr/bin/bash
# update_geo_NaturalEarth0.sh
# update travellerapi GEO information from Natural Earth site
# target db: PostGIS (could be a local,container or network)
# requires: bzip2 (decompress files),  shp2pgsql to upload
echo off
#list of zip files to retrieve amd table name to use
fileslist=(
	ne_10m_admin_0_countries.zip,adm0
        ne_10m_admin_1_states_provinces.zip adm1
        ne_10m_admin_2_counties.zip adm2
        ne_10m_populated_places.zip adm3
        ne_10m_airports.zip airport
        ne_10m_railroads.zip railroads
        ne_10m_ports.zip ports
        ne_10m_parks_and_protected_lands.zip parks
)
path="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural"

# control first time to create the structures, after that append data
first_time=1

# loop over the list of files
for f in ${fileslist[@]}
do
    IFS=","
    # Convert the tuple into the params $1 $1 ...
    set -- $f
    echo
    echo "working: $1 ... to db table: $2"
# download using wget
    wget $path/$1
# extract file
    echo "uncompressing: $1 ..."
    # overwrite, specific dir
    unzip -o -d . $1

# calculate un-compress filename
   filename="${1%.*}"
# create new tables & update the database info.
   echo "creating new tables $2 from data inside file: $filename ..."
   # Memory parameter --cache=24576
   # EwplacingL ~ for: /mnt/2TB_ssd/
   # osm2pgsql --create --output-pgsql-schema=geo -d traveller --number-processes 16 -C 60000  -U postgres -H localhost -S default.style planet-240115.osm
   # shp2pgsql parameters:
   #-I Create a GiST index on the geometry column
   #-d Drops the table, then recreates it and populates it with current shape file data
   #-G Use geography type instead of geometry (requires lon/lat data) in WGS84 long lat (-s SRID=4326)
   shp2pgsql -d -G -I -s 4326 $filename import.$2 | psql -h localhost -U postgres -d traveller

# erase the files, the zip file and its content
   echo "erasing: $filename (ALL extensions)"
   rm -f $filename.*
done
