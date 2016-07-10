#!/bin/bash

mapfile -t myArray < /home/pi/SKAD/files/known_userids.txt

for i in "${myArray[@]}"
do
`useradd -M -s /bin/false $i`
done
