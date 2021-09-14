#!/bin/dash

tempf="${1}.tmp"
cat $1 | hindent > $tempf && mv $tempf $1