FROM node:24-bookworm

WORKDIR /app

EXPOSE 3000

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "const http = require('http'); const options = { host: 'localhost', port: 3000, path: '/', timeout: 2000 }; const req = http.request(options, (res) => { console.log(res.statusCode >= 200 && res.statusCode < 400 ? 'OK' : 'FAIL'); process.exit(res.statusCode >= 200 && res.statusCode < 400 ? 0 : 1); }); req.on('error', () => { console.log('ERROR'); process.exit(1); }); req.end();"

CMD ["npm", "run", "start"]