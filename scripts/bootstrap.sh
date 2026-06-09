#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

mise install

kubectl apply --server-side -k ../platform/crds
kustomize build --enable-helm ../platform/argocd | kubectl apply --server-side -f -

echo "==> Waiting for ArgoCD server to be ready..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=3m

kubectl apply --server-side -f ../platform/argocd/bootstrap/root-app.yaml