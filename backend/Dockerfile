# Backend Dockerfile
FROM public.ecr.aws/docker/library/node:18-alpine
WORKDIR /app
COPY package.json package-lock.json* /app/
RUN npm ci || npm install
COPY server.js /app/server.js
COPY db-init.sql /app/db-init.sql
EXPOSE 3000
CMD ["npm","start"]
