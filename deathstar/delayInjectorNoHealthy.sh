filename_out="/mydata/traces/synexperimentdelaylong"
mkdir -p $filename_out

> /local/astraea-spans/sleeps
echo "check sleeps now"
cat /local/astraea-spans/sleeps

iter=10
duration=300
qps=50

entries=($(shuf -i 2-30 -n $iter))
echo "${entries[@]}"

x=0
while [ $x -lt $iter ]
do

x=$(( $x + 1 ))
echo "----------------------------"
echo -e "\n\nIteration $x"
sleep 3

filename=`shuf -n 1 /local/astraea-scripts/deathstar/all-spans | tee /local/astraea-spans/sleeps | xargs -n2 -d'\n' | sed -e 's/ /___/g'`
filename="$filename_out/$filename"

echo "Time now while injection $(date +%s)"

## run workload
cd /local/DeathStarBench/socialNetwork/wrk2
./wrk -D exp -t 5 -c 5 -d $duration -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R $qps > /tmp/heyyinjected &
workloadPID=$!

wait $workloadPID
echo -e "\nTime now after injection $(date +%s)"

qpsnow=$((qps-1))
limit=$((duration*qpsnow))
cat /tmp/heyyinjected |  tail -6  | head -1

sleep 15
endtime=`date +%s`
endtime="${endtime}000000"
echo "limit after injection now $limit , endtime after injection now $endtime"

url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=compose-post-service"
echo "curling now to $svc_line with url $url"

filename="$filename-injected"
curl -sS "$url" > $filename
echo "saved traces to  $filename"

> /local/astraea-spans/sleeps

sleep 15;

echo "check line number afterwards should be empty"
cat /local/astraea-spans/sleeps

done
