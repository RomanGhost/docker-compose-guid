# Use the official Dart image as the base image
FROM dart:stable AS build

# Install specific Flutter SDK version (between 3.4.2 and 4.0.0)
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && cd /flutter \
    && git checkout 3.10.0 # Replace with the desired version between 3.4.2 and 4.0.0

# Set the Flutter path
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-download Flutter dependencies
RUN flutter doctor -v
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Set the working directory
WORKDIR /app

# Copy the necessary files
COPY . .

# Install dependencies
RUN flutter pub get

# Build the Flutter web application
RUN flutter build web --release --dart-define=BASE_URL=${BASE_URL}

# Use Nginx to serve the Flutter web app
FROM nginx:stable-alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]