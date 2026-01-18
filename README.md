# Ansible Learning Labs - README

## Overview
This repository contains hands-on Ansible labs for learning automation and configuration management. The labs progress from basic concepts to advanced topics including cloud deployments and Windows management.

---

## Lab Structure

### Available Labs:
- **Lab 1**: Inventory Management
- **Lab 2**: First Playbook
- **Lab 3**: Package Installation
- **Lab 4**: Variables
- **Lab 5**: Handlers
- **Lab 6**: Loops
- **Lab 7**: Conditions
- **Lab 8**: Roles
- **Lab 9**: Vault
- **Lab 10**: EC2 with Nginx Deployment
- **Lab 11**: Windows Host Management

---

## Lab 11: Windows Host Management - Complete Setup Guide

### 🎯 Objective
Connect to an existing Windows machine on AWS and perform various administrative tasks to demonstrate Ansible Windows management capabilities.

### 📋 Prerequisites

#### 1. System Requirements
```bash
# Install required Python packages
pip install pywinrm
pip install pywinrm[kerberos]  # Optional: for Kerberos auth
```

#### 2. Existing Windows Server
- Windows Server running on AWS (any version 2012+)
- Administrator access credentials
- Security group allowing ports 3389 (RDP) and 5985/5986 (WinRM)

---

### 🔧 Step 1: Configure Windows Host for WinRM

#### Option A: Via RDP (Recommended)
1. Connect to your Windows server via RDP
2. Open **PowerShell as Administrator**
3. Run the following commands:

```powershell
# Enable WinRM
winrm quickconfig -q

# Allow unencrypted traffic (for basic auth - lab only!)
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Enable basic authentication
winrm set winrm/config/service/auth '@{Basic="true"}'

# Increase memory limit
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'

# Check WinRM listeners
winrm enumerate winrm/config/listener

# Verify WinRM service is running
Get-Service WinRM
```

#### Option B: Via AWS Systems Manager (if configured)
```bash
aws ssm send-command \
    --instance-ids "i-1234567890abcdef0" \
    --document-name "AWS-RunPowerShellScript" \
    --parameters 'commands=["winrm quickconfig -q","winrm set winrm/config/service @{AllowUnencrypted=\"true\"}"]'
```

---

### 📝 Step 2: Update Ansible Inventory

#### Edit `inventory/hosts` file:
```ini
[web]
3.109.201.228 ansible_user=ec2-user ansible_ssh_private_key_file=~/ansible-key-ec2.pem

[windows]
YOUR_WINDOWS_IP ansible_host=YOUR_WINDOWS_IP ansible_user=Administrator ansible_password=YOUR_PASSWORD ansible_connection=winrm ansible_winrm_transport=basic ansible_winrm_server_cert_validation=ignore ansible_winrm_port=5985
```

#### Replace the following values:
- `YOUR_WINDOWS_IP`: Your Windows server's **public IP address**
- `YOUR_PASSWORD`: Your Administrator password

#### Example:
```ini
[windows]
54.123.45.67 ansible_host=54.123.45.67 ansible_user=Administrator ansible_password=MySecurePass123! ansible_connection=winrm ansible_winrm_transport=basic ansible_winrm_server_cert_validation=ignore ansible_winrm_port=5985
```

---

### 🔍 Step 3: Test Connectivity

#### Test WinRM connection:
```bash
# Test basic connectivity
ansible windows -m win_ping

# Expected output:
# 54.123.45.67 | SUCCESS => {
#     "changed": false,
#     "ping": "pong"
# }
```

#### If connection fails, troubleshoot:
```bash
# Test with verbose output
ansible windows -m win_ping -vvv

# Check if port is open
telnet YOUR_WINDOWS_IP 5985

# Test from Windows server locally
winrm get winrm/config
```

---

### 🚀 Step 4: Run the Lab

#### Execute the complete lab:
```bash
ansible-playbook solutions/lab11.yml
```

#### Run specific sections with tags:
```bash
# Test connectivity only
ansible-playbook solutions/lab11.yml --tags connectivity

# Install software only  
ansible-playbook solutions/lab11.yml --tags software

# Configure IIS only
ansible-playbook solutions/lab11.yml --tags iis

# Generate final report
ansible-playbook solutions/lab11.yml --tags report
```

---

### 📊 Step 5: Verify Results

#### 1. Check Web Interface
```
http://YOUR_WINDOWS_IP/ansible-demo.html
```

#### 2. Review Created Files (via RDP)
- **Main Directory**: `C:\AnsibleDemo\`
- **Scripts**: `C:\AnsibleDemo\Scripts\demo-script.ps1`
- **Data**: `C:\AnsibleDemo\Data\`
- **Summary**: `C:\AnsibleDemo\SUMMARY-REPORT.txt`

#### 3. Verify Installed Software
```bash
# Check via Ansible
ansible windows -m win_shell -a "choco list --local-only"

