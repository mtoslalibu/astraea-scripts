# script for running hey workload to measure overhead!
sleep 300
echo "Now running the workload"
./docker-stats.sh ts-travel-service nosampledstats-fixed &
serverPID=$!
echo "Sending requests"
hey -z 300s -c 3 -q 3 -m POST -H "Content-Type: application/json" -d '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' -o "csv" http://localhost:8080/api/v1/travelservice/trips/left >> nosampledwstats-fixed.csv
echo "Killing stats collector"
kill $serverPID
echo "Workload is done - check the csv"
