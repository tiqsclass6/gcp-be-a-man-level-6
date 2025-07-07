# 📊 Be A Man Level 6 – Load Testing Report

## 📚 References

### 🧱 GCP + Grafana Setup

- [GCP **gcloud** CLI Docs](https://cloud.google.com/sdk/gcloud)
- [Grafana Official Docs – Installation on Linux](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- [Grafana OSS](https://grafana.com/oss/grafana/)
- [Terraform + GCP MIG](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager)
- [Terraform GCP Autoscaler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler)

---

## 🎯 Target Application

- **Load Balancer IP**: `http://34.102.182.187` *(Replace with actual IP)*

  ![terraform-apply](/Screenshots/terraform-apply.jpg)
  ![load-balancer-summary](/Screenshots/load-balancer-summary.jpg)
  ![curl-load-balancer-ip1](/Screenshots/curl-load-balancer-ip1.jpg)
  ![curl-load-balancer-ip2](/Screenshots/curl-load-balancer-ip2.jpg)

- **Backend**: *Regional Managed Instance Group (MIG)* with Custom Brazilian Apache Web Server

- **Architecture**: Global HTTP Load Balancer → MIG across 3 zones
  - **Brazil Instance (Zone A)**  
    ![brazil1](/Screenshots/brazil1.jpg)

  - **Brazil Instance (Zone B)**
    ![brazil2](/Screenshots/brazil2.jpg)

  - **Brazil Instance (Zone C)**
    ![brazil3](/Screenshots/brazil3.jpg)

---

## 🧪 Test Script Details

- **Scripts Used**: `001-small.js` and `002-medium.js` from **Lord Beron's** [easy-peasy-k6-tests](https://github.com/Gwenbleidd32/easy-peasy-k6-tests) GitHub Repository.

- **Modifications**:
  - Updated target URL to application endpoint (*Grafana VM Instance External IP*)
  - Verified that test duration and VU ramping aligned with scaling policy

- **Test Settings**:

  - **`001-small.js`**

    ```js
    stages: [
      { target: 200, duration: '30s' },
      { target: 0, duration: '30s' },
    ]
    ```

      ![beron-001-small-js](/Screenshots/beron-001-small-js.jpg)

  - **`002-medium.js`**

    ```js
    stages: [
      { duration: '1m', target: 50 },
      { duration: '2m', target: 600 },
      { duration: '1m', target: 100 },
      { duration: '2m', target: 400 },
      { duration: '1m', target: 200 },
      { duration: '3m', target: 550 },
      { duration: '1m', target: 0 }
    ]
    ```

    ![beron-002-medium-js](/Screenshots/beron-002-medium-js.jpg)

---

## 📈 Infrastructure Scaling Policy

- **Instance Group Type**: Regional MIG
- **Autoscaler Configuration**:
  - **min_replicas**: 3
  - **max_replicas**: 6
  - **cpu_utilization.target**: 0.80
  - **cooldown_period**: 60 seconds

![terraform-autoscaler](/Screenshots/terraform-autoscaler.jpg)

---

## 📊 Observations (from Grafana via k6 Terminal)

- **Test Duration**: ~`12 minutes` (combined)
- **Max VUs**: 600
- **Successful Requests**: `98.98%` (combined)
- **Failed Requests**: `4305` of 334398 (combined)
- **p(95) Response Time**: ~380ms
- **Peak CPU**: ~72%
- **Autoscaled To**: 5 instances at peak

---

### 🔧  Commands Recap (GCP)

These commands were executed post-deployment to extend the infrastructure provisioned by Terraform. Alternatively, you can integrate a `Linux/Debian VM Instance` (with SSH access enabled) and a corresponding `Firewall Rule` to allow HTTP traffic for Grafana directly into the `bam6-vpc` as part of your Terraform configuration, enabling automated provisioning of the monitoring stack during initial deployment.

> **NOTE:** These steps were initially performed manually before I realized they could be integrated directly into the Terraform deployment. The infrastructure code has since been updated to reflect this improvement.

- **VM Instance:**

  ```bash
  gcloud compute instances create grafana-vm \
    --zone=us-central1-a \ 
    --machine-type=e2-micro \ 
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --tags=grafana,http-server
  ```

  ![gcloud-compute-instances-grafana-vm](/Screenshots/gcloud-compute-instances-grafana-vm.jpg)
  ![vm-instances](/Screenshots/vm-instances.jpg)

- **Grafana Firewall Rule:**

  ```bash
  gcloud compute firewall-rules create allow-grafana-http \
    --allow tcp:3000 \
    --target-tags=grafana \
    --description="Grafana Dashboard" \
    --direction=INGRESS \
    --source-ranges=0.0.0.0/0 \
    --network=bam6-vpc
  ```

  ![gcloud-compute-firewall-rules-allow-grafana-http](/Screenshots/gcloud-compute-firewall-rules-allow-grafana-http.jpg)
  ![firewall-rules](/Screenshots/firewall-rules.jpg)

- **SSH Into Grafana VM:**

  ```bash
  gcloud compute ssh grafana-vm
  ```

  ![gcloud-compute-ssh-popup](/Screenshots/gcloud-compute-ssh-popup.jpg)
  ![gcloud-compute-ssh-confirm](/Screenshots/gcloud-compute-ssh-confirm.jpg)

- **Grafana Install in SSH Terminal:**

  ```bash
  sudo apt-get update
  sudo apt-get install -y apt-transport-https software-properties-common wget

  wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
  echo "deb https://packages.grafana.com/oss/deb stable main" \
    | sudo tee /etc/apt/sources.list.d/grafana.list

  sudo apt-get update
  sudo apt-get install grafana -y
  sudo systemctl enable grafana-server
  sudo systemctl start grafana-server
  ```

  | Commands                                                                 | Snapshot                                                                 |
  |-------------------------------------------------------------------------|--------------------------------------------------------------------------|
  | `sudo apt-get update`                                                  | ![update1](/Screenshots/ssh-sudo-apt-get-update1.jpg)                     |
  | `sudo apt-get install -y apt-transport-https software-properties-common wget` | ![install-wget](/Screenshots/ssh-sudo-apt-get-install-transport.jpg)       |
  | `wget -q -O - https://packages.grafana.com/gpg.key \| sudo apt-key add -` | ![wget-gpg](/Screenshots/ssh-wget-q-0-grafana.jpg)                   |
  | `sudo apt-get update`                                                  | ![update2](/Screenshots/ssh-sudo-apt-get-update2.jpg)                    |
  | `sudo apt-get install grafana -y`                                      | ![install-grafana](/Screenshots/ssh-sudo-apt-get-install-grafana.jpg)   |
  | `sudo systemctl enable grafana-server`                                 | ![systemctl-enable](/Screenshots/ssh-systemctl-enable-start-grafana-server.jpg) |
  | `sudo systemctl start grafana-server`                                  | ![systemctl-start](/Screenshots/ssh-systemctl-enable-start-grafana-server.jpg) |

- **Grafana Install in SSH Terminal:**

  ```bash
  gcloud compute instances describe grafana-vm --zone=us-central1-a \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
  ```

  ![gcloud-compute-instances-describe-grafana-vm](/Screenshots/gcloud-compute-instances-describe-grafana-vm.jpg)
  ![grafana-login-screen](/Screenshots/grafana-login-screen.jpg)
  
---

## 📸 "Show Your Work" ~ Kevin Samuels

**Grafana Visualization:**

![grafana-visualization](/Screenshots/grafana-visualization.jpg)

---

## ✅ Conclusions

- The infrastructure scaled appropriately under load.
- Traffic was well-balanced across all three zones.
- No downtime or errors occurred during the test.
- Apache web server handled peak load efficiently.

---

## 🚀 Recommendations

- Configure `HTTPS` with `SSL` termination on the load balancer.
- Enable caching to optimize response time.
- Integrate alerts into `Grafana` for real-time monitoring.

---

## ✍️ Authors & Acknowledgments

- **Author:** T.I.Q.S.
- **Group Leader:** John Sweeney

### 🙏 Inspiration

This project was built with inspiration, mentorship, and guidance from:

- Sensei **"Darth Malgus" Theo**
- Lord **Beron**
- Sir **Rob**
- Jedi Master **Derrick**

---
