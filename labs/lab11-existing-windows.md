# Lab 11: Connect to Existing Windows Host

## Objective:
Connect to an existing Windows machine on AWS and perform various administrative tasks to demonstrate Ansible Windows management capabilities.

## Prerequisites:
- Existing Windows Server running on AWS
- Python packages: `pip install pywinrm`
- Windows machine configured for WinRM (if not already done)

## Step 1: Configure Windows Host for WinRM (if needed)

If your Windows machine isn't configured for WinRM, RDP to it and run these PowerShell commands as Administrator:

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
```

## Step 2: Update Inventory File

Add your Windows host to `inventory/hosts`:

```ini
[web]
3.109.201.228 ansible_user=ec2-user ansible_ssh_private_key_file=~/ansible-key-ec2.pem

[windows]
YOUR_WINDOWS_IP ansible_host=YOUR_WINDOWS_IP ansible_user=Administrator ansible_password=YOUR_PASSWORD ansible_connection=winrm ansible_winrm_transport=basic ansible_winrm_server_cert_validation=ignore ansible_winrm_port=5985
```

Replace:
- `YOUR_WINDOWS_IP` with your Windows server's public IP
- `YOUR_PASSWORD` with your Administrator password

## Step 3: Test Connection

Create a simple connectivity test:

```bash
ansible windows -m win_ping
```

## Tasks to Accomplish:

### 1. System Information
- Gather Windows system information
- Display OS version and hardware details

### 2. Software Installation
- Install Chocolatey package manager
- Install useful software packages
- Verify installations

### 3. File Operations  
- Create directories
- Copy files
- Set file permissions

### 4. Service Management
- Check Windows services
- Start/stop services
- Configure service startup types

### 5. Windows Features
- Enable/disable Windows features
- Install IIS web server
- Configure basic website

### 6. PowerShell Execution
- Run PowerShell scripts
- Execute system commands
- Get system reports

## Expected Output:
```
TASK [Test Windows connectivity]
ok: [YOUR_WINDOWS_IP]

TASK [Display system information]
ok: [YOUR_WINDOWS_IP] => {
    "msg": "Windows Server 2022 - Build 20348"
}
```

## Security Notes:
- This lab uses basic authentication for simplicity
- In production, use HTTPS and certificate-based authentication
- Consider using Ansible Vault for storing passwords

## Run the Playbook:
```bash
ansible-playbook lab11.yml
```