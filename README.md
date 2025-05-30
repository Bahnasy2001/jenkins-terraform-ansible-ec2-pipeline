# Terraform + Ansible Pipeline for EC2 Setup 🚀

This project automates creating an AWS EC2 instance using **Terraform** and configures it using **Ansible** inside a **Jenkins pipeline**. The EC2 instance installs **nginx** and sets up an `ansible` user with SSH access.

---

## 🗂️ Project Structure

```
.
├── Jenkinsfile                # Pipeline script
├── terraform/                 # Terraform code to create EC2 and keypair
│   ├── provider.tf
│   ├── keypair.tf
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
└── ansible/                   # Ansible configuration and playbook
    ├── ansible.cfg
    ├── aws_ec2.yaml           # Dynamic inventory config for AWS EC2 plugin
    └── playbook.yml           # Ansible playbook to configure EC2
```

---

## ⚙️ How It Works

1. **Terraform Stage:**

   * Initializes Terraform.
   * Creates an EC2 instance in `eu-central-1` region (AMI: Amazon Linux).
   * Creates and imports an SSH keypair into AWS using the public key from Jenkins credentials.

2. **Wait Stage:**

   * Waits until the EC2 instance status is `ok` (ready to connect).

3. **Ansible Stage:**

   * Uses dynamic inventory with `aws_ec2.yaml` to target the created instance.
   * Runs `playbook.yml` to:

     * Create a new `ansible` user with sudo privileges.
     * Setup SSH access by copying authorized keys from `ec2-user`.
     * Install and start nginx web server.
     * Open port 80 in the firewall (if applicable).

---

## 📋 Jenkinsfile Key Points

* Uses environment variables and Jenkins credentials:

  * AWS credentials for Terraform and AWS CLI commands.
  * SSH public and private keys for EC2 access.
* Runs all steps automatically in the pipeline.

---

## 📄 Terraform Details

* **provider.tf:** Sets AWS provider and region.
* **keypair.tf:** Creates/imports SSH keypair from public key file.
* **main.tf:** Defines EC2 instance with tag `Jenkins-Terraform-EC2`.
* **variables.tf:** Holds path to public key file.
* **output.tf:** Outputs public IP of created EC2.

---

## 📄 Ansible Details

* **ansible.cfg:** Disables host key checking and points to dynamic inventory file.
* **aws\_ec2.yaml:** Uses AWS EC2 dynamic inventory plugin, filters instances by tag.
* **playbook.yml:**

  * Creates `ansible` user with sudo rights.
  * Copies SSH keys from `ec2-user` to `ansible`.
  * Installs and enables nginx.
  * Opens port 80 for HTTP traffic on RedHat-based systems.

---

## 🚩 Notes

* Make sure Jenkins credentials for AWS and SSH keys are configured properly.
* The EC2 AMI ID used (`ami-02b7d5b1e55a7b5f1`) is for Amazon Linux in `eu-central-1` — update if region changes.
* Firewall opening task ignores errors if the system is not RedHat-based.
* Dynamic inventory simplifies targeting EC2 instances by tags.

---

## 🎯 How to Use

1. Push your code with this structure to Jenkins.
2. Setup required Jenkins credentials (`aws-creds`, `my-ssh-public-key`, `ansible-ssh-key`).
3. Run the pipeline.
4. Access the EC2 instance’s public IP (output from Terraform) to see nginx running.

---

## 🚀 Result

* EC2 instance launched and ready.
* Ansible user created with SSH access.
* Nginx installed and accessible on port 80.


