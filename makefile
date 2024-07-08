####################################################
### Local build config
####################################################

# Run site using Docker.
run:
	docker-compose up -d
	chmod +x bin/upload.sh
	./bin/upload.sh

runprod:
	docker-compose -f docker-compose-prod.yml --env-file /usr/local/bin/.env up -d

# Shutdown site using Docker
down:
	docker-compose down --remove-orphans
	docker volume rm ox-build_wordpress_data

# Build all images on local machine
# and remove any previous WP installations.
# Without this docker build doesn't
# overwrite already exiting folder and therefore
# doesn't update when bumping WP version for example.
build:
	chmod +x bin/build.sh && \
	./bin/build.sh

buildprod:
	chmod +x bin/build-prod.sh && \
	./bin/build-prod.sh

# Shell into the wordpress container
shell:
	docker exec -it wordpress bash

# Remove all dangling <none> images
none:
	docker rmi $(docker images -f "dangling=true" -q)

backup:
	chmod +x bin/backup_script.sh
	./bin/backup_script.sh
	aws s3 cp *.sql s3://totoro-db-backup/ --profile totoros3backup

import:
	chmod +x bin/import_script.sh
	./bin/import_script.sh
