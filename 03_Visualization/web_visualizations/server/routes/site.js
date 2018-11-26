const express = require('express');
const router = express.Router();
const pool = require('../dbs');




router.get('/', function(req, res, next) {
    (async () => {
  		//const client = await pool.connect()
  		try {
  		  res = await pool.query('SELECT * FROM final_around_the_world')
  		  .then(res => console.log(res.rows[0]))
          .catch(e => console.error(e.stack));
  		} finally {
  		  pool.end();
  		}
	})().catch(e => console.log('no pool: ' + e.stack));
    //client.query('SELECT * FROM final_around_the_world', function(err, result) {
    //    if (err) {
    //        throw new Error(err);
    //    } else {
    //        console.log(result.rows[0]);
    //    }
    //});
});

module.exports = router;
