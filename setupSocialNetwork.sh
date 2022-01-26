##Deathstarbench scripts:
##ssh -p 22 toslali@amd133.utah.cloudlab.us -Y -L 16686:localhost:16686

## set up docker
sudo apt update
sudo apt --yes install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt --yes install docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose –version

## isntall requirements
sudo apt-get --yes install luarocks
sudo luarocks install luasocket
sudo apt --yes install python3.8
sudo apt-get --yes install libssl-dev
sudo apt-get --yes install libz-dev
sudo apt-get --yes install python3-pip
pip3 install aiohttp

## install social network and boot
cd /local
git clone https://github.com/mtoslalibu/DeathStarBench.git
cd DeathStarBench/socialNetwork
#sudo docker-compose up -d
## build your own version
sudo docker build -t yg397/social-network-microservices:latest .

#sudo python3 scripts/init_social_graph.py --graph=socfb-Reed98

## start workload
cd wrk2
make
#./wrk -D exp -t 20 -c 20 -d 200 -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 20



