UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
SED=sed -i ""
else
SED=sed -i
endif

CPP=gcc -E -x c
#if the preprocessor fails for some reason, try replacing this with "cpp" on linux, or "cpp-4.2" on darwin (not available starting with mountain lion)

OSM_MAP_TITLE=openstreetmap
OSM_PREFIX=planet_osm_
OSM_NAME_COLUMN=name
OSM_SRID=3857
OSM_GRID_SRID=28992
OSM_UNITS=meters
#OSM_EXTENT=12000 304000 280000 620000 #28992
#3857
OSM_EXTENT=-20026376.39 -20048966.10 20026376.39 20048966.10
OSM_DB_CONNECTION=host=localhost dbname=central-south-america user=openstreetmap password=openstreetmap port=5433
OSM_WMS_SRS=EPSG:4326 EPSG:900913 EPSG:28992 EPSG:3857

DEBUG=1
LAYERDEBUG=1
STYLE=default

template=osmbase.map

includes=land.map landusage.map borders.map highways.map places.map \
		 generated/$(STYLE)style.msinc \
		 generated/$(STYLE)level0.msinc generated/$(STYLE)level1.msinc generated/$(STYLE)level2.msinc generated/$(STYLE)level3.msinc \
		 generated/$(STYLE)level4.msinc generated/$(STYLE)level5.msinc generated/$(STYLE)level6.msinc generated/$(STYLE)level7.msinc \
		 generated/$(STYLE)level8.msinc generated/$(STYLE)level9.msinc generated/$(STYLE)level10.msinc generated/$(STYLE)level11.msinc \
		 generated/$(STYLE)level12.msinc generated/$(STYLE)level13.msinc generated/$(STYLE)level14.msinc generated/$(STYLE)level15.msinc \
		 generated/$(STYLE)level16.msinc generated/$(STYLE)level17.msinc generated/$(STYLE)level18.msinc



mapfile=osm-$(STYLE).map
here=`pwd`

all:$(mapfile) boundaries.sql clean

# We only need to generate once
generated/$(STYLE)style.msinc: pyMapFile.py
	python pyMapFile.py -s $(STYLE) -g > $@

$(mapfile):$(template) $(includes)
	$(CPP) -D_debug=$(DEBUG) -D_layerdebug=$(LAYERDEBUG)  -DOSM_PREFIX=$(OSM_PREFIX) -DOSM_GRID_SRID=$(OSM_GRID_SRID) -DOSM_SRID=$(OSM_SRID) -P -o $(mapfile) $(template) -DTHEME=$(STYLE) -D_proj_lib=\"$(here)\" -Igenerated
	$(SED) 's/##.*$$//g' $(mapfile)
	$(SED) '/^ *$$/d' $(mapfile)
	$(SED) -e 's/OSM_MAP_TITLE/$(OSM_MAP_TITLE)/g' $(mapfile)
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $(mapfile)
	$(SED) -e 's/OSM_SRID/$(OSM_SRID)/g' $(mapfile)
	$(SED) -e 's/OSM_GRID_SRID/$(OSM_GRID_SRID)/g' $(mapfile)
	$(SED) -e 's/OSM_UNITS/$(OSM_UNITS)/g' $(mapfile)
	$(SED) -e 's/OSM_EXTENT/$(OSM_EXTENT)/g' $(mapfile)
	$(SED) -e 's/OSM_WMS_SRS/$(OSM_WMS_SRS)/g' $(mapfile)
	$(SED) -e 's/OSM_NAME_COLUMN/$(OSM_NAME_COLUMN)/g' $(mapfile)
	$(SED) -e 's/OSM_DB_CONNECTION/$(OSM_DB_CONNECTION)/g' $(mapfile)
    
boundaries.sql: boundaries.sql.in
	cp -f $< $@
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $@

clean:
	rm -f generated/*

data:
	cd data; $(MAKE) $(MFLAGS)
