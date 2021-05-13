#!/bin/bash

cd /home/ubuntu/app
npm install
node seeds/seed.js
pm2 start app.js
