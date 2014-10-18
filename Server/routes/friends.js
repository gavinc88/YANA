var express = require('express');
var data = require('../model/friends_model');
var router = express.Router();

/* GET users listing. */

router.get('/friendlist', function(req, res) {
  data.allusers(function(result) {
    return res.json(result);
  });
});

router.post('/follow', function(req, res) {
  data.follow(req.body.to_id, req.body.from_id, function(result) {
    return res.json(result);
  });
});

module.exports = router;
