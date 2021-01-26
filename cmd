DOCKER_BUILDKIT=1 docker build --rm -t icm:2.2 .


docker stack deploy icm --compose-file docker-compose.yml --prune
