# springboot-api


Deploying multiple spring boot containers and Load balancing in a single ec2-instance

Make a Custom Network Bridge
Making a custom network bridge helps you to communicate with all the containers using just the container name. 

docker network create lb-net

Creating the containers

After creating the custom network bridge, we need to make 3 different containers with the same Docker Image.

# for build docker image
docker build -t springboot-demo .

#Container 1: Port 5001
docker run -d -p 5001:5000 -e FLASKPORT=5000 springboot-demo

# Container 2: Port 5002
docker run -d -p 5002:5000 -e FLASKPORT=5000 springboot-demo

# Container 3: Port 5003
docker run -d -p 5003:5000 -e FLASKPORT=5000 springboot-demo







Configure Load Balancer

	We need to deploy the ALB for our instance. Before deploying the AWS ALB we need to provision the target group first. Create the target group as below

Create Target group
Choose the target group as Instances
Chose the target group name as lb-tg you can choose any name you wish
Set HTTP as 80 [we can set the redirection rule later]
Set VPC where your instance is placed, mine is default so I'm not changing it
The protocol version as HTTP1
Keep all values default and just click *Next
After clicking Next here comes the tricky part, First tick the instance and then Ports for the selected instances enter the ports that we port published
Change the default port 80 to 5001 and click Include as pending below. Screenshot is attached for reference



Once that's done repeat steps 8 and 9 until 5002 and 5003 are added as the targets. The result will be like this




Click Create Target group next

Then Create the ALB and attach it to the target group

Create Load balancer
Choose Application Load Balancer and click on Create
Choose whatever name you like to name your ALB
Set Scheme as Internet-facing
IP address type as IPv4
Set VPC as the default/Custom-created
Mappings select 2 public subnet at least in whichever region you are
Set Security group to allow ALB to have 80 and 443
Listener as HTTP:443 with the target group name as the name you set for the target name as lb-tg
Default SSL/TLS certificate load the certificate from ACM you can follow the doc Requesting a public certificate 
Click on create load balancer


Force HTTP to HTTPS redirect
Go to load balancer
Click on your alb
Choose the listener and then click the listeners option. Select Edit Listeners option



4.  In the Default actions change the Routing action to Redirect to URL
5. Choose protocol HTTPS with port 443 and status code as 301 permanently moved
6. Click Save Changes.





Point domain to ALB endpoint


Verification of single instance multiple container setup
Here you can see the final output where the domain https://springboot.cloudplus.net.in/ is loadbalancing by displaying the hostnames of the containers





