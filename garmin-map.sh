#! /bin/bash

#Переменные можно изменять
MAPNUMBER=64400055
COUNTRY_NAME=RUSSIA
COUNTRY_ABBR=RUS

if [ -z $1 ]; then
  echo 'Не указан URL с файлом карты'
  echo 'Должно быть что-то вроде: https://download.geofabrik.de/russia/far-eastern-fed-district-latest.osm.pbf'
  exit 1
fi

if [ -z $2 ]; then
  SCRIPT_PATH=$(dirname $0)
else
  SCRIPT_PATH=$2
fi

cd $SCRIPT_PATH

URL=$1
FILENAME=$(basename $URL)
MAPNAME=$(basename -s .osm.pbf $URL)

wget $URL
mkgmap-splitter --keep-complete=true $FILENAME
rm $FILENAME

mkgmap --gmapsupp -c template.args -n $MAPNUMBER --description=$MAPNAME --country-name=$COUNTRY_NAME --country-abbr=$COUNTRY_ABBR --unicode --lower-case --index --split-name-index --remove-ovm-work-files=true --name-tag-list=loc_name,int_name,name,name:en

rm -f *.osm.pbf
rm -f areas.list areas.poly densities-out.txt template.args osmmap.tdb osmmap.img
rm -f 6324*.img
mv gmapsupp.img $MAPNAME.img
