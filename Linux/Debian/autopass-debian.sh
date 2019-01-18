#!/bin/bash

for i in $( cat /etc/passwd | awk -F: '$3 > 999 {print $1}' ); do
	echo -e "cyberdragons\ncyberdragons" | passwd $i
done
