filename_out="/mydata/traces/synexperimentcpumemmedia"
mkdir -p $filename_out

> /local/astraea-spans/sleeps
echo "check sleeps now"
cat /local/astraea-spans/sleeps

iter=8
duration=300
qps=10

wget https://github.com/alexei-led/pumba/releases/download/0.9.0/pumba_linux_amd64
chmod +x pumba_linux_amd64

x=0
while [ $x -lt $iter ]
do

x=$(( $x + 1 ))
echo "----------------------------"
echo -e "\n\nIteration $x"
sleep 3

echo "Time now while injection $(date +%s)"

## run workload
cd /local/DeathStarBench/mediaMicroservices/wrk2
./wrk -D exp -t 5 -c 5 -d $duration -L -s ./scripts/media-microservices/compose-review.lua http://localhost:8080/wrk2-api/review/compose -R $qps > /tmp/heyyinjected &
workloadPID=$!

echo "Started workload in bg"

cd /local/astraea-scripts/media
svc=`sed "${x}q;d" services-to-inject`
echo -e "Service now: $svc"


injector=1
injector_lim=$(( $duration / 30))
echo -e "Injector times lim: $injector_lim"
while [ $injector -le $injector_lim ]
do

echo -e "Injecting nth: $injector"
./pumba_linux_amd64 stress --duration 30s --stressors="--bigheap 2" $svc
injector=$(( $injector + 1 ))
done

echo "Finished injecting"



wait $workloadPID
echo -e "\nTime now after injection $(date +%s)"

qpsnow=$((qps-1))
limit=$((duration*qpsnow))
cat /tmp/heyyinjected |  tail -6  | head -1

sleep 15
endtime=`date +%s`
endtime="${endtime}000000"
echo "limit after injection now $limit , endtime after injection now $endtime"

url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=compose-review-service"
echo "curling now to $svc_line with url $url"

filename="$svc-$endtime"
filename=${filename//\//___}
filename="$filename_out/$filename"
echo "filename now : $filename"
curl -sS "$url" > $filename
echo "saved traces to  $filename"

> /local/astraea-spans/sleeps

sleep 15;

echo "check line number afterwards should be empty"
cat /local/astraea-spans/sleeps

done
