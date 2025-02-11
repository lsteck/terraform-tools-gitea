#!/usr/bin/env bash

NAMESPACE="$1"
NAME="$2"
CHART="$3"

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR="./tmp"
fi
mkdir -p "${TMP_DIR}"

VALUES_FILE="${TMP_DIR}/${NAME}-values.yaml"

echo "${VALUES_FILE_CONTENT}" > "${VALUES_FILE}"

HELM=$(command -v helm || command -v ./bin/helm)

if [[ -z "${HELM}" ]]; then
  curl -sLo helm.tar.gz https://get.helm.sh/helm-v3.6.1-linux-amd64.tar.gz
  tar xzf helm.tar.gz
  mkdir -p ./bin && mv ./linux-amd64/helm ./bin/helm
  rm -rf linux-amd64
  rm helm.tar.gz

  HELM="$(cd ./bin; pwd -P)/helm"
fi

kubectl config set-context --current --namespace "${NAMESPACE}"

if [[ -n "${REPO}" ]]; then
  repo_config="--repo ${REPO}"
fi

# ${HELM} template "${NAME}" "${CHART}" ${repo_config} --values "${VALUES_FILE}" | kubectl delete -f -
${HELM} template "${NAME}" "${CHART}" ${repo_config} --values "${VALUES_FILE}" 
