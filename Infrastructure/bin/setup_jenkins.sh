#!/bin/bash
# Setup Jenkins Project
if [ "$#" -ne 3 ]; then
    echo "Usage:"
    echo "  $0 GUID REPO CLUSTER"
    echo "  Example: $0 wkha https://github.com/wkulhanek/ParksMap na39.openshift.opentlc.com"
    exit 1
fi

GUID=$1
REPO=$2
CLUSTER=$3
echo "Setting up Jenkins in project ${GUID}-jenkins from Git Repo ${REPO} for Cluster ${CLUSTER}"

# Code to set up the Jenkins project to execute the
# three pipelines.
# This will need to also build the custom Maven Slave Pod
# Image to be used in the pipelines.
# Finally the script needs to create three OpenShift Build
# Configurations in the Jenkins Project to build the
# three micro services. Expected name of the build configs:
# * mlbparks-pipeline
# * nationalparks-pipeline
# * parksmap-pipeline
# The build configurations need to have two environment variables to be passed to the Pipeline:
# * GUID: the GUID used in all the projects
# * CLUSTER: the base url of the cluster used (e.g. na39.openshift.opentlc.com)

# To be Implemented by Student
#set Jenkins up
oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi -n $GUID-jenkins
#jenkins is hungry. give it some more CPU
oc patch dc jenkins -p '{"spec":{"template":{"spec":{"containers":[{"name":"jenkins","resources":{"limits":{"cpu":"3000m"}}}] }}}}' -n $GUID-jenkins
#insert real environment variables into build configs
envsubst < "Infrastructure/templates/parksmap-pipeline.yaml" > "Infrastructure/templates/parksmap-pipeline-replaced.yaml"
envsubst < "Infrastructure/templates/nationalparks-pipeline.yaml" > "Infrastructure/templates/nationalparks-pipeline-replaced.yaml"
envsubst < "Infrastructure/templates/mlbparks-pipeline.yaml" > "Infrastructure/templates/mlbparks-pipeline-replaced.yaml"
#create build configs
oc create -f Infrastructure/templates/parksmap-pipeline-replaced.yaml -n $GUID-jenkins
oc create -f Infrastructure/templates/nationalparks-pipeline-replaced.yaml -n $GUID-jenkins
oc create -f Infrastructure/templates/mlbparks-pipeline-replaced.yaml -n $GUID-jenkins