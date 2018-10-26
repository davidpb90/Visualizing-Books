const path = require('path');
const express = require('express');
const pg = require('pg');
const db_creds = require('./hidden/aws_info.js');
const site = require('./server/routes/site.js');
const db = require('./server/dbs');
const app = express();
const port = 3000;

app.set('view enging', 'pug');
app.set('views', path.join(__dirname, 'client/views'));

app.use('/', site);

// Initialize the application once the database connections are ready
db.connect(function (err) {
    'use strict';

    if (err) {
        console.log('Unable to connect with DB', err);
    } else {
        app.listen(port, function () {
            console.log(`Listening on port ${port}`);
        });
    }
});