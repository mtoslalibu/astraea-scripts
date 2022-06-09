cd wrk2
./wrk -D exp -t 20 -c 20 -d 5 -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 1
#./wrk -D exp -t 30 -c 30 -d 5 -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 50
#./wrk -D exp -t 30 -c 30 -d 100 -L -s ./scripts/social-network/read-user-timeline.lua http://localhost:8080/wrk2-api/user-timeline/read -R 50
echo "Done"
