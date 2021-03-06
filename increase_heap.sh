# (c) David T. Nguyen
# July 2014
# dunguk@gmail.com


# usage:
# ./increase_heap.sh
# increase the current heap size (by default 10%)



# =======

# source configure.sh

INPUT=`getprop dalvik.vm.heapsize`

OUTPUT=`echo $INPUT | cut -d'm' -f1`

OUTPUT2=`expr $OUTPUT \/ 10`

OUTPUT3=`expr $OUTPUT \+ $OUTPUT2`

OUTPUT4=`echo ${OUTPUT3}m`

setprop dalvik.vm.heapsize "$OUTPUT4"

