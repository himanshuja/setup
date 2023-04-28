version: '3'
services:
  nginx-proxy-manager:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
      # Add any other Stream port you want to expose
      # - '21:21' # FTP

    # Uncomment the next line if you uncomment anything in the section
    # environment:
      # Uncomment this if you want to change the location of
      # the SQLite DB file within the container
      # DB_SQLITE_FILE: "/data/database.sqlite"

      # Uncomment this if IPv6 is not enabled on your host
      # DISABLE_IPV6: 'true'

    volumes:
      - proxymgr_data:/data
      - proxymgr_letsencrypt:/etc/letsencrypt

## nginx proxy manager deployed
## Starting Mysql deployment
  db:
    image: mysql:latest
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD= 8Deudue83e
      - MYSQL_DATABASE= npm
      - MYSQL_USER= npm
      - MYSQL_PASSWORD= npm
    volumes:
      - sql_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin:latest
    environment:
     - PMA_HOST= db
     - MYSQL_ROOT_PASSWORD= root
    # ports:
    #   - '8081:80'
    depends_on:
      - db
  n8n:
    image: n8nio/n8n
    restart: unless-stopped
    environment:
      - DB_TYPE= mysqldb
      - DB_MYSQLDB_HOST= db
      - DB_MYSQLDB_PORT= 3306
      - DB_MYSQLDB_DATABASE= n8n
      - DB_MYSQLDB_USER= root
      - DB_MYSQLDB_PASSWORD= 8Deudue83e
      - GENERIC_TIMEZONE= Asia/Kolkata
      - DOMAIN_NAME= demo.workflow.teamat.work
      - NODE_ENV= production
      - WEBHOOK_URL= demo.workflow.teamat.work
      - WORKFLOWS_DEFAULT_NAME= "n8n Workflow"
      - EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS= true
      - EXECUTIONS_DATA_SAVE_ON_ERROR= all
      - EXECUTIONS_DATA_SAVE_ON_PROGRESS= true
      - EXECUTIONS_DATA_SAVE_ON_SUCCESS= all
    # ports:
    #   - '5678:5678'
    volumes:
      - n8n_data:/root/.n8n
    depends_on:
      - db


volumes:
  proxymgr_data:
    driver: local
  proxymgr_letsencrypt:
    driver: local
  sql_data:
    driver: local
  n8n_data:
    driver: local
