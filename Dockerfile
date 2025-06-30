# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Remove default Nginx welcome page
RUN rm -rf ./*

# Copy the local index.html file to the Nginx html directory
COPY index.html .

# Expose port 80 to the outside world
EXPOSE 80

# Nginx base image already has a CMD to start nginx, so we don't need to specify it explicitly.
# CMD ["nginx", "-g", "daemon off;"]
