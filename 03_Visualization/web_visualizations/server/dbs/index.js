const {Pool} = require('pg');
const db_creds = require('./hidden/aws_info.js');
const connection_string = db_creds.rds_details.connect_uri;

// const config = {
//     user: db_creds.rds_details.username,
//     database: db_creds.rds.details.database,
//     password: db_creds.rds.details.password,
//     port: db_creds.rds.details.port,
//     max: 10, // max number of connection can be open to database
//     idleTimeoutMillis: 30000 // how long a client is allowed to remain idle before being closed
// };

const pool = new Pool({
    connectionString: connection_string
});

let state = {
    db: null
};

exports.connect = pool.connect(function (err, client, release) {
    'use strict';
    if (err) {
        return console.error('Error acquiring client', err.stack);
    }

    client.query('SELECT NOW()', function (err, result) {
        release();
        if (err) {
            return console.error('Error executing query', err.stack);
        }

        console.log(result.rows);
    });
});
