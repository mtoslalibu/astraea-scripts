## example usage: ./docker-stats.sh ts-travel-service nosampledstats-fixed

while true; do docker stats --no-stream train-ticket_${1}_1 | tail -1 >> ${2}.txt; sleep 5; done


# docker stats --no-stream --format \
#     "{\"container\":\"{{ .Container }}\",\"memory\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}, \"net\":\"{{ .NetIO }}\"},  \"block\":\"{{ .BlockIO }}\"}"

