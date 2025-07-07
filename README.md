# 🧠 Be A Man Level 6 – k6 Load Testing & Grafana Monitoring

![Terraform](https://img.shields.io/badge/IaC-Terraform-blueviolet)
![GCP](https://img.shields.io/badge/Cloud-Google%20Cloud-yellow)
![Challenge](https://img.shields.io/badge/Challenge-Level%206-red)
![Status](https://img.shields.io/badge/Build-Success-brightgreen)
![Monitoring](https://img.shields.io/badge/Observability-Grafana-orange)
![LoadTest](https://img.shields.io/badge/k6-Test-Green)

---

This project automates the deployment of a scalable GCP infrastructure using **Terraform**, validated with **k6 load tests** and monitored through **Grafana dashboards**. Infrastructure includes a Windows VM, a MIG behind an internal load balancer, and automated autoscaling with customized startup scripts and tagging policies.

---

## 🎯 Objective

Deploy a multi-zone GCP architecture using Infrastructure as Code. Simulate real-world load with `k6` and track system health and scalability using Grafana, a leading observability platform.

---

## 🧱 Project Structure

```plaintext
GCP-BE-A-MAN-LEVEL-6/
.
├── easy-peasy-k6-tests/
│   ├── 001-small.js
│   ├── 002-medium.js
│   ├── 003-large.js
│   └── README.md
│
├── terraform/
│   ├── 0-authentication.tf
│   ├── 1-provider.tf
│   ├── 2-variables.tf
│   ├── 3-vpc.tf
│   ├── 4-subnets.tf
│   ├── 5-firewalls.tf
│   ├── 6-vm-instances.tf
│   ├── 7-instance-template.tf
│   ├── 8-mig.tf
│   ├── 9-health-checks.tf
│   ├── 10-autoscale-policy.tf
│   ├── 11-lb.tf
│   └── 12-outputs.tf
│
├── Screenshots/
│   ├── 1-k6-run-scripts-js-up-and-down-stages.jpg
│   ├── 1-k6-run-scripts-js-with-javascript-code.jpg
│   ├── 1-k6-run-scripts-js.jpg
│   ├── 1-k6-run-vus-10-duration-30.jpg
│   ├── beron-001-small-js.jpg
│   ├── beron-002-medium-js.jpg
│   ├── brazil1.jpg
│   ├── brazil2.jpg
│   ├── brazil3.jpg
│   ├── curl-load-balancer-ip1.jpg
│   ├── curl-load-balancer-ip2.jpg
│   ├── firewall-rules.jpg
│   ├── gcloud-compute-firewall-rules-allow-grafana-http.jpg
│   ├── gcloud-compute-instance-grafana-vm.jpg
│   ├── gcloud-compute-instances-describe-grafana-vm.jpg
│   ├── gcloud-compute-ssh-confirm.jpg
│   ├── gcloud-compute-ssh-popup.jpg
│   ├── grafana-homepage.jpg
│   ├── grafana-login-screen.jpg
│   ├── grafana-update-password1.jpg
│   ├── grafana-update-password2.jpg
│   ├── grafana-visualization.jpg
│   ├── load-balancer-summary.jpg
│   ├── ssh-sudo-apt-get-install-grafana.jpg
│   ├── ssh-sudo-apt-get-install.jpg
│   ├── ssh-sudo-apt-get-update.jpg
│   ├── ssh-sudo-apt-get-update2.jpg
│   ├── ssh-systemctl-enable-start-grafana-server.jpg
│   ├── ssh-wget-q-0-grafana.jpg
│   ├── terraform-apply.jpg
│   ├── terraform-autoscaler.jpg
│   └── vm-instances.jpg
│
├── brazil.sh
├── class-6-5-tiqs-*.json
├── GUIDE.md
├── README.md
└── REPORT.md
```

---

## 🚀 Features

- 1 VPC + regional subnets
- 1 Windows VM with RDP
- Regional MIG across 3 zones
- Internal Load Balancer with Health Check
- Autoscaling via CPU threshold
- Public Grafana VM with dashboard setup
- k6 load testing with metrics output

---

## 🔧 Deploy This Project

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply -auto-approve
```

---

## 📊 Load Testing Summary

- Scripts: `001-small.js`, `002-medium.js`
- Peak VUs: 600
- Response Time (p95): ~380ms
- Autoscaled to 5 instances
- Pass rate: 99.98% success

---

## 🖥️ Grafana Monitoring

Grafana deployed on a GCP VM using:

```bash
sudo apt-get install grafana -y
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

URL: `http://<GRAFANA_VM_IP>:3000`

---

## 📸 Key Screenshots

| Description               | File                                                              |
|---------------------------|-------------------------------------------------------------------|
| Load Balancer Summary     | `Screenshots/load-balancer-summary.jpg`                          |
| MIG & Autoscaler Output   | `Screenshots/terraform-autoscaler.jpg`                           |
| VM Instances (Zone A–C)   | `Screenshots/brazil1.jpg`, `brazil2.jpg`, `brazil3.jpg`          |
| Grafana Login & UI        | `grafana-login-screen.jpg`, `grafana-visualization.jpg`          |
| Firewall Rules & CLI Ops  | Various `gcloud` command results in `/Screenshots` folder        |

---

## 🛠️ Troubleshooting

| Issue | Resolution |
|-------|------------|
| Load balancer unhealthy | Check firewall allows health check IPs |
| k6 test fails | Confirm app is reachable and Apache is active |
| Grafana not loading | Open port 3000 and restart the service |
| Autoscaling not working | Confirm MIG tag and CPU policy matches |

---

## 🧹 Teardown

```bash
terraform destroy -auto-approve
```

---

## ✍️ Author & Credits

- **Author:** T.I.Q.S.
- **Group Lead:** John Sweeney

### 👑 Inspiration

This project was inspired by:

- Sensei **"Darth Malgus" Theo**
- Lord **Beron**
- Sir **Rob**
- Jedi Master **Derrick**

---
