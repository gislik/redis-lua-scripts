#!/bin/bash

PATH=$PATH:/opt/mutombo-redis/bin 
[ -n "$PORT" ] || PORT=6381 

export PORT PATH

exec ./rlua.sh -i numberlua.lua -i subnet.lua -i update_subnets.lua $@
