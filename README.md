# Sixphere Lumen API Suite + ELK + MySQL with Docker

Easy as Build and Run Docker composition for [Lumen API Suite from Sixphere](https://github.com/6phere/lumen-api-suite)

![Docker](assets/img/overview.png?raw=true)

## Requirements & Dependencies

* [Docker](https://www.docker.com)
* [Sixphere Lumen Archetype](https://github.com/6phere/lumen-api-suite)
* [ELK Docker](https://hub.docker.com/r/sebp/elk/)
* [MySQL](https://hub.docker.com/_/mysql/)

## Installation

Download this repository and copy and rename .env.example as .env
```
cp .env.example .env
```

## Run

To run composition:
```
docker-compose up -d
```

## Proxy

We have include a proxy to resolve domain

### Proxy Configuration
To use hosts in machine configure .env files properties APP_ENV, APP_DOMAIN, APP_DOCKER_IP

You can configure manually adding:
```
localapi.docker-sixphere.com 127.0.0.1
localelk.docker-sixphere.com 127.0.0.1
```

Or using next script

#### Windows hosts configure

Execute script
```
./set_hosts.bat
```

## Volumes

A data folder will be created in the host:

* **app** This folder contains the application.
* **mysql** This folder contains MySQL data storage

If you are using Docker Toolbox you should enable the volume /var/www/html/app in the docker container

## Arquitecture

We have a Lumen Application connect to MySQL and ELK

* [Sixphere Lumen Archetype](https://github.com/6phere/lumen-api-suite)
* [ELK Docker](https://hub.docker.com/r/sebp/elk/)
* [MySQL](https://hub.docker.com/_/mysql/)

![Arquitecture](assets/img/arquitecture.png?raw=true)

## Troubleshoting

### I have broken my installation, how can I start again?

* You must remove the containers
* You must delete the content inside data folder that has been created (if exists)

### ERROR: Cannot create container for service nginx-proxy .... is not a valid Windows path

You must execute in Powershell this:

```
$Env:COMPOSE_CONVERT_WINDOWS_PATHS=1
```

# Licence

Licenced under GNU GENERAL PUBLIC LICENSE [...]

# Author

[Sixphere](http://www.sixphere.com "Sixphere") is not only a group of experienced professionals, that keep a huge amount of knowledge, take care about what and how they do their job. They solve their partner problems in an agile way and are aware of their customer needs through emotional intelligence connections.

Sixphere is a simpler way of understanding IT services, based on a strong and well balanced mix-ture of principles.
Searching for strong professional relationships, supplying strong technical skills and offering a deep knowledge; in a collaborative, adaptative and agile way to reach its goal: helping to carry out its customer’s objectives, or better said its partners. Would you like us to be partners? Let us sail together on your trip.

[Sixphere Technologies](http://www.sixphere.com "Sixphere Technologies") 2018

## Contact

Want to comment or share something, contact us codelovers@sixphere.com
