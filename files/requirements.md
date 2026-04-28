
## Requirements before TiTaniA installation

Use your windows machine with, Virtual Box, VMware. Or  a machine with linux. Or Cloud Service as AWS, IBM Bluemix, Azure or Google. 

Recommended:


*configuration*: 1 vCPU, 1GB RAM and HDD or SSD.

*Install any Linux distribution, but Ubuntu Server 24.04 LTS, Docker and Docker Compose*.


Open ports on the firewall if you are using a Cloud Service:

```
   22/TCP - SSH 
 5000/TCP - Web Interface
 1026/TCP - Orion Contex Broker (HTTP or HTTPs)
27017/TCP - MongoDB "DataBase"
 3306/TCP - MYSQL "DataBase"
 3000/TCP - Grafana
 4041/TCP - AgentIoT-Json
 7896/TCP
 5050/TCP - Cygnus
 5080/TCP
   80/TCP - NGINX
```


### Installation Docker and Docker Compose
<a href="Tutorial_Instalacao_DOCKER_e_DOCKER_COMPOSE.md">Installation Docker and Docker Compose.<a>


### Quick installation

```
git clone https://github.com/Rosiberto/titania-community.git
cd titania-community
chmod u+r+x install.sh
./install.sh

Ready!
```