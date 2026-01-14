#### this setup is done in a Ubuntu OS, for Windows use GitBash

# EC2 Instance setup & Basic App hosting

## Depoyment Environment Specifications
1. hardware requirements:
    - EC2 instance type: t3.micro (free tier)
    - vCPU: 2 cores
    - memory: 1GB

2. operating system:
    - ubuntu server 24.04 LTS
    - 64-bit architecture

3. network configuration:
    - VPC: default
    - security group rules
        - inbound rules: HTTP (80), SSH (22),custom TCP (3000)
        - outbound rules: Allow  all traffic (0.0.0.0/0)

    - required infrastructure:
        - AWS EC2 instance

## Installation & Configuration
1. create key pair:
    - on AWS, under EC2 create your own key pair
    - !["AWS key setup screen"](/images/key_setup.png)

2. security group:
    - create your custom security group on EC2 with specifications defined in network config in section 1
    - !["security group creation screen with correct values](/images/sg_setup.png)

3. instance setup:
    - in the EC2 section, create your instance using the specifications in section 1
    - !["instance create screen"](/images/instance_setup.png)
    - for security group and key pair, use your previously created items

## SSH connection & setup
1. download and move your key pair to your ssh folder (~/.ssh)
2. in terminal connect to instance:
    ```
    ssh -i ~/.ssh/your_key.pem ec2-user@your_instance_public_ip
    ```
3. once connected, update system:
    ```
    sudo apt update && sudo apt upgrade -y
    ```
4. intalling Node.js
    - run the command:
        ```    
        # add node repo for node.js 20
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

        # install node.js
        sudo apt install -y nodejs

        # verify installation
        node -v

        # intalling nginx:
        sudo apt install nginx
        ```
## Application Deployment Prep
1. create application directory using:
    ```
    mkdir -p /home/ubuntu/app
    ```
2. copy over the test app .zip from **local** machine to EC2 instance:
    ```
    scp -i ~/.ssh/your_key.pem path/to/file.zip ubuntu@intance_public_ip:/home/ubuntu
    ```
3.  back on the **instance**, unzip the file and move it:
    ```
    sudo apt install unzip
    unzip file.zip
    cp -r file/app/* /home/ubuntu/app
    ``` 
4.  from here using **ls** in terminal, you can check if all files have been correctly copied
    - !["Checking files in app directory"](/images/app_check.png)
    
## Dependencies & Process Management
1. install node.js dependencies:
    ```
    npm install
    ```   
2. globally install PM2:
    ```
    sudo npm install -g pm2
    ```
3. starting the application with PM2:
    ```
    pm2 start app.js --name sparta-test-app
    ```
!["screenshot of successful deployment in termianl"](/images/deployed.png)
    
## Nginx Config for Reverse Proxy
1. remove default site:
        ```
        sudo rm /etc/nginx/sites-enabled/default
        ```   
2. create new config:
    ```
    sudo nano/etc/nginx/sites-available/sparta-test-app
    # in the nano edit:
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }
    ```
3. enable the site:
    ```
    sudo ln -s /etc/nginx/sites-available/sparta-test-app /etc/nginx/sites-enabled/
        # if file already exists, continue with restarting
    ```

4. restart nginx and test configuration:
    ```
    sudo nginx -t
    sudo systemctl restart nginx
    ```

## When Deployed
- connect to the app via browser using http://public ip
- the result should resemble the below image:
!["sparta app"](/images/sparta.png)
