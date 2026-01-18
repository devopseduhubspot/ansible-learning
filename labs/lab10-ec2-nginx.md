# Lab 10: Deploy EC2 Instance with Nginx

## Objective:
Create an AWS EC2 instance using Ansible and deploy nginx with a custom index page.

## Prerequisites:
- AWS CLI configured with appropriate credentials
- Ansible collection for AWS: `ansible-galaxy collection install amazon.aws`
- Python boto3 library: `pip install boto3 botocore`

## Tasks:

### 1. Create Security Group
Create a security group that allows:
- SSH access (port 22) from your IP
- HTTP access (port 80) from anywhere
- HTTPS access (port 443) from anywhere

### 2. Create Key Pair
Generate or use an existing key pair for EC2 instance access.

### 3. Launch EC2 Instance
Create an EC2 instance with:
- AMI: Amazon Linux 2023 (or Ubuntu 22.04)
- Instance type: t3.micro (free tier eligible)
- Security group from step 1
- Key pair from step 2

### 4. Wait for Instance
Ensure the instance is running and accessible.

### 5. Install and Configure Nginx
- Install nginx package
- Create a custom index.html page
- Start and enable nginx service
- Ensure nginx is accessible via HTTP

### 6. Verify Deployment
- Test HTTP access to the web server
- Display the public IP address

## Expected Output:
```
TASK [Display website URL] 
ok: [localhost] => {
    "msg": "Website available at: http://YOUR_PUBLIC_IP"
}
```

## Bonus Tasks:
1. Add SSL certificate using Let's Encrypt
2. Create multiple instances with a load balancer
3. Use Ansible Vault to secure AWS credentials
4. Implement proper error handling and rollback

## Files to Create:
- `lab10.yml` - Main playbook
- `templates/index.html.j2` - Custom HTML template
- `group_vars/all.yml` - Variables file

## Variables to Define:
- `aws_region`: AWS region (e.g., us-east-1)
- `instance_type`: EC2 instance type
- `key_name`: EC2 key pair name
- `security_group_name`: Security group name

## Run the Playbook:
```bash
ansible-playbook lab10.yml
```

## Cleanup:
Remember to terminate the EC2 instance when done to avoid charges:
```bash
ansible-playbook lab10.yml --tags cleanup
```