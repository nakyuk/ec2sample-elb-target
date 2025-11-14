# Test EC2 for ELB target 

## Usage

1. Run Amazon Linux 2023 instace with following User Data;
```
#!/bin/bash
sudo dnf -y upgrade --releasever=latest
sudo dnf -y update
sudo dnf -y install httpd
wget https://github.com/nakyuk/elb-target-ec2/archive/refs/heads/main.zip
unzip elb-target-ec2-main.zip
cd elb-target-ec2-main/
sudo bash ready.sh
```

2. Ready target or target group for ELB
 -  ALB
    - Traffic port: HTTP 80
    - Healthcheck: HTTP 8080 /
 -  NLB
    - Traffic port: TCP 80
    - Healthcheck: TCP 8080
 -  CLB
    - Traffic port: HTTP 80
    - Healthcheck: HTTP 8080 /

3. Access ELB
```
# Check target information
curl lb-xxxxxxxxxx.us-east-1.elb.amazonaws.com

# Continue processing until the specified time
# eq. 5 sec is bellow;
curl lb-xxxxxxxxxx.us-east-1.elb.amazonaws.comtimeout/5/
```
