const express = require('express');
const router = express.Router();
const pool = require('../dbs');

router.get('/', function(req, res, next) {
    (async function() {
        try {
            res = await pool.query('SELECT * FROM final_around_the_world')
            .then(function(result) {
                console.log('Book title: ' + result.rows[0].title);
                res.render('index.pug', { rows : result.rows, booktitle : result.rows[0].title});
            })
            .catch(function(e) {
                console.error(e.stack);
            });
        } finally {
            pool.end();
        }
    })().catch(function(e) {
        console.log('no pool: ' + e.stack);
    });
});

module.exports = router;