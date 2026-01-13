apiVersion: v1
kind: Pod
metadata:
  name: pod-running-as-root-explicit
spec:
  containers:
    - name: app
      image: nginx:latest
      securityContext:
        runAsUser: 0     # ❌ Explicit root
