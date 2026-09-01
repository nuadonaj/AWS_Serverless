/**
 * Configuration file for React Frontend
 * 
 * Environment variables (required for production):
 * - REACT_APP_EXTERNAL_API_URL: External API endpoint
 * - REACT_APP_EXTERNAL_API_KEY: External API key (if needed)
 * - REACT_APP_INTERNAL_API_URL: Internal API Gateway endpoint
 * - REACT_APP_INTERNAL_API_KEY: Internal API Gateway key
 * 
 * Create a .env file in the frontend directory:
 * REACT_APP_EXTERNAL_API_URL=https://jsonplaceholder.typicode.com/posts/1
 * REACT_APP_INTERNAL_API_URL=http://localhost:4566/default/lambda
 * REACT_APP_INTERNAL_API_KEY=your-secure-key-here
 */

const config = {
  externalApiUrl: process.env.REACT_APP_EXTERNAL_API_URL || 'https://jsonplaceholder.typicode.com/posts/1',
  externalApiKey: process.env.REACT_APP_EXTERNAL_API_KEY || '',
  internalApiUrl: process.env.REACT_APP_INTERNAL_API_URL || 'http://localhost:4566/default/lambda',
  internalApiKey: process.env.REACT_APP_INTERNAL_API_KEY || ''
};

// Validation for production
if (process.env.NODE_ENV === 'production') {
  if (!config.internalApiUrl) {
    console.warn('Warning: REACT_APP_INTERNAL_API_URL environment variable is not set');
  }
  if (!config.internalApiKey) {
    console.warn('Warning: REACT_APP_INTERNAL_API_KEY environment variable is not set');
  }
}

export default config;
