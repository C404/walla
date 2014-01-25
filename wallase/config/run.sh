#! /bin/sh

DIR=`dirname $0`
ABSDIR=`readlink -f $DIR`

elasticsearch  -f \
    -Des.path.home=$ABSDIR/.. \
    -Des.path.data=$ABSDIR/../db \
    -Des.path.conf=$ABSDIR \
    -Des.config=$ABSDIR/elasticsearch.yml
