# ELB Target EC2 Test Instance

> **⚠️ DISCLAIMER: FOR TESTING PURPOSES ONLY**
> 
> This configuration is intended for **testing and development environments only** and is **NOT suitable for production use**. 
> 
> **Important considerations:**
> - Minimal security hardening
> - No monitoring or logging configuration
> - Simple HTTP server without SSL/TLS
> - No automated updates or patching
> - Not designed for high availability
> 
> For production deployments, implement proper security controls, monitoring, SSL/TLS, and follow AWS Well-Architected Framework guidelines.

This repository provides a simple test EC2 instance setup for testing AWS Elastic Load Balancer (ELB) configurations. It creates a basic Apache HTTP server that displays instance information and supports timeout testing.

## Features

- **Instance Information Display**: Shows EC2 instance metadata (instance ID, availability zone, private IP)
- **Health Check Endpoint**: Dedicated health check port (8080) for ELB health checks
- **Timeout Testing**: Configurable endpoint to test connection timeout scenarios
- **Multi-ELB Support**: Compatible with ALB, NLB, and CLB

## Quick Start

### Step 1: Launch EC2 Instance

Launch an Amazon Linux 2023 instance with the following User Data:

```bash
#!/bin/bash
sleep 30
sudo dnf -y upgrade --releasever=latest
sudo dnf -y update
sudo dnf -y install httpd
wget https://github.com/nakyuk/elb-target-ec2/archive/refs/heads/main.zip
unzip main.zip
cd elb-target-ec2-main/
sudo bash ready.sh
```

**Instance Requirements:**
- **AMI**: Amazon Linux 2023
- **Instance Type**: t3.micro or larger
- **Security Group**: Allow inbound traffic on ports 80 and 8080
- **IAM Role**: (Optional) Role with permissions to access EC2 metadata

### Step 2: Configure Load Balancer

Configure your ELB target group with the following settings:

#### Application Load Balancer (ALB)

**Target Group Settings:**
- **Traffic Port**: HTTP 80
- **Health Check Protocol**: HTTP
- **Health Check Port**: 8080
- **Health Check Path**: `/`

#### Network Load Balancer (NLB)

**Target Group Settings:**
- **Traffic Port**: TCP 80
- **Health Check Protocol**: TCP
- **Health Check Port**: 8080

#### Classic Load Balancer (CLB)

**Listener Configuration:**
- **Load Balancer Protocol**: HTTP
- **Load Balancer Port**: 80
- **Instance Protocol**: HTTP
- **Instance Port**: 80

**Health Check Configuration:**
- **Ping Protocol**: HTTP
- **Ping Port**: 8080
- **Ping Path**: `/`

### Step 3: Test the Setup

#### Basic Connectivity Test

```bash
# Check instance information
curl http://lb-xxxxxxxxxx.us-east-1.elb.amazonaws.com

# Expected output:
# Instance ID: i-0123456789abcdef0
# Availability Zone: us-east-1a
# Private IP: 10.0.1.100
```

#### Timeout Test

Test connection timeout behavior by specifying a delay in seconds:

```bash
# Test with 5 second delay
curl http://lb-xxxxxxxxxx.us-east-1.elb.amazonaws.com/timeout/5/

# Test with 30 second delay
curl http://lb-xxxxxxxxxx.us-east-1.elb.amazonaws.com/timeout/30/
```

The timeout endpoint will hold the connection for the specified duration, useful for testing:
- Load balancer timeout settings
- Connection draining behavior
- Client timeout configurations

## Configuration Details

### Apache Configuration

The setup includes a custom Apache configuration (`httpd.conf`) that:
- Listens on port 80 for main traffic
- Listens on port 8080 for health checks
- Enables CGI for timeout testing
- Configures appropriate permissions

### Directory Structure

```
elb-target-ec2/
├── html/
│   └── index.html          # Main page displaying instance info
├── cgi-bin/
│   └── timeout/
│       └── timeout.cgi     # CGI script for timeout testing
├── httpd.conf              # Apache configuration
├── ready.sh                # Setup script
└── README.md
```
