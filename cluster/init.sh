#!/bin/bash

set -x

for ((i=0;i<8;++i))
do
	mkdir 700$i
	export port=700$i
	sh tpl.sh >>700$i/700$i.conf
done
