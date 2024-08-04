#!/bin/sh

# YOU MAY NEED THIS IF YOU USE MINIKUBE / KUBERNETES.
# RUN THIS SCRIPT TO INSTALL `CRICTL`

# shellcheck source-path=../..
. ../../helpers.sh

env_var
setup_color

# CONTAINER RUNTIME INTERFACE (CRI) CLI
# CLI and validation tools for Kubelet Container Runtime Interface (CRI) .

# Source:
# https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md

# `crictl` provides a CLI for CRI-compatible container runtimes.
# This allows the CRI runtime developers to debug their runtime without needing to
# set up Kubernetes components. `crictl` has been GA since v1.11.0 and is currently
# under active development. It is hosted at the cri-tools  repository. We encourage
# the CRI developers to report bugs or help extend the coverage by adding more functionalities.

# The tool expects JSON or YAML encoded files as input and passes them to
# the corresponding container runtime using the CRI API protocol.

# INSTALL:
echo "${COLOR_BLUE}'crictl' provides a CLI for CRI-compatible container runtimes."
echo "This allows the CRI runtime developers to debug their runtime without needing to set up Kubernetes components."
if checkyes "Install crictl?"; then
  if hash wget 2>/dev/null; then
    VERSION="v1.30.0" # check latest version in /releases page
    wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
    sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
    rm -f crictl-$VERSION-linux-amd64.tar.gz
  else
    VERSION="v1.30.0" # check latest version in /releases page
    curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-linux-amd64.tar.gz --output crictl-${VERSION}-linux-amd64.tar.gz
    sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
    rm -f crictl-$VERSION-linux-amd64.tar.gz
  fi
  fmtsuccess "Done setting up 'crictl'. Get start by showing help options: 'crictl help'."
fi

# USAGE: crictl [global options] command [command options] [arguments...]
