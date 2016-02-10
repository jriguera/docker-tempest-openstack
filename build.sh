#!/bin/bash

# Docker with confd to manage the configuration
# see https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md
IMAGE=tempest

# 1. Build the docker image
docker build -t $IMAGE .

