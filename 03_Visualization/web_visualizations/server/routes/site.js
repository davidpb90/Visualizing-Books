const express = require('express');
const router = express.Router();
const db = require('../dbs');

// Home page route
router.get('/', function (req, res) {
    'use strict';
    res.send('Hi globe!');
});

module.exports = router;
