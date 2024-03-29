# Getting started 

This backend API is designed to store and provide public transport accessibility options based on the station name or bus route.

## Available Scripts

In the root directory, you can run:

### `npm start`

Runs the app in development mode.
By default, it is accessible at http://localhost:3000

### `npm test`

Runs tests.

### `npm run build`

Builds the app for production in the `dist` folder.

Your app is ready to be deployed!

## Environment Variables:

| Environment          | Description                              | Value                                                      |
| -------------------- | ---------------------------------------- | ---------------------------------------------------------- |
| DEBUG_MODE           | Debug level                              | 1                                                          |
| DB_URL               | Local database connection URL            | db-provider://admin:admin@localhost:${DB_PORT}/\${DB_NAME} |
| DB_PORT              | Local database port                      |                                                            |
| DB_USER              | Local database username                  | admin                                                      |
| DB_PASSWORD          | Local database password                  | admin                                                      |
| COMPOSE_PROJECT_NAME | Docker Compose project name              | amp\_{applicationId}                                       |
| SERVER_PORT          | The port that the server is listening to | 3000                                                       |
| JWT_SECRET_KEY       | JWT secret                               | Change_ME!!!                                               |
| JWT_EXPIRATION       | JWT expiration in days                   | 2d                                                         |

\*db-provider - the prisma DB provider (for example: for postgres is postgresql and for MySQL is mysql)

## Getting Started - Local Development

### Prerequisites

Make sure you have Node.js 16.x, npm, and Docker installed.

### Install dependencies

In the root directory, run:

```console
cd server
npm install
```

### Generate Prisma client

```console
npm run prisma:generate
```

### Start database using Docker

```console
npm run docker:db
```

### Initialize the database

```console
npm run db:init
```

### Start the server

```console
npm start
```

## Getting Started - Docker Compose

In the root directory, run:

```console
npm run compose:up
```

## API documentation

After you start the application, go to /api to open Swagger documentation or to /ghraphql to open GraphQL playground


