import { act } from 'react'; // Correct import

test('renders app running message', () => {
  render(<App />);
  const messageElement = screen.getByText(/hi bhavan now the app is running/i);
  expect(messageElement).toBeInTheDocument();
});
