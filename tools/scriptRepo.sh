#!/bin/bash
cd /home/www
dpkg-scanpackages stable /dev/null | gzip -9c > stable/Packages.gz
dpkg-scanpackages testing /dev/null | gzip -9c > testing/Packages.gz
