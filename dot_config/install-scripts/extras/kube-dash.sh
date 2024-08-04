#!/bin/sh

## PLEASE DO NOT USE THIS SCRIPT SINCE I'M STILL WORKING ON IT.
## IF YOU WANT TO USE KUBERNETES DASHBOARD, PLEASE VISIT MAIN PAGE FOR MORE INFO
####### https://github.com/kubernetes/dashboard ########

# setup_kube_dash() {
#   echo "${YELLOW} Start setting up Kubernetes Dashboard"
#   echo "✨ ${RED}Adding kubernetes-dashboard repository...${RESET}"
#   helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
#   echo "✨ ${YELLOW}Deploy a Helm Release named '${GREEN}kubernetes-dashboard${YELLOW}' using the kubernetes-dashboard chart${RESET}"
#   helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
#   info "SUCCESS: Installed Kubernetes Dashboard. 🎉"
#   if checkyes "Create new user data for Kubernetes Dashboard?"; then

#     echo "✏️ ${BLUE}Creating a new ServiceAccount...${RESET}"
#     kubectl apply -f - <<EOF
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   name: admin-user
#   namespace: kubernetes-dashboard
# EOF

#     echo "✏️ ${BLUE}Creating a ClusterRoleBinding for the ServiceAccount...${RESET}"
#     kubectl apply -f - <<EOF
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   name: admin-user
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: cluster-admin
# subjects:
# - kind: ServiceAccount
#   name: admin-user
#   namespace: kubernetes-dashboard
# EOF

#     echo "✏️ ${BLUE}Getting the Token for the ServiceAccount...${RESET}"
#     kubectl -n kubernetes-dashboard describe secret "$(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')"
#     echo "✨ ${YELLOW}Please copy the token and copy it into the Dashboard login and press 'Sign in'!"
#   fi
#   echo "${GREEN}SUCCESS: You have now set up Kubernetes Dashboard!${RESET} 🎉"
# }
