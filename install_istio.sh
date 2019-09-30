#!/bin/bash

# Set up variables
ISTIO_VER="${1:?Please enter version, e.g., 1.3.1}"
PROFILE="${2:?Please enter a profile: default, demo, demo-auth, minimal, sds, cni}"
NAMESPACE=istio-system-${ISTIO_VER//./-}-$PROFILE

echo "Install Istio $ISTIO_VER with profile $PROFILE into namespace $NAMESPACE..."

# Download Istio
cd ~
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=$ISTIO_VER sh -
ISTIO_PATH=~/istio-$ISTIO_VER/

# Install Istio CRDs
cd $ISTIO_PATH
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/${ISTIO_VER}/charts/
kubectl create namespace $NAMESPACE
helm template install/kubernetes/helm/istio-init --name istio-init --namespace $NAMESPACE | kubectl apply -f -
sleep 60

# Install Istio
if [ "$PROFILE" = "default" ]; then
    helm template install/kubernetes/helm/istio --name istio --namespace $NAMESPACE | kubectl apply -f -
elif [ "$PROFILE" = "demo" ]; then
    helm template install/kubernetes/helm/istio --name istio --namespace $NAMESPACE \
        --values install/kubernetes/helm/istio/values-istio-demo.yaml | kubectl apply -f -
elif [ "$PROFILE" = "demo-auth" ]; then
    helm template install/kubernetes/helm/istio --name istio --namespace $NAMESPACE \
        --values install/kubernetes/helm/istio/values-istio-demo-auth.yaml | kubectl apply -f -
elif [ "$PROFILE" = "minimal" ]; then
    helm template install/kubernetes/helm/istio --name istio --namespace $NAMESPACE \
        --values install/kubernetes/helm/istio/values-istio-minimal.yaml | kubectl apply -f -
elif [ "$PROFILE" = "sds" ]; then
    helm template install/kubernetes/helm/istio --name istio --namespace $NAMESPACE \
        --values install/kubernetes/helm/istio/values-istio-sds-auth.yaml | kubectl apply -f -
elif [ "$PROFILE" = "cni" ]; then
    helm template install/kubernetes/helm/istio-cni --name=istio-cni --namespace=kube-system | kubectl apply -f -
    helm template install/kubernetes/helm/istio --name istio --namespace $NAMESPACE \
        --set istio_cni.enabled=true | kubectl apply -f -
fi

