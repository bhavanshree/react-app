import React from 'react';
import { render, screen } from '@testing-library/react';
import { act } from 'react'; // Updated import
import App from './App';

test('renders app running message', () => {
  render(<App />);
  const messageElement = screen.getByText(/hi bhavan now the app is running/i);
  expect(messageElement).toBeInTheDocument();
});
