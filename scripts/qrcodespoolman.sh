#!/bin/sh

########################################## WARNING: ##############################################
### This script assumes you are using a crowsnest webcam on the same host and the first camera ###
###      Adjust the paths and addresses below as needed to work with your configuration        ###
##################################################################################################

## Capture a snapshot from the camera and store it in a jpg file
wget http://localhost/webcam/?action=snapshot -O /home/pi/printer_data/gcodes/qrcode.jpg

## Read any QRcodes from the image and strip just the spool-id from the data in the code
SPOOLID=$(zbarimg -S*.enable /home/pi/printer_data/gcodes/qrcode.jpg | sed 's/[^0-9]*\([0-9]\+\).*/\1/')

## Return the spool-id in the console (this is mostly for debugging purposes)
echo $SPOOLID

## Make an API call to spoolman selecting the spool that matches the spool-id
curl -X POST -H "Content-Type: application/json" -d "{\"spool_id\": \"$SPOOLID\"}" http://localhost:7125/server/spoolman/spool_id