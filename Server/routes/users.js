var express = require('express');
var data = require('../model/user_model');
var router = express.Router();

/* GET users listing. */

router.get('/userlist', function(req, res) {
  data.allusers(function(result) {
    return res.json(result);
  });
});

router.post('/login', function(req, res) {
  data.login(req.body.user, req.body.password, function(result) {
    return res.json(result);
  });
});

router.post('/add', function(req, res) {
  var nvalidU = data.checkUser(req.body.user);
  var nvalidP = data.checkPwd(req.body.password);
  if (nvalidP) return res.json({'errCode': nvalidP});
  if (nvalidU) return res.json({'errCode': nvalidU});

  data.add(req.body.user, req.body.password, function(result) {
    return res.json(result);
  })
});

module.exports = router;
