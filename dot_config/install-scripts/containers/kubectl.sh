#!/bin/sh

# shellcheck source-path=../..
. ../../helpers.sh

env_var
setup_color

has_brew() {
  type brew >/dev/null
}

setup_kubectl() {
  if has_brew; then
    fmtinfo "Installing/Updating kubectl with Homebrew..."
    check_brew_packages kubectl
  else
    fmtinfo "Installing/Update kubectl with apt..."
    check_apt_packages apt-transport-https ca-certificates curl gnupg
    # If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' |
      sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list # helps tools such as command-not-found to work correctly
    sudo apt update
    sudo apt install -y kubectl
  fi
  fmtsuccess "Installed Kubectl successfully" || fmterror "Failed installed Kubectl"
}

setup_kind() {
  if has_brew; then
    fmtinfo "Installing/Updating KinD with Homebrew..."
    check_brew_packages kind
  else
    fmtinfo "Installing/Updating KinD with curl..."
    cd "$HOME" && [ "$(uname -m)" = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
  fi
  fmtsuccess "Installed KinD successfully" || fmterror "Failed to install KinD"
}

setup_helm() {
  if has_brew; then
    fmtinfo "Installing/Updating Helm with Homebrew..."
    check_brew_packages helm
  else
    fmtinfo "Installing/Updating Helm with curl"
    check_apt_packages apt-transport-https
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt update
    sudo apt install helm
  fi
}

setup_minikube() {
  fmtinfo "Installing minikube from binary source..."
  echo "${COLOR_YELLOW}For more information, please visit https://minikube.sigs.k8s.io/docs${RESET}"
  check_apt_packages conntrack

  cd "$HOME" && curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

  # Troubleshooting for wsl
  if [ "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')" ]; then
    sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
  fi

  if checkyes "Set default driver?"; then
    echo "${COLOR_PINK}List of drivers available: "
    echo "${COLOR_YELLOW}hyperkit | hyperv | kvm2 | docker | none | podman | "
    echo "qemu | ssh | parallels | virtualbox | vmware | qemu2 ${FMT_RESET}"
    printf "Select your favor driver: " && read -r selected_driver
    minikube config set driver "$selected_driver"
    fmtsuccess "You have set default driver as $selected_driver!"
  else
    fmtinfo "You can set default driver later with: 'minikube config set driver ...'"
  fi
  fmtsuccess "Done install minikube" || fmterror "Failed to install minikube"
}

main() {
  if checkyes "Install/Update kubectl?"; then
    setup_kubectl
  fi
  if checkyes "Install/Update KinD?"; then
    setup_kind
  fi
  if checkyes "Install/Update helm?"; then
    setup_helm
  fi
  if checkyes "Install minikube?"; then
    setup_minikube
  fi
}
main
