FROM node:18-alpine

# Set working directory
WORKDIR /app

# Create app user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodeapp -u 1001

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p data logs uploads

# Set proper permissions
RUN chown -R nodeapp:nodejs /app
RUN chmod -R 755 /app
RUN chmod -R 775 /app/data /app/logs /app/uploads

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Switch to non-root user
USER nodeapp

# Start application
CMD ["node", "server.js"]