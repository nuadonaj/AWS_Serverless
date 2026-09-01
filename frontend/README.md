# React Frontend

## Overview

This React application provides the user interface for a cloud-native web application. It communicates with a serverless backend API hosted on AWS Lambda and includes basic reliability enhancements for improved user experience.

## Features

- React-based user interface
- Communication with AWS Lambda backend
- Configuration-driven API endpoints
- Retry logic with exponential backoff
- Basic latency monitoring
- LocalStack compatibility for local development

## Prerequisites

- Node.js
- npm

## Installation

Navigate to the frontend directory:

```bash
cd frontend
```

Install dependencies:

```bash
npm install
```

## Running the Application

Start the development server:

```bash
npm start
```

The application will be available at:

```text
http://localhost:3000
```

## Production Build

Create an optimized production build:

```bash
npm run build
```

Production files will be generated in the `build/` directory.

## Project Structure

```text
src/
├── App.js
├── config.js
├── index.js
├── index.css

public/
├── index.html
```

## Configuration

Application endpoints are configured in `src/config.js`.

For production deployments, sensitive values should be managed using environment variables rather than hardcoded configuration.

## Technologies Used

- React
- JavaScript
- AWS Lambda
- LocalStack

## License

This project is licensed under the MIT License. 
