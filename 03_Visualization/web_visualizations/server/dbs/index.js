const pg = require('pg');
const db_creds = require('../../hidden/aws_info.js');

pg.defaults.poolIdleTimeout = 1000 * 60 * 60;

const pool = new pg.Pool({
    user: db_creds.rds_details.username,
    host: db_creds.rds_details.host,
    database: db_creds.rds_details.database,
    password: db_creds.rds_details.password,
    port: db_creds.rds_details.port
});

console.log('-------- RDS ------------');
console.log('USER : ' + db_creds.rds_details.username);
console.log('HOST : ' + db_creds.rds_details.host + '/' + db_creds.rds_details.database + ':' + db_creds.rds_details.port);

pool.on('error', function(err, client) {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

module.exports = pool;