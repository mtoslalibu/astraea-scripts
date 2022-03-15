filename_out="/mydata/traces/synexperimentcpumemmatrix"
mkdir -p $filename_out

iter=6
duration=300

x=1
while [ $x -lt $iter ]
do
x=$(( $x + 1 ))
echo "----------------------------"
echo -e "\n\nIteration $x"

cd /local/DeathStarBench/socialNetwork/wrk2
./wrk -D exp -t 3 -c 3 -d $duration -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 10 &> /tmp/out &
echo "Started workload in bg"


cd /local/astraea-scripts/deathstar
svc=`sed "${x}q;d" services-to-inject`
echo -e "Service now: $svc"

cd /local

injector=1
injector_lim=$(( $duration / 30))
echo -e "Injector times lim: $injector_lim"
while [ $injector -le $injector_lim ]
do

echo -e "Injecting nth: $injector"
sudo ./pumba_linux_amd64 stress --duration 30s --stressors="--matrix 1 -t 30s" $svc
injector=$(( $injector + 1 ))
done

echo "Finished injecting"

## when finished collect traces

sleep 10
endtime=`date +%s`
endtime="${endtime}000000"

limit=$(( 9*duration ))
echo "+++limit now $limit , endtime now $endtime"
url="http://localhost:16686/api/traces?end=$endtime&limit=$limit&maxDuration&minDuration&prettyPrint=true&raw=true&service=compose-post-service"
echo "url now $url"

filename="$svc-$endtime"
filename=${filename//\//___}
filename="$filename_out/$filename"
echo "filename now : $filename"
curl -sS "$url" > $filename
echo "saved traces to  $filename"

sleep 2
done
