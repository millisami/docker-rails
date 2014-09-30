== README

This rails app is configured to run with the Docker orchestration.

## Setp 1 (Postgresql db setup)

    docker run -d -v /dbdata --name 1dbdata millisami/postgresql echo Data-only container
    docker run -d -P --volumes-from dbdata --name db1 millisami/postgresql

  Create the database for the app

    docker run -it --rm --link db1:pg millisami/postgresql /bin/sh

  Inside the container,  

    createdb -O docker -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -U docker docker-rails_development
    createdb -O docker -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -U docker docker-rails_test
    createdb -O docker -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -U docker docker-rails_production

## Step 2 (Fluentd setup)

    docker run -d -P --name fluentd millisami/fluentd

## Step 3 (Build the image and fire the app)

    docker build -t millisami/docker-rails .

  #### Run in frontend process mode
    docker run -it -P -v $(pwd):/app -p 3000:3000 --link db1:pg --link fluentd:fluentd --name docker-rails --volumes-from db1 millisami/docker-rails /bin/bash

  ### Run in background process mode
    docker run -d -P -v $(pwd):/app --link db1:pg --link fluentd:fluentd --name docker-rails --volumes-from db1 millisami/docker-rails
