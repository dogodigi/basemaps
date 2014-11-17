BaseMaps for mapserver 6.2
==========================

This is a python script and c preprocessor to build a
complete mapfile from a set of templates and styling information for 
a postgis database with openstreetmap data imported with imposm3.

* the mapfiles are compatible with mapserver versions >= 6.2.0

* the build process uses the gcc preprocessor extensively, you should 
have it installed on your system. On linux, check that the 'cpp' command 
is present. On OSX, the provided 'cpp' program is a shell wrapper that 
is not suitable: the Makefile is coded to call 'cpp-4.2', which you can change in case
you have another version installed.

* The mapfiles rely on the database schema as created by a recent 
version of imposm3.

* python yaml is required.

Styles
------

Currently, the following styles are predefined:
* default (the original style used with basemaps, inherited by the 
other styles)
* nobuildings (as default, but without openstreetmap buildings)
* bing
* centerlined
* outlined
* google
* michelin
* brt (a schema designed for public safety in the Netherlands)
* (deprecated, needs fixing) osm2pgsql.yaml

Configuration
-------------
**First**:

Tweak Makefile to reflect:
* Database parameters **OSM_DB_CONNECTION**
* Projection **OSM_SRID**
* Map Extents **OSM_EXTENT**
* Schema and tablename prefix **OSM_NAME_COLUMN**

**Second** check that the style is how you want it:

* styles/**stylename**.yaml

If you want to create a new style, best practice is to copy default.yaml 
and change it to fit your needs.

**Finally**
run:
        make STYLE=**stylename**

And pick up osm-**stylename**.map from the directory where you ran make

Happy mapserving!

