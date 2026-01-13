apiVersion: v1
kind: Pod
metadata:
  name: critical-insecure-pod
spec:
  hostNetwork: true              # ❌ Host network access
  hostPID: true                  # ❌ Host process access
  hostIPC: true                  # ❌ Host IPC access
  containers:
    - name: attacker-container
      image: nginx
      securityContext:
        privileged: true         # ❌ CRITICAL
        runAsUser: 0             # ❌ Root user
        allowPrivilegeEscalation: true
        capabilities:
          add:
            - ALL                # ❌ Adds ALL Linux capabilities
      volumeMounts:
        - name: host-root
          mountPath: /host
  volumes:
    - name: host-root
      hostPath:
        path: /
        type: Directory
