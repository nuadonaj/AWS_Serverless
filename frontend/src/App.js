import React, { useState } from 'react';
import config from './config';

// Retry Logic with Exponential Backoff
async function fetchWithRetry(url, options = {}, retries = 2, delay = 300) {
  try {
    return await fetch(url, options);
  } catch (err) {
    if (retries === 0) throw err;
    await new Promise(res => setTimeout(res, delay));
    return fetchWithRetry(url, options, retries - 1, delay * 2);
  }
}

function App() {
  const [externalApiResponse, setExternalApiResponse] = useState('');
  const [internalApiResponse, setInternalApiResponse] = useState('');

  const fetchExternalApiData = async () => {
    try {
      const response = await fetchWithRetry(config.externalApiUrl, {
        headers: {
          'Authorization': config.externalApiKey ? `Bearer ${config.externalApiKey}` : undefined
        }
      });
      const data = await response.json();
      setExternalApiResponse(JSON.stringify(data, null, 2));
    } catch (error) {
      setExternalApiResponse('Error fetching data');
    }
  };

  const fetchInternalApiData = async () => {
    try {
      const response = await fetchWithRetry(config.internalApiUrl, {
        // API Gateway REST v1 requires x-api-key, not Authorization
        headers: {
          'x-api-key': config.internalApiKey
        }
      });
      const data = await response.json();
      setInternalApiResponse(JSON.stringify(data, null, 2));
    } catch (error) {
      setInternalApiResponse('Error fetching data');
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Welcome to the React Frontend</h1>
        <p>This is a simple React application.</p>
        <div style={{ marginBottom: '2rem' }}>
          <button onClick={fetchExternalApiData}>Fetch External API Data</button>
          <pre>{externalApiResponse}</pre>
        </div>
        <div>
          <button onClick={fetchInternalApiData}>Fetch Internal API Data</button>
          <pre>{internalApiResponse}</pre>
        </div>
      </header>
    </div>
  );
}

export default App;
