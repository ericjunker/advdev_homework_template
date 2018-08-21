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
oc create -f Infrastructure/templates/dev/mongo.yaml -n ${GUID}-parks-dev
oc expose svc/mongodb -n ${GUID}-parks-dev
#label the service so that apps can find it
oc label service mongodb type=parksmap-backend -n ${GUID}-parks-dev

#set up permissions for ParksMap
oc policy add-role-to-user view --serviceaccount=default -n ${GUID}-parks-dev