# Check via RDP - Programs and Features
```

---

### 🎯 What This Lab Demonstrates

#### ✅ Connection Management
- WinRM protocol configuration
- Basic authentication setup
- Secure connection handling
- Connection troubleshooting

#### ✅ Software Management  
- Chocolatey package manager installation
- Automated software installation (Notepad++, 7-Zip, Chrome)
- Package verification and management

#### ✅ File Operations
- Directory structure creation
- File creation with dynamic content
- PowerShell script generation
- Template-based file creation

#### ✅ Windows Features
- IIS Web Server installation
- Windows feature management
- Service configuration
- Web content deployment

#### ✅ System Administration
- PowerShell command execution
- System information gathering
- Service management (start/stop/configure)
- Windows-specific administrative tasks

#### ✅ Ansible Integration
- Windows-specific modules usage
- Variable templating in Windows context
- Error handling and reporting
- Comprehensive automation workflow

---

### 🛡️ Security Considerations

#### Lab Environment (Current Setup)
```yaml
# Basic authentication - INSECURE but simple
ansible_connection: winrm
ansible_winrm_transport: basic
ansible_winrm_server_cert_validation: ignore
```

#### Production Recommendations
```yaml
# HTTPS with certificate validation
ansible_connection: winrm
ansible_winrm_transport: ssl
ansible_winrm_server_cert_validation: validate
ansible_winrm_port: 5986

# Or use Kerberos authentication
ansible_winrm_transport: kerberos
```

#### Best Practices:
1. **Use Ansible Vault** for passwords:
   ```bash
   ansible-vault create group_vars/windows.yml
   ```

2. **Enable HTTPS WinRM**:
   ```powershell
   winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="YOUR_HOSTNAME";CertificateThumbprint="YOUR_CERT_THUMBPRINT"}'
   ```

3. **Restrict access** by IP in security groups

4. **Use domain authentication** in Active Directory environments

---

### 🔧 Troubleshooting

#### Common Issues and Solutions

##### 1. Connection Timeout
```
UNREACHABLE! => {"changed": false, "msg": "ssl: HTTPSConnectionPool(host='X.X.X.X', port=5986)"}
```
**Solution**: Check security group allows port 5985/5986, verify WinRM is running

##### 2. Authentication Failed  
```
UNREACHABLE! => {"changed": false, "msg": "basic auth failed"}
```
**Solution**: Verify username/password, check basic auth is enabled

##### 3. PowerShell Execution Policy
```
"msg": "PowerShell execution policy is too restrictive"
```
**Solution**: 
```powershell
Set-ExecutionPolicy RemoteSigned -Force
```

##### 4. Chocolatey Installation Fails
**Solution**: Run manually first:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

#### Debug Commands
```bash
# Verbose ansible execution
ansible-playbook solutions/lab11.yml -vvv

# Test specific module
ansible windows -m win_shell -a "Get-Service WinRM"

# Check WinRM configuration
ansible windows -m win_shell -a "winrm get winrm/config"
```

---

### 📈 Expected Output

#### Successful Execution:
```
PLAY [Windows Host Management with Ansible] ************************************

TASK [Test Windows connectivity] ***********************************************
ok: [54.123.45.67]

TASK [Get system information] **************************************************
ok: [54.123.45.67]

TASK [Install Chocolatey if not present] ***************************************
changed: [54.123.45.67]

TASK [Install useful software packages] ****************************************
changed: [54.123.45.67]

TASK [Create demo directory structure] *****************************************
changed: [54.123.45.67] => (item=C:\AnsibleDemo)
changed: [54.123.45.67] => (item=C:\AnsibleDemo\Scripts)

TASK [Install IIS Web Server] **************************************************
changed: [54.123.45.67]

TASK [Display final success message] *******************************************
ok: [54.123.45.67] => {
    "msg": [
        "🎉 Ansible Windows management demonstration completed successfully!",
        "📋 Summary report created: C:\\AnsibleDemo\\SUMMARY-REPORT.txt",
        "🌐 Web demo available: http://54.123.45.67/ansible-demo.html"
    ]
}

PLAY RECAP **********************************************************************
54.123.45.67               : ok=15   changed=8    unreachable=0    failed=0
```

---

### 🎓 Learning Outcomes

After completing this lab, you will understand:

1. **WinRM Configuration** - How to set up Windows Remote Management
2. **Ansible Windows Modules** - Difference between Linux and Windows modules  
3. **PowerShell Integration** - Running PowerShell commands via Ansible
4. **Windows Package Management** - Using Chocolatey with Ansible
5. **Windows Feature Management** - Enabling/disabling Windows features
6. **File Operations** - Creating files and directories on Windows
7. **Service Management** - Managing Windows services
8. **Web Server Deployment** - Installing and configuring IIS
9. **System Administration** - Comprehensive Windows management
10. **Security Considerations** - Production-ready WinRM setup

---

### 🔄 Next Steps

#### Expand Your Windows Automation:
1. **Active Directory Integration**
2. **SQL Server Installation and Configuration** 
3. **Windows Updates Management**
4. **Registry Modifications**
5. **Group Policy Management**
6. **Certificate Management**
7. **Scheduled Tasks Creation**
8. **Windows Firewall Configuration**

#### Advanced Topics:
- **Ansible Tower/AWX** for enterprise management
- **Dynamic Inventory** for AWS Windows instances
- **Custom Windows Modules** development
- **Integration with CI/CD pipelines**

---

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify all prerequisites are met
3. Test connectivity step by step
4. Review Ansible and Windows logs
5. Ensure security groups and firewalls allow required ports

---

*This README provides complete step-by-step instructions for successfully implementing Ansible Windows management. Follow each step carefully for the best learning experience.*