#IMAGE_NAME=guestbook_php-fpm
#CONTAINER_NAME=guestbook_php-fpm_1

#build:
#	docker build -t $(IMAGE_NAME) .

# check this install?
install:
	docker-compose up --build -d
	docker-compose exec php-fpm composer update
	docker-compose exec php-fpm composer install
	docker-compose exec php-fpm symfony server:start -d

start:
	#docker run -p 8000:8000 --name $(CONTAINER_NAME) -d $(IMAGE_NAME)
	docker-compose up -d
	docker-compose exec php-fpm composer update
	docker-compose exec php-fpm composer install
	docker-compose exec php-fpm symfony server:start -d

stop:
	#docker stop $(CONTAINER_NAME)
	docker-compose stop

remove:
	#docker rm $(CONTAINER_NAME)
	docker-compose down

restart: stop start

clean: stop remove

shell:
	#docker exec -it $(CONTAINER_NAME) /bin/bash
	@docker-compose exec php-fpm bash
