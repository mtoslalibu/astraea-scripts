#!/bin/bash
#!/bin/bash
for (( c=1; c<=100; c++ ))
do
   echo "Welcome $c times"
   curl --header "Content-Type: application/json" --request POST --data '{"startingPlace": "Shang Hai", "endPlace": "Su Zhou"}' -s http://localhost:8080/api/v1/travelservice/trips/left
done
