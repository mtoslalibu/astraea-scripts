cd /local/DeathStarBench/mediaMicroservices/docker/thrift-microservice-deps/cpp
sudo docker build -t mert/thrift-microservice-deps:xenial .

cd /local/DeathStarBench/mediaMicroservices
sudo docker build -t mert/media-microservices:latest .

sudo docker-compose up -d
pip3 install aiohttp
python3 scripts/write_movie_info.py -c datasets/tmdb/casts.json -m datasets/tmdb/movies.json && scripts/register_users.sh && scripts/register_movies.sh


cd /wrk2
sudo make
./wrk -D exp -t 3 -c 3 -d 3 -L -s ./scripts/media-microservices/compose-review.lua http://localhost:8080/wrk2-api/review/compose -R 10

