apiVersion: v1
kind: Pod
metadata:
  name: with-vulnerabilities
spec:
  hostNetwork: true               # ❌ Shares node network namespace
  hostPID: true                   # ❌ Shares node process namespace
  containers:
    - name: insecure-container
      image: your-container-image:tag
      securityContext:
        runAsUser: 0              # ❌ Runs as root
        privileged: true          # ❌ Full privileges on the node
        allowPrivilegeEscalation: true  # ❌ Can escalate privileges
        capabilities:
          add:
            - NET_RAW             # ❌ Enables raw sockets (often flagged)
            - SYS_ADMIN           # ❌ Very powerful capability
      volumeMounts:
        - name: host-root
          mountPath: /host        # ❌ Mounts host filesystem inside container
  volumes:
    - name: host-root
      hostPath:
        path: /                   # ❌ HostPath to node root (critical risk)
        type: Directory
