# ECS Api

This is a simple TypeScript application that provides three API endpoints using Express.

## API Endpoints

### 1. GET /hello_world
- **Description**: Returns a JSON response with a message "Hello World!".
- **Controller**: `controller.ts`
- **Route File**: `routes.ts`

### 2. GET /current_time
- **Description**: Returns the current timestamp and a personalized message based on the query parameter `name`.
- **Query Parameter**: `name` (optional)
- **Controller**: `controller.ts`
- **Route File**: `routes.ts`

### 3. GET /healthcheck
- **Description**: Returns a simple 200 status code to indicate that the service is healthy.
- **Controller**: `controller.ts`
- **Route File**: `routes.ts`

## Project Structure

```
src/
├── app.ts
├── controllers/
│   └── controller.ts
├── Dockerfile
├── middleware/
│   └── logger-middleware.ts
├── package.json
├── routes/
│   └── routes.ts
├── tsconfig.json
└── types/
    └── index.ts
```

## Prerequisites

- Node.js (v14 or higher)
- npm (v6 or higher)
- Docker (v20.10 or higher)

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd ecs-api-terraform
   ```

3. Install the dependencies:
   ```bash
   npm install
   ```

4. Start the application:
   ```bash
   npm start
   ```

## Docker Instructions

1. Build the Docker image:
   ```bash
   docker build -t ecs-api:latest .
   ```

2. Run the Docker container:
   ```bash
   docker run -d --name my-image -p 3000:3000 ecs-api:latest
   ```

3. Test the Docker container:
   ```bash
   curl -X GET -H "Content-Type: application/json" http://localhost:3000/healthcheck
   ```
   ```bash
   docker logs my-image -f
   ```

4. Publish to ECR

   To publish an image to ECR, you need an AWS account, export the credentials, and execute the following commands:

   ```bash
   aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
   docker tag ecs-api:latest aws_account_id.dkr.ecr.region.amazonaws.com/my-repository:tag
   docker push aws_account_id.dkr.ecr.region.amazonaws.com/my-repository:tag
   ```

   **Note**: Replace `aws_account_id`, `my-repository`, and `region` with your values.

## Usage

- To access the `/hello_world` endpoint, send a GET request to `http://localhost:3000/hello_world`.
- To access the `/current_time` endpoint, send a GET request to `http://localhost:3000/current_time?name=YourName`.
- To access the `/healthcheck` endpoint, send a GET request to `http://localhost:3000/healthcheck`.

## Technologies Used

- TypeScript
- Express
- Docker

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.