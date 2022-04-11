#!/bin/bash
docker-compose -f "docker-compose.yml" up --quiet-pull &
while [ "$( docker container inspect -f '{{.State.Status}}' mariadbprojet 2> /dev/null )" != "running" ]; do
    clear
    echo "attente du démarage du docker"
    sleep 1
done
echo "la base mariadbprojet dockerisée est UP"
python3 'APIcall.py' 2> /dev/null
exit 0