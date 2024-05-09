#! /bin/bash

#Переменные можно изменять
MAPNUMBER=64400055
COUNTRY_NAME=RUSSIA
COUNTRY_ABBR=RUS
#Конец переменные можно изменять

if [ -z $1 ]; then
  echo 'Не указан URL с файлом карты'
  echo 'Должно быть что-то вроде: https://download.geofabrik.de/russia/far-eastern-fed-district-latest.osm.pbf'
  exit 1
fi

if [ -z $2 ]; then
  TARGET_DIR=$(dirname $0)
else
  TARGET_DIR=$2
fi

mkdir -p $TARGET_DIR 
cd $TARGET_DIR
URL=$1
FILENAME=$(basename $URL)
MAPNAME=$(basename -s .osm.pbf $URL)

#Качаем файл с названиями городов
URL_CITIES_NAMES=https://download.geonames.org/export/dump/cities15000.zip
CITIES_FILE_NAME=$(basename $URL_CITIES_NAMES)
wget $URL_CITIES_NAMES

wget $URL

mkgmap-splitter --output-dir=$TARGET_DIR --geonames-file=$CITIES_FILE_NAME \
  --keep-complete=true $FILENAME
rm $FILENAME

mkgmap --gmapsupp -n $MAPNUMBER --country-name=$COUNTRY_NAME \
  --output-dir=$TARGET_DIR \
  --country-abbr=$COUNTRY_ABBR --unicode --lower-case --index --split-name-index \
  --remove-ovm-work-files=true --route \
  --name-tag-list=loc_name,name:ru,name,int_name,name:en \
  -c template.args --description=$MAPNAME

rm -f *.osm.pbf
rm -f areas.list areas.poly densities-out.txt template.args osmmap.tdb osmmap.img
rm -f 6324*.img
rm -f $CITIES_FILE_NAME
mv gmapsupp.img $MAPNAME.img
