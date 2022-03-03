red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

filename_out="/mydata/traces/synexperiment"
mkdir -p $filename_out

iter=10

entries=($(shuf -i 2-30 -n $iter))
echo "${entries[@]}"

x=0
while [ $x -le $iter ]
do

x=$(( $x + 1 ))
echo "----------------------------"
echo -e "\n\nIteration $x"

# echo "Time now before injection $(date +%s)"
cd ../../DeathStarBench/socialNetwork/wrk2

./wrk -D exp -t 20 -c 20 -d 30 -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 100 > /tmp/heyy

limit=`tail -n 6 /tmp/heyy | head -1 | awk '{print $7}'`
limit=${limit::-1}

cat /tmp/heyy |  tail -6  | head -1

echo "limit now $limit"

## get traces
sleep 1
endtime=`date +%s`
endtime="${endtime}000000"
echo "limit now $limit , endtime now $endtime"
url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=compose-post-service"
echo "url now $url"


filename=`shuf -n 2 /local/astraea-scripts/deathstar/all-spans | tee /local/astraea-spans/sleeps | xargs -n2 -d'\n'`

sleep 5

filename="$filename_out/$filename"
# echo "filename now : $filename"
curl -sS "$url" > $filename
echo "saved traces to  $filename"

echo "Time now while injection $(date +%s)"
# date +%s

## run workload 

./wrk -D exp -t 20 -c 20 -d 60 -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 100 > /tmp/heyyinjected &
workloadPID=$!


wait $workloadPID
echo -e "\nTime now after injection $(date +%s)"
# date +%s

limit=`tail -n 6 /tmp/heyy | head -1 | awk '{print $7}'`
limit=${limit::-1}

cat /tmp/heyy |  tail -6  | head -1


endtime=`date +%s`
endtime="${endtime}000000"
echo "limit after injection now $limit , endtime after injection now $endtime"
url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=compose-post-service"
echo "url now after injection $url"

sleep 5;
echo "curling now to $svc_line with url $url"

filename="$filename_out/$filename-injected"

echo "saved traces to  $filename"



 > /local/astraea-spans/sleeps



sleep 30; 

echo "check line number afterwards should be empty"
cat /local/astraea-spans/sleeps

done
