#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

mise install

helm dependency update argocd

helm upgrade --install argocd ./argocd \
    --namespace argocd \
    --create-namespace \
    --render-subchart-notes \
    --wait \
    --timeout 5m

echo "==> Waiting for ArgoCD server to be ready..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=3m

echo "==> Applying ArgoCD root application..."
kubectl apply -f root-app.yaml
