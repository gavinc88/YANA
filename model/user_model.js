var collections = require('./db_collections');
var User = collections.User;

exports.checkUser = function(user) {
  if (user.length > global.MAX_USERNAME_LENGTH || user.length == 0)
    return global.INVALID_USERNAME;
  return 0;
}

exports.checkPwd = function(pwd) {
  if (pwd.length > global.MAX_PASSWORD_LENGTH)
    return global.INVALID_PASSWORD;
  return 0;
};

// User Login
exports.login = function(user, pwd, callback) {
  var usr = User;
  usr.findOne({name: user}, function(err, result){
    if (err) return callback({errCode: global.ERROR});

    // User not existing or the password is wrong
    if (result == null || result.password != pwd)
     return callback({errCode: global.WRONG_USERNAME_OR_PASSWORD});

    // save the result
    result.save(function(err) {
      if (err) return callback({errCode: global.ERROR});
      return callback({errCode: global.SUCCESS, user_id: result._id});
  	});
  });
};

// Create Account
exports.add = function(user, pwd, callback) {
  var usr = User;

  // Check if the user name exists
  usr.findOne({name: user},function(err, result){
    if (err) return callback({errCode: global.ERROR});
    if (result != null) 
      return callback({errCode: global.USERNAME_ALREADY_EXISTS});

    // Add the user to the database
    var newuser = new usr();
    newuser.name = user;
    newuser.password = pwd;
    newuser.profile = "test";

    newuser.save(function(err, u) {
      if (err) return callback({errCode: global.ERROR});
      return callback({errCode: global.SUCCESS, user_id: u._id});
    });
  });
};

// Delete all users (for testing)
exports.deleteall = function(callback) {
  var user = User;
  user.find(function(err, users) {
    if (err) return callback({errCode: global.ERROR});
  	for (var i = 0; i < users.length; i++) {
      user.remove({
      	_id: users[i]._id
      }, function(err) {
      	if (err) return callback({errCode: global.ERROR});
  	  });
  	};
  	return callback({errCode: global.SUCCESS});
  });
};

// List all users (for testing)
exports.allusers = function(callback) {
  var user = User;
  user.find(function(err, users) {
    if (err) return callback({errCode: global.ERROR});
    return callback(users);
  })
};