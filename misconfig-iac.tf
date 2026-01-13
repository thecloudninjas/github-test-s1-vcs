apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-binding
subjects:
  - kind: ServiceAccount
    name: admin-sa
    namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-admin      # ❌ Full cluster access
  apiGroup: rbac.authorization.k8s.io
