# My TypeScript App

This is a simple TypeScript application that provides three API endpoints using Express.

## API Endpoints

### 1. GET /hello_world
- **Description**: Returns a JSON response with a message "Hello World!".
- **Controller**: `Endpoint1Controller`
- **Route File**: `endpoint1Routes.ts`

### 2. GET /current_time
- **Description**: Returns the current timestamp and a personalized message based on the query parameter `name`.
- **Query Parameter**: `name` (optional)
- **Controller**: `Endpoint2Controller`
- **Route File**: `endpoint2Routes.ts`

### 3. GET /healthcheck
- **Description**: Returns a simple 200 status code to indicate that the service is healthy.
- **Controller**: `Endpoint3Controller`
- **Route File**: `endpoint3Routes.ts`

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd my-typescript-app
   ```

3. Install the dependencies:
   ```
   npm install
   ```

4. Start the application:
   ```
   npm start
   ```

## Technologies Used
- TypeScript
- Express

## License
This project is licensed under the MIT License.