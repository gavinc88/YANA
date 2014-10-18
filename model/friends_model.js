var collections = require('./db_collections');
var Friends = collections.Friends;
var User = collections.User;

// user with from_id follows user with to_id
exports.follow = function(to_id, from_id, callback) {
  var usr = User;
  usr.findById(to_id, function(err, to_res){
    // User doesn't exist
    if (err) return callback({errCode: global.INVALID_USER_ID});

    usr.findById(from_id, function(err, from_res) {
      // User doesn't exist
      if (err) return callback({errCode: global.INVALID_USER_ID});

        Friends.findOne({to_id: to_id, from_id: from_id}, function(err, pair) {
          if (err) return callback({errCode: global.ERROR});

          if (pair)
            return callback({errCode: global.ALREADY_FOLLOWED});
          var newfriends = new Friends();
          newfriends.to_username = to_res.name;
          newfriends.to_id = to_id;
          newfriends.from_id = from_id;

          newfriends.save(function(err) {
            if (err) return callback({errCode: global.ERROR});
            return callback({errCode: global.SUCCESS});
          });
        })
    });
  });
};

// user with from_id unfollows user with to_id
exports.unfollow = function(to_id, from_id, callback) {
  var usr = User;
  Friends.findOne({to_id: to_id, from_id: from_id}, function(err, pair) {
    if (err) return callback({errCode: global.ERROR});

    if (pair == null) {
      usr.findById(to_id, function(err, to_res){
        // User doesn't exist
        if (err) return callback({errCode: global.INVALID_USER_ID});
        usr.findById(from_id, function(err, from_res) {
          // User doesn't exist
          if (err) return callback({errCode: global.INVALID_USER_ID});
          return callback({errCode: global.NOT_FOLLOWING});
        });
      });
    } else {
      Friends.remove({_id: pair._id}, function(err) {
        if (err) return callback({errCode: global.ERROR});

        return callback({errCode: global.SUCCESS});
      });
    }
  });
};

// List all friend pairs (for testing)
exports.allfriends = function(callback) {
  var friends = Friends;
  friends.find(function(err, fs) {
    if (err)
      return callback(err);
    return callback(fs);
  })
};