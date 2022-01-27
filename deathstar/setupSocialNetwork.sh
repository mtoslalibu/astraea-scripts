## install social network and boot
cd /local
git clone https://github.com/mtoslalibu/DeathStarBench.git
cd DeathStarBench/socialNetwork
#sudo docker-compose up -d
## build your own version
#sudo docker build -t yg397/social-network-microservices:latest .

#sudo python3 scripts/init_social_graph.py --graph=socfb-Reed98

## start workload
cd wrk2
make
cd ..
