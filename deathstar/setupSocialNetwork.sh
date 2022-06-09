## install social network and boot
cd /local
git clone https://github.com/mtoslalibu/DeathStarBench.git
cd DeathStarBench/socialNetwork

## build your own version
cd /local/DeathStarBench/socialNetwork/docker/thrift-microservice-deps/cpp
sudo docker build -t mert/thrift-microservice-deps:xenial .
cd /local/DeathStarBench/socialNetwork
sudo docker build -t mert/social-network-microservices:latest .

## boot them
sudo docker-compose up -d

## populate data
# pip3 install aiohttp
#sudo python3 scripts/init_social_graph.py --graph=socfb-Reed98

## build workload
cd wrk2
make
cd ..

#sudo docker build -t yg397/social-network-microservices:latest .
