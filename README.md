# VyOS-Docker-GNS3
===================

VyOS Docker Image Builder for GNS3

Use these scripts to build a Docker image of VyOS that can be run as a GNS3 appliance.

The steps are:
1. Get a VyOS ISO image from the website or GitHub nightly build and store in the same directory as this repo.
2. Execute `./build-docker-image.sh` as root
3. The Docker image should be available on your host as `vyos:test`

Use the image as a template in GNS3.
