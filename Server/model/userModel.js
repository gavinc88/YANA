var collections = require('./db_collections');
var User = collections.User;

exports.checkUser = function(user) {
  if (user.length > global.MAX_USERNAME_LENGTH || user.length == 0)
    return global.ERR_BAD_USERNAME;
  return 0;
}

exports.checkPwd = function(pwd) {
  if (pwd.length > global.MAX_PASSWORD_LENGTH)
    return global.ERR_BAD_PASSWORD;
  return 0;
};

exports.login = function(user, pwd, callback) {
  var usr = User;
  usr.findOne({name: user}, function(err, result){
    if (err) return callback(err);

    // User not existing or the password is wrong
    if (result == null || result.password != pwd)
     return callback({errCode: global.ERR_BAD_CREDENTIALS});

    // save the result
    result.save(function(err) {
      if (err)
      	return callback(err);
      return callback({errCode: global.SUCCESS});
  	});
  });
};

exports.add = function(user, pwd, callback) {
  var usr = User;

  // Check if the user name exists
  usr.findOne({name: user},function(err, result){
    if (err) return callback(err);
    if (result != null) 
      return callback({errCode: global.ERR_USER_EXISTS});

    // Add the user to the database
    var newuser = new usr();
    newuser.name = user;
    newuser.password = pwd;
    newuser.profile = "test";

    newuser.save(function(err) {
      if (err)
        return callback(err);
      return callback({errCode: global.SUCCESS});
    });
  });
};

exports.deleteall = function(callback) {
  var user = User;
  user.find(function(err, users) {
    if (err)
      return callback(err);
  	for (var i = 0; i < users.length; i++) {
      user.remove({
      	_id: users[i]._id
      }, function(err) {
      	if (err)
          return callback(err);
  	  });
  	};
  	return callback({errCode: global.SUCCESS});
  });
};

exports.allusers = function(callback) {
  var user = User;
  user.find(function(err, users) {
    if (err)
      return callback(err);
    return callback(users);
  })
};