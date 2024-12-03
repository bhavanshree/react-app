# Stage 1: Build the application with a smaller Node.js base image
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies first
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code 
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the static files using a smaller Nginx base image 
FROM nginx:alpine

# Remove the default Nginx files and config
RUN rm -rf /usr/share/nginx/html/*

# Copy the custom Nginx config
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copy only the built files from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 and start Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
