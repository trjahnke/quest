FROM node:10

# Setup working directory
WORKDIR /app/src

# Copy files from the host to the container
COPY /task/package*.json ./

# Install dependencies
RUN npm install

# Move bin files over along with main src
COPY /task/bin /app/src/bin
COPY /task/src .

EXPOSE 3000

# Run the app
CMD ["node", "000.js"]
