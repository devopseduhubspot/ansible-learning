#!/bin/bash
# Lab 10 Prerequisites Setup Script

echo "=== Ansible Lab 10 - Prerequisites Setup ==="
echo

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first:"
    echo "   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
else
    echo "✅ AWS CLI is installed"
fi

# Check AWS configuration
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured. Please run:"
    echo "   aws configure"
    exit 1
else
    echo "✅ AWS credentials are configured"
    aws sts get-caller-identity --query 'Account' --output text | sed 's/^/   Account: /'
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed"
    exit 1
else
    echo "✅ Python3 is installed"
fi

# Install required Python packages
echo "📦 Installing required Python packages..."
pip3 install boto3 botocore --quiet

if [ $? -eq 0 ]; then
    echo "✅ Python packages installed successfully"
else
    echo "❌ Failed to install Python packages"
    exit 1
fi

# Install Ansible AWS collection
echo "📦 Installing Ansible AWS collection..."
ansible-galaxy collection install amazon.aws --force > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Ansible AWS collection installed successfully"
else
    echo "❌ Failed to install Ansible AWS collection"
    exit 1
fi

# Check for SSH key
read -p "🔑 Enter your EC2 key pair name (without .pem extension): " key_name
if [ -z "$key_name" ]; then
    echo "❌ Key pair name cannot be empty"
    exit 1
fi

# Update the variables file with the key name
if [ -f "group_vars/all.yml" ]; then
    sed -i "s/key_name: ansible-lab-key/key_name: $key_name/" group_vars/all.yml
    echo "✅ Updated key_name in group_vars/all.yml"
else
    echo "⚠️  group_vars/all.yml not found. Please update key_name manually."
fi

echo
echo "🎉 Prerequisites setup complete!"
echo
echo "📋 Next steps:"
echo "   1. Review and update group_vars/all.yml if needed"
echo "   2. Ensure your EC2 key pair exists in AWS"
echo "   3. Run: ansible-playbook solutions/lab10.yml"
echo "   4. When done, cleanup with: ansible-playbook solutions/lab10.yml --tags cleanup"