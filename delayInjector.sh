red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

## example usage: ./docker-stats.sh ts-travel-service nosampledstats-fixed
echo "warming up the containers"
# ./hey_linux_amd64 -z 20s -c 5 -q 5 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' http://localhost:8080/api/v1/travelservice/trips/left
echo "warming done"

# mkdir -p synexperiment/

x=0
while [ $x -le 3 ]
do

x=$(( $x + 1 ))
echo "----------------------------"
echo -e "\n\nIteration $x"

# echo "Time now before injection $(date +%s)"

./hey_linux_amd64 -z 5s -c 5 -q 5 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' http://localhost:8080/api/v1/travelservice/trips/left > /tmp/heyy

limit=`tail -n 4 /tmp/heyy | head -1 | awk '{print $2}'`
# echo "limit now $limit"
## get traces
sleep 1
endtime=`date +%s`
endtime="${endtime}000000"
echo "limit now $limit , endtime now $endtime"
url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=ts-travel-service"
echo "url now $url"

# inject delay
## randomly generate number
randomNumber=$((1 + $RANDOM % 30))
# randomNumber=1
if [[ "$randomNumber" -eq 5 ]]; then
randomNumber=6 
echo "queryinfo should not be there" 
fi

echo "Line number now $randomNumber"

## remove 1
sed -i "${randomNumber} s/1//" /local/astraea-spans/states
sed -i "${randomNumber} s/./inject-&/" /local/astraea-spans/states
sleep 6

# echo "check line number"
# cat /local/astraea-spans/states | grep 'inject'
## get line to var e.g., inject-ts-order-service:calculateSoldTicket
svc_line=$(cat /local/astraea-spans/states | grep 'inject')
# echo "svcline $svc_line"
echo "curling now to $svc_line  with url $url"

filename="$svc_line-$endtime"
filename=${filename//\//___}
filename="synexperiment/$filename"
# echo "filename now : $filename"
curl -sS "$url" > $filename
echo "saved traces to  $filename"

## get before ':''
var=${svc_line%%:*}
## get after 'inject-'
svc=${var#*inject-}

echo "Service now $svc"

echo "Time now while injection $(date +%s)"
# date +%s

## run workload 
./hey_linux_amd64 -z 10s -c 5 -q 5 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' http://localhost:8080/api/v1/travelservice/trips/left > /tmp/heyyinjected &
workloadPID=$!


## check if container has sleeped
sleep 6;

sudo docker ps | grep $svc | awk '{print $1}' | xargs sudo docker logs --tail 100 > /tmp/temper
# if [[sleepFound]];
if grep -q Sleep /tmp/temper;
then
    echo "${green}Sleep found good${reset}"
else
    echo "${red}Problem${reset}"
fi


wait $workloadPID
echo -e "\nTime now after injection $(date +%s)"
# date +%s

limit=`tail -n 4 /tmp/heyyinjected | head -1 | awk '{print $2}'`
# echo "limit after injection now $limit"
## save traces again
endtime=`date +%s`
endtime="${endtime}000000"
echo "limit after injection now $limit , endtime after injection now $endtime"
url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=ts-travel-service"
echo "url now after injection $url"

sleep 5;
echo "curling now to $svc_line with url $url"
filename="$svc_line-$endtime"
filename=${filename//\//___}
filename="synexperiment/$filename-injected"
# echo "filename now : $filename"
# filename="synexperiment/$svc_line-$endtime-injected"
curl -sS "$url" > $filename
echo "saved traces to  $filename"


## remove injected delay
# sed -i 's/inject-//' /local/astraea-spans/states
# ## append 1 back
# sed -i "${randomNumber} s/./1&/" /local/astraea-spans/states
cat /local/astraea-span-allenabled > /local/astraea-spans/states


# do docker stats --no-stream train-ticket_${1}_1 | tail -1 >> ${2}.txt; 
sleep 10; 

echo "check line number afterwards should be empty"
cat /local/astraea-spans/states | grep 'inject'

done


# docker stats --no-stream --format \
#     "{\"container\":\"{{ .Container }}\",\"memory\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}, \"net\":\"{{ .NetIO }}\"},  \"block\":\"{{ .BlockIO }}\"}"


