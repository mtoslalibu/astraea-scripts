## install jdk and maven
sudo apt update
sudo apt-get --yes install openjdk-8-jdk
sudo apt --yes install maven

## install docker and docker-compose
sudo apt --yes install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt --yes install docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version

## fork repo of java client
git clone https://github.com/mtoslalibu/jaeger-client-java.git    
##git checkout tags/v0.30.6
##git checkout -b v0.30.6-astraea
## ext.developmentVersion = getProperty('developmentVersion','0.30.6')
## add -SNAPSHOT
git checkout --track origin/v0.30.6-astraea
git submodule init
git submodule update
sudo ./gradlew clean install


## servlet mert’s version
git clone https://github.com/mtoslalibu/java-web-servlet-filter.git
git checkout --track origin/v0.1.1-astraea
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true


## java spring web mert’s version
git clone https://github.com/mtoslalibu/java-spring-web.git
git checkout --track origin/v-0.3.4-astraea
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true


## git clone fork repo of java spring jaeger
git clone https://github.com/mtoslalibu/java-spring-jaeger.git
##git checkout tags/release-0.2.2 ## (change client java version to SNAPSHOT)
git checkout --track origin/v0.2.2-astraea
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true



## go trainticket + switch to jaeger branch + then change java-jaeger-spring version to snapshot
##git checkout jaeger
git clone https://github.com/FudanSELab/train-ticket.git
git checkout --track origin/jaeger
## change version under ts-common to snapshot
sudo mvn clean package -Dmaven.test.skip=true
sudo docker-compose build
sudo docker-compose up



ssh -p 22 toslali@amd133.utah.cloudlab.us -Y -L 16686:localhost:16686

1.	Create external fs mydata (from cloudlab)
a.	sudo /usr/local/etc/emulab/mkextrafs.pl /mydata
b.	sudo chmod /mydata
c.	then follow the steps in the link below

2.	https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux

exact steps for mounting disk:
sudo mkdir /mydata
sudo /usr/local/etc/emulab/mkextrafs.pl /mydata
sudo chmod ugo+rwx /mydata
sudo systemctl stop docker.service
sudo systemctl stop docker.socket
sudo vi /lib/systemd/system/docker.service
## ExecStart=/usr/bin/dockerd -g /mydata -H fd:// --containerd=/run/containerd/containerd.sock
sudo rsync -aqxP /var/lib/docker/ /mydata
sudo systemctl daemon-reload
sudo systemctl start docker
ps aux | grep -i docker | grep -v grep




sudo docker ps -q | xargs -r sudo docker kill

sudo docker system prune --all --force –volumes

curl --header "Content-Type: application/json" --request POST --data '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' -s http://localhost:8080/api/v1/travelservice/trips/left

sudo docker ps | grep ts-travel-service

sudo docker logs 

sudo docker-compose logs --tail=0 –follow ## see all logs



git password: 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

git remote show origin

sudo docker-compose up --force-recreate

git clone https://github.com/mtoslalibu/java-spring-web.git
git checkout tags/release-0.3.4
vi opentracing-spring-web/src/main/java/io/opentracing/contrib/spring/web/client/TracingRestTemplateInterceptor.java
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true

ν	then change java spring jaeger/web-starter pom xml to snapshot version of spring-web

System.out.println("Client http req" + httpRequest.getURI().toString() + httpRequest.getMethod());

Build order
1.	java-servlet-filter
2.	java-spring-web || jaeger-client-java
3.	java-spring-jaeger
4.	train-ticket




## aradaki adim –operation nam eicin 
java-spring-jaeger/opentracing-spring-jaeger-web-starter/pom.xml burda 
<opentracing-spring-web-starter.version>0.3.4-SNAPSHOT</opentracing-spring-web-starter.version>  snapshot yapki prehandle da operation name I alabalilelim

