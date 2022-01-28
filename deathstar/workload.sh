cd wrk2
./wrk -D exp -t 20 -c 20 -d 5 -L -s ./scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 1
echo "Done"
