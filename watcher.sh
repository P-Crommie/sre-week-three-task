import subprocess
import time

# Name of the namespace
NAMESPACE = "sre"

# Name of the deployment
DEPLOYMENT = "swype-app"

# Maximum number of restarts before scaling down
MAX_RESTARTS = 4

while True:
    # Get the number of restarts of the pod
    restarts = subprocess.getoutput(f"kubectl get pods -n {NAMESPACE} -l app={DEPLOYMENT} -o jsonpath='{{.items[0].status.containerStatuses[0].restartCount}}'")

    print(f"Current number of restarts: {restarts}")

    # If the number of restarts is greater than the maximum allowed, scale down the deployment
    if int(restarts) > MAX_RESTARTS:
        print("Maximum number of restarts exceeded. Scaling down the deployment...")
        subprocess.run(f"kubectl scale --replicas=0 deployment/{DEPLOYMENT} -n {NAMESPACE}", shell=True)
        break

    # Wait for a while before the next check
    time.sleep(60)
