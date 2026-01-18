# Lab 1: Inventory and Ping

Objective:
Create inventory and test connectivity.

Tasks:
1. Create inventory/hosts
2. Add two servers
3. Run ansible ping

## Steps for Amazon Linux

For Amazon Linux, the default SSH user is ec2-user.

**Step 1: Create inventory file**

```
mkdir ansible-lab
cd ansible-lab
nano hosts
```

Add this:

```
[servers]
server1 ansible_host=13.234.56.10 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem
server2 ansible_host=13.234.56.11 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem
```

Replace:

- 13.234.56.10, 13.234.56.11 → your EC2 public IPs
- mykey.pem → your EC2 key pair file

Make sure key permission is correct:

```
chmod 400 ~/.ssh/mykey.pem
```

**Step 2: Test SSH manually (important)**

```
ssh -i ~/.ssh/mykey.pem ec2-user@13.234.56.10
ssh -i ~/.ssh/mykey.pem ec2-user@13.234.56.11
```

If this works, Ansible will work.

**Step 3: Verify inventory**

```
ansible-inventory -i hosts --list
```

**Step 4: Run Ansible Ping**

```
ansible -i hosts servers -m ping
```

Expected output:

```
server1 | SUCCESS => {
  "changed": false,
  "ping": "pong"
}
server2 | SUCCESS => {
  "changed": false,
  "ping": "pong"
}
```

If you get Python error on Amazon Linux:

Amazon Linux 2 / 2023 usually already has Python3, but if not:

```
sudo yum install -y python3
```

Or tell Ansible explicitly:

```
[servers]
server1 ansible_host=13.234.56.10 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem ansible_python_interpreter=/usr/bin/python3
server2 ansible_host=13.234.56.11 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem ansible_python_interpreter=/usr/bin/python3
```
