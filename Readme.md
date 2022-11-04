# Installation

## Infrastructure requirements

1. Docker
2. DOcker Compose
3. Server with public IP to expose the services

## Software requirements (All deployed from containers)

1. Rabbitmq
2. Mariadb
3. Redis

### Docker compose file for deployment

- docker-compose.yml

### Integration scripts repository

- <https://github.com/Zohari-Tech/wrapperscripts>

### Rabbitmq Management console

- <http://localhost:15672/#/>

### Database management console

- <http://localhost:8082/?server=mariadb&username=payuser&db=coredb&select=Transactions>
