const express = require('express');
const router = express.Router();
const pool = require('../dbs');

router.get('/', function(req, res, next) {
    client.query('SELECT *', function(err, result) {
        if (err) {
            throw new Error(err);
        } else {
            console.log(result.rows[0]);
        }
    });
});

module.exports = router;
