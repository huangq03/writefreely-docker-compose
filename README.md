# WriteFreely with Docker and MySQL

This project runs a self-hosted WriteFreely instance using Docker and a MySQL database. It is pre-configured for a robust setup that is easy to manage and deploy.

## Features

- **Docker Compose:** All services are defined in a `docker-compose.yml` file for easy startup and management.
- **MySQL Database:** Uses a dedicated MySQL 8 container for persistent data storage.
- **Dynamic Configuration:** The WriteFreely `config.ini` is generated automatically at startup from environment variables.
- **Automatic Admin Creation:** An initial administrator user is created automatically from environment variables.
- **Custom Entrypoint:** A custom entrypoint script ensures the services start in the correct order and the database is initialized properly, bypassing bugs in the default image script.

## Prerequisites

- Docker
- Docker Compose

## Configuration

All configuration is managed in the `.env` file. Before starting the services, you need to set the following variables:

- `WRITEFREELY_ADMIN_USER`: The desired username for the administrator.
- `WRITEFREELY_ADMIN_PASSWORD`: The desired password for the administrator.
- `MYSQL_ROOT_PASSWORD`: The root password for the MySQL database.
- `MYSQL_DATABASE`: The name of the database for WriteFreely (e.g., `writefreely`).
- `MYSQL_USER`: The username for the WriteFreely database user.
- `MYSQL_PASSWORD`: The password for the WriteFreely database user.

A `config.ini` file will be generated automatically inside the container from these settings. **Do not** create a `config.ini` file in the `./data` directory, as it will be ignored.

## How to Run

1.  **Clone the project.**
2.  **Configure your environment:** Copy the `.env.example` to `.env` (if it exists) or create a new `.env` file and fill in the values as described above.
3.  **Start the services:**
    ```bash
    docker-compose up -d
    ```

Your WriteFreely instance will be available at `http://localhost:8011`.

## Project Structure

- `docker-compose.yml`: Defines the `writefreely` and `mysql` services.
- `.env`: Contains all secrets and configuration variables.
- `entrypoint.sh`: A custom script that correctly initializes the WriteFreely container, creates the database schema, and creates the admin user.
- `./data/`: A local directory bind-mounted into the container to persist WriteFreely data (e.g., keys, user-generated content). **This directory should not contain a `config.ini` file.**
- `./mysql/`: A local directory bind-mounted into the container to persist the MySQL database data.
