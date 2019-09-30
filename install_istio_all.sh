#!/bin/bash
ISTIO_VERS="${1:?Please list versions, e.g., 1.1.0 1.1.1 1.1.2 1.1.3 1.1.4 1.1.5 1.1.6 1.1.7 1.1.8 1.1.9 1.1.10 1.1.11 1.1.12 1.1.13 1.1.14 1.1.15 1.2.0 1.2.1 1.2.2 1.2.3 1.2.4 1.2.5 1.2.6 1.3.0}"
PROFILES="${2:?Please list versions, e.g., default demo demo-auth minimal sds cni}"
for ISTIO_VERSION in $ISTIO_VERS
do
    for PROFILE in $PROFILES
        do
        echo "Variables: Istio Version - $ISTIO_VERSION, Profile - $PROFILE"
        bash ~/install_istio.sh $ISTIO_VERSION $PROFILE
    done
done
