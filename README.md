# Movie API

A secure, scalable, and maintainable RESTful API with GraphQL support for movie management.

## 📗 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Key Features](#key-features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Database Setup](#database-setup)
- [API Documentation](#api-documentation)
- [Authentication](#authentication)
- [GraphQL Support](#graphql-support)
- [Real-time Updates](#real-time-updates)
- [Performance Features](#performance-features)
- [Testing](#testing)
- [Deployment](#deployment)

## Overview

This API provides a robust backend for movie management with features like user authentication, movie following, real-time updates, and GraphQL support.

## Tech Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: PostgreSQL
- **Caching**: Redis
- **Authentication**: JWT
- **Real-time**: ActionCable
- **API Alternatives**: GraphQL
- **Rate Limiting**: Rack Attack
- **Containerization**: Docker

## Key Features

- JWT-based authentication
- CRUD operations for movies
- Follow/unfollow functionality
- Real-time updates via WebSockets
- GraphQL endpoints
- Redis caching
- Role-based access control
- Rate limiting
- Database optimization
- Dockerized deployment

## Getting Started

### Prerequisites

- Ruby 3.4.0
- PostgreSQL
- Redis
- Docker and Docker Compose

### Installation

1. Clone the repository:

```bash
git clone [repository-url]
cd movie-api
```

2. Build Docker containers:

```bash
docker-compose build
```

3. Start the services:

```bash
docker-compose up
```

4. Set up the database:

```bash
# Create and migrate the database
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate

# Seed the database with initial data
docker-compose exec web rails db:seed
```

## API Documentation

### REST Endpoints

#### Authentication

```http
POST /api/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "password"
}
```

#### Movies

```http
# Get movies list
GET /api/movies

# Create movie
POST /api/movies

# Follow movie
POST /api/movies/:id/follow

# Unfollow movie
DELETE /api/movies/:id/unfollow
```

### GraphQL Endpoints

#### Queries

```graphql
# Get movies
{
  "query": "query { movies { id title } }"
}
```

#### Mutations

```graphql
# Follow movie
{
  "query": "mutation($input: FollowMovieInput!) { followMovie(input: $input) { success movie { id title } errors } }",
  "variables": {
    "input": {
      "movieId": "1"
    }
  }
}
```

## Authentication

The API uses JWT for authentication. Include the token in the Authorization header:

```http
Authorization: Bearer your_jwt_token
```

## Real-time Updates

WebSocket connection for real-time updates:

```javascript
// Connect to ActionCable
ws://localhost:3000/cable?token=your_jwt_token
```

## Performance Features

### Caching

- Redis caching for movies and queries
- ETag support for response caching
- Cache invalidation on updates

### Database Optimization

- Indexed queries
- Efficient relationship management
- Query performance monitoring

## Security Features

- JWT authentication
- RBAC (Role-Based Access Control)
- Rate limiting
- CORS protection
- Input validation

## Testing

Run the test suite:

```bash
docker-compose exec web bundle exec rails test
```

Current test coverage: 70%+

## Deployment

1. Build production images:

```bash
docker-compose -f docker-compose.prod.yml build
```

2. Set environment variables:

```bash
cp .env.example .env
# Edit .env with your production values
```

3. Deploy:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Architecture Decisions

1. **GraphQL Implementation**

   - Limited to movie queries and follow/unfollow operations
   - Complements REST API instead of replacing it
   - Demonstrates modern API patterns

2. **Real-time Updates**

   - ActionCable for WebSocket communication
   - Token-based authentication for secure connections
   - Event-driven architecture for movie updates

3. **Caching Strategy**

   - Redis for fast data access
   - Two-level caching (application and HTTP)
   - Efficient cache invalidation

4. **Security Measures**
   - JWT for stateless authentication
   - Role-based access control
   - Rate limiting for API protection

## Challenges and Solutions

1. **Authentication in WebSockets**

   - Challenge: Maintaining secure WebSocket connections
   - Solution: Token-based authentication in connection params

2. **Cache Invalidation**

   - Challenge: Keeping cached data fresh
   - Solution: Event-driven cache updates

3. **Performance Optimization**
   - Challenge: Handling large datasets
   - Solution: Efficient indexing and pagination

## Future Improvements

1. Implement more GraphQL features
2. Add real-time analytics
3. Enhance caching strategies
4. Implement more complex search features

## License

This project is licensed under the MIT License.
