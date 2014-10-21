//
//  APIHelper.h
//  YANA
//
//  Created by Gavin Chu on 10/21/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MealRequest.h"

@interface APIHelper : NSObject

extern NSString* const base_url;

extern NSString* const action_create_user;
extern NSString* const action_login;
extern NSString* const action_logout;
extern NSString* const action_create_request;
extern NSString* const action_view_requests;
extern NSString* const action_handle_meal_request;
extern NSString* const action_search_users_by_name;
extern NSString* const action_search_users_by_id;
extern NSString* const action_add_friend;
extern NSString* const action_delete_friend;
extern NSString* const action_get_friend_list;
extern NSString* const action_get_profile_by_id;

extern NSString* const SUCCESS;
extern NSString* const INVALID_USERNAME;
extern NSString* const INVALID_PASSWORD;
extern NSString* const USERNAME_ALREADY_EXISTS;
extern NSString* const WRONG_USERNAME_OR_PASSWORD;
extern NSString* const INVALID_USER_ID;
extern NSString* const ALREADY_FOLLOWED;
extern NSString* const INVALID_FRIEND_ID;
extern NSString* const INVALID_PARAMS;
extern NSString* const INVALID_ACTION;
extern NSString* const MEAL_REQUEST_EXPIRED;
extern NSString* const NO_PERMISSION;
extern NSString* const NOT_FOLLOWING;
extern NSString* const ERROR;

@property (nonatomic, strong) NSDictionary* statusCodeDictionary;

- (NSDictionary *) createUserWithUsername:(NSString *)username
                          andPassword:(NSString *)password;
- (NSDictionary *) loginWithUsername:(NSString *)username
                     andPassword:(NSString *)password;
- (NSDictionary *) logout:(NSString *)userid;

- (NSDictionary *) createMealRequest:(MealRequest *)mealRequest;
- (NSDictionary *) getAllMealRequests:(NSString *)userid;
- (NSDictionary *) handleMealRequests:(NSString *)action;

- (NSDictionary *) searchUserByUsername:(NSString *)username;
- (NSDictionary *) searchUserById:(NSString *)userid;
- (NSDictionary *) addFriend:(NSString *) friendid
                   toYou:(NSString *)userid;
- (NSDictionary *) deleteFriend:(NSString *) friendid
                    fromYou:(NSString *)userid;

- (NSDictionary *) getFriendList:(NSString *)userid;
- (NSDictionary *) getUserById:(NSString *)userid;


@end
