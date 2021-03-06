#!/bin/bash
# Create all Homework Projects
if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "  $0 GUID USER"
    exit 1
fi

GUID=$1
USER=$2
echo "Creating all Homework Projects for GUID=${GUID} and USER=${USER}"
oc new-project ${GUID}-nexus        --display-name="${GUID} AdvDev Homework Nexus"
oc new-project ${GUID}-sonarqube    --display-name="${GUID} AdvDev Homework Sonarqube"
oc new-project ${GUID}-jenkins    --display-name="${GUID} AdvDev Homework Jenkins"
oc new-project ${GUID}-parks-dev  --display-name="${GUID} AdvDev Homework Parks Development"
oc new-project ${GUID}-parks-prod --display-name="${GUID} AdvDev Homework Parks Production"

oc policy add-role-to-user admin ${USER} -n ${GUID}-nexus
oc policy add-role-to-user admin ${USER} -n ${GUID}-sonarqube
oc policy add-role-to-user admin ${USER} -n ${GUID}-jenkins
oc policy add-role-to-user admin ${USER} -n ${GUID}-parks-dev
oc policy add-role-to-user admin ${USER} -n ${GUID}-parks-prod
#make Jenkins an admin too
oc policy add-role-to-user admin system:serviceaccount:gpte-jenkins:jenkins -n ${GUID}-nexus
oc policy add-role-to-user admin system:serviceaccount:gpte-jenkins:jenkins -n ${GUID}-sonarqube
oc policy add-role-to-user admin system:serviceaccount:gpte-jenkins:jenkins -n ${GUID}-jenkins
oc policy add-role-to-user admin system:serviceaccount:gpte-jenkins:jenkins -n ${GUID}-parks-dev
oc policy add-role-to-user admin system:serviceaccount:gpte-jenkins:jenkins -n ${GUID}-parks-prod

oc annotate namespace ${GUID}-nexus      openshift.io/requester=${USER} --overwrite
oc annotate namespace ${GUID}-sonarqube  openshift.io/requester=${USER} --overwrite
oc annotate namespace ${GUID}-jenkins    openshift.io/requester=${USER} --overwrite
oc annotate namespace ${GUID}-parks-dev  openshift.io/requester=${USER} --overwrite
oc annotate namespace ${GUID}-parks-prod openshift.io/requester=${USER} --overwrite

#Put the actual GUID into the nexus_settings file
# ls ../../
# ls ../
# ls
sed -i -e 's/GUID/$GUID/g' nexus_settings.xml