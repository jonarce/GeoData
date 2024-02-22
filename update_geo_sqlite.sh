#!/usr/bin/bash
# update_geo.sh
# update travellerapi GEO information from Natural Earth
ECHO OFF
#list of zip files to retrieve
fileslist=(
	ne_10m_admin_0_countries.zip
    ne_10m_admin_1_states_provinces.zip
    ne_10m_populated_places.zip
    ne_10m_airports.zip
    ne_10m_ports.zip
)
path=https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural
# https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip

for f in ${fileslist[@]}
do
    echo "working: $f ..."
# download from Natural Earth using wget
    wget $path/$f

# unzip / extract shape file
    unzip $f
# drop table & update the database info.#
# tablename is the last part of the filename #
filename=$(basename -- "$f")
extension="${filename##*.}"
filename="${filename%.*}"
tablename="${filename##*_}"
#fix for "states_provinces" table 
if [ "$tablename" = "provinces" ]; then
   tablename="statesprovinces"
fi
#fix for "cities" table 
if [ "$tablename" = "places" ]; then
   tablename="cities"
fi
sqlite3 travellerapi.db "DROP TABLE IF EXISTS $tablename;"
spatialite_tool -i -shp $filename -d travellerapi.db -t $tablename -g geometry -c utf-8

# erase the downloaded & unzipped files
    rm $f
    rm $filename.*
done
