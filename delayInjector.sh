## example usage: ./docker-stats.sh ts-travel-service nosampledstats-fixed
echo "warming up the containers"
./hey_linux_amd64 -z 60s -c 5 -q 5 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' http://localhost:8080/api/v1/travelservice/trips/left
echo "warming done"

while true; 
echo "Iteration"

echo "Time now before injection"
date +%s
./hey_linux_amd64 -z 30s -c 5 -q 5 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' http://localhost:8080/api/v1/travelservice/trips/left


# inject delay
## randomly generate number
randomNumber=$(($1 + $RANDOM % $30))

sed -i "${randomNumber} s/./inject-&/" astraea-spans
sleep 10

echo "check line number"
cat astraea-spans | grep 'inject'

echo "Time now while injection"
date +%s

## run workload 
./hey_linux_amd64 -z 30s -c 5 -q 5 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' http://localhost:8080/api/v1/travelservice/trips/left
# workloadPID=$!

echo "Time now after injection"
date +%s


## check if container has sleeped
# sleep 15;
# sudo docker logs 
# sleep 90;
# kill workloadPID


## remove injected delay
sed -i 's/inject-//' astraea-spans

# do docker stats --no-stream train-ticket_${1}_1 | tail -1 >> ${2}.txt; 
sleep 10; 

echo "check line number afterwards"
cat astraea-spans | grep 'inject'

done


# docker stats --no-stream --format \
#     "{\"container\":\"{{ .Container }}\",\"memory\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}, \"net\":\"{{ .NetIO }}\"},  \"block\":\"{{ .BlockIO }}\"}"



