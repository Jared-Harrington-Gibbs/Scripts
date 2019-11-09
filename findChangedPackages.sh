#!/bin/bash

#get a list of changed files according to debsums
sudo debsums -acs 2>&1 |grep -iv 'missing file '> changed_files.txt

#Get a list of what provides those changed files
for x in $(cat changed_files.txt); do dpkg -S "$x"|sed -e 's/:.*//'; done > changed_packages.txt

#Get a list of what provides those changed files long list format
#for x in $(cat changed_files.txt); do dpkg -S "$x"; done > changed_packages_ll.txt

#download a copy of the deb files
cat changed_packages.txt |xargs -I '{}' apt download '{}'

#extract the files into a directory
mkdir files
ls *.deb | xargs -I '{}' dpkg -x '{}' ./files/

#get a list of all of the original hashes
cat changed_files.txt | xargs -I '{}' sha256sum ./files'{}'

#diff the files with the ones on the system
cat changed_files.txt | xargs -I '{}' diff '{}' ./files'{}' --side-by-side --width=180 --ignore-all-space --suppress-common-lines
