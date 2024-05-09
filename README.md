# osm2garmin-ubuntu
## Requaried
```bash
sudo apt install mkgmap mkgmap-splitter wget
```
## Install
``` bash
git clone https://github.com/fabrikant/osm2garmin-ubuntu.git
cd osm2garmin-ubuntu
chmod +x garmin-map.sh
```
## Usage
``` bash
./garmin-map.sh URL
```
URL - something like: https://download.geofabrik.de/russia/kaliningrad-latest.osm.pbf

## Examples
``` bash
./garmin-map.sh https://download.geofabrik.de/russia-latest.osm.pbf
```
``` bash
./garmin-map.sh https://download.geofabrik.de/asia/kazakhstan-latest.osm.pbf
```