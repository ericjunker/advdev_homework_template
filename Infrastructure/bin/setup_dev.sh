#!/bin/bash
# Setup Development Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Development Environment in project ${GUID}-parks-dev"

# Code to set up the parks development project.

# To be Implemented by Student

#create a MongoDB database
oc create -f Infrastructure/templates/dev/mongo.yaml
oc expose svc/mongodb
#label the service so that apps can find it
oc label service mongodb type=parksmap-backend