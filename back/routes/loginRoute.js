const express = require('express');
const router = express.Router();
const loginControle = require('../controllers/loginControle');

router.post('/', loginControle.login);

module.exports = router;