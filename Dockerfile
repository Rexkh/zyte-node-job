# 1. Use a Node base image
FROM node:20-slim

# 2. Install Python + shub runtime deps (Scrapy Cloud expects Python & entrypoint)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 3. Install Scrapy Cloud entrypoint helper
RUN pip3 install scrapinghub-entrypoint-scrapy

# 4. Create workdir
WORKDIR /app

# 5. Copy Node project files
COPY package*.json ./
RUN npm install --omit=dev

COPY app.js ./

# 6. Default command: run your JS
# Scrapy Cloud will still wrap this via its entrypoint
CMD ["node", "app.js"]
