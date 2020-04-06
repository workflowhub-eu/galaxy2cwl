#!/bin/sh

## Extract CSV file mapping Galaxy's data type class names to
## EDAM ontology terms.
## by Helena Rasche <https://orcid.org/0000-0001-9760-8992>

# activate galaxy env, and in root of git clone of galaxy
cat config/datatypes_conf.xml.sample| xpath -q -e '//datatype/@type' | \
  sort -u | sed 's/.*galaxy/galaxy/;s/"//g;s/:/ import /g;s/^/from /g;s/$/ as X; print("%s\t%s" % (X.__name__, X.edam_format));/g' | \
  PYTHONPATH=lib python
  
