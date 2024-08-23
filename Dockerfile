FROM node:18 as build-stage
WORKDIR /app
COPY package*.json ./
# Install dependencies
RUN npm install
COPY . .
RUN npm run build --prod
RUN ls /app/dist/angular-media-app

# Stage 2: Serve the app with Nginx
FROM nginx:alpine as production-stage
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist/angular-media-app /usr/share/nginx/html
# Copy custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80
EXPOSE 80
# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
