#!/bin/bash

#$1  is module path and name, eg lib.4gm/fin.4gs/ws_braintree.42m

module_path="$1"
module_name=$(basename "$1" .42m)

echo $module_name

ssh -i ~/id_rsa_tps-test tps-test@vmwhit22.nibdom.com.au 'export LD_LIBRARY_PATH=/opt/informix-12.10.fc14/lib/esql:/opt/informix-12.10.fc14/lib;export PATH=:/opt/fgl-2.11.19-1169/bin:$PATH; fglrun -r /whics/t22/'"$module_path" > "out/$module_name"
scp -i ~/id_rsa_tps-test "tps-test@vmwhit22.nibdom.com.au:/whics/t22/$module_path" out/


./reversi.rb --output debug "out/$module_name" > "out/$module_name.4gl"