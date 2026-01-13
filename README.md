to do:

ec2 deployment

security group setup

file upload

nginx setup

nodejs setup

application deployed

-------------------

1. depoyment environment specifications

hardware requirements:
    - EC2 instance type: t3.micro (free tier)
    - vCPU: 2 cores
    - memory: 1GB

operating system:
    - ubuntu server 24.04 LTS
    - 64-bit architecture

network configuration:
    - VPC: default
    - security group rules
        - inbound rules: HTTP (80), SSH (22),custom TCP (3000)
        - outbound rules: Allow  all traffic (0.0.0.0/0)

required infrastructure:
    - AWS EC2 instance

2. installation & configuration

create key pair:
    - on AWS, under EC2 create your own key pair
![AWS key setup screen"](key_setup.png)
