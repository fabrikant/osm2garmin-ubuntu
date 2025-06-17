#! /bin/bash

#Переменные можно изменять
MAPNUMBER=63240001
COUNTRY_NAME=RUSSIA
COUNTRY_ABBR=RUS
TARGET_DIR=$(dirname $0)
#Конец переменные можно изменять

if [ -z $1 ]; then
  echo 'Скрипт следует запускать со следующими параметрами:'
  echo '-u URL                      - Должно быть что-то вроде: https://download.geofabrik.de/russia/far-eastern-fed-district-latest.osm.pbf'
  echo '-d DIRECTORY                - [Опционально] Рабочий каталог. по умолчанию '$TARGET_DIR
  echo '-n MAPNUMBER                - [Опционально] Номер карты восьмизначное уникальное число по умолчанию: '$MAPNUMBER
  echo '-country COUNTRY_NAME       - [Опционально] Название страны, по умолчанию '$COUNTRY_NAME
  echo '-country_abbr COUNTRY_ABBR  - [Опционально] Аббревиатура страны, по умолчанию '$COUNTRY_ABBR
  exit 1
fi

while [ -n "$1" ]; do
  case "$1" in
  -u)
    URL=$2
    shift
    ;;
  -d)
    TARGET_DIR=$(realpath -s "$2")
    shift
    ;;
  -n)
    MAPNUMBER=$2
    shift
    ;;
  -country)
    COUNTRY_NAME=$2
    shift
    ;;
  -country_abbr)
    COUNTRY_ABBR=$2
    shift
    ;;
  --)
    shift
    break
    ;;
  *) echo "$1 - неизвестный параметр" ;;
  esac
  shift
done

echo 'Текущие настройки:'
echo 'URL='$URL
echo 'TARGET_DIR='$TARGET_DIR
echo 'MAPNUMBER='$MAPNUMBER
echo 'COUNTRY_NAME='$COUNTRY_NAME
echo 'COUNTRY_ABBR='$COUNTRY_ABBR

mkdir -p $TARGET_DIR
TMP_DIR=$TARGET_DIR/tmp
mkdir -p $TMP_DIR
cd $TMP_DIR

FILENAME=$(basename $URL)
MAPNAME=$(basename -s .osm.pbf $URL)

#Качаем файл с названиями городов
URL_CITIES_NAMES=https://download.geonames.org/export/dump/cities15000.zip
CITIES_FILE_NAME=$(basename $URL_CITIES_NAMES)
wget $URL_CITIES_NAMES

wget $URL

mkgmap-splitter --output-dir=$TMP_DIR --geonames-file=$CITIES_FILE_NAME \
  --keep-complete=true $FILENAME
rm $FILENAME

mkgmap --gmapsupp -n $MAPNUMBER --country-name=$COUNTRY_NAME \
  --output-dir=$TMP_DIR \
  --country-abbr=$COUNTRY_ABBR --unicode --lower-case --index --split-name-index \
  --remove-ovm-work-files=true --route \
  --name-tag-list=loc_name,name:ru,name,int_name,name:en \
  -c template.args --description=$MAPNAME

mv gmapsupp.img $TARGET_DIR/$MAPNAME.img
cd $TARGET_DIR
rm -rf $TMP_DIR
