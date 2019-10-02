#!/bin/bash

# bash profile_dump.sh '1.3.0 1.3.1' 'default demo demo-auth minimal sds'
ISTIO_VERS="${1:?Please list versions, e.g., 1.3.0 1.3.1}"
PROFILES="${2:?Please list versions, e.g., default demo demo-auth minimal sds}"
for ISTIO_VERSION in $ISTIO_VERS
do
    for PROFILE in $PROFILES
        do
        echo "Variables: Istio Version - $ISTIO_VERSION, Profile - $PROFILE"
        ~/istio-$ISTIO_VERSION/bin/istioctl x profile dump $PROFILE > /tmp/values.${ISTIO_VERSION//./-}.${PROFILE}.yaml
    done
done
