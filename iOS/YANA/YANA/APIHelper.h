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

@property (nonatomic, strong) NSString* SUCCESS;
@property (nonatomic, strong) NSString* INVALID_USERNAME;
@property (nonatomic, strong) NSString* INVALID_PASSWORD;
@property (nonatomic, strong) NSString* USERNAME_ALREADY_EXISTS;
@property (nonatomic, strong) NSString* WRONG_USERNAME_OR_PASSWORD;
@property (nonatomic, strong) NSString* INVALID_USER_ID;
@property (nonatomic, strong) NSString* ALREADY_FOLLOWED;
@property (nonatomic, strong) NSString* INVALID_FRIEND_ID;
@property (nonatomic, strong) NSString* INVALID_PARAMS;
@property (nonatomic, strong) NSString* INVALID_ACTION;
@property (nonatomic, strong) NSString* MEAL_REQUEST_EXPIRED;
@property (nonatomic, strong) NSString* NO_PERMISSION;
@property (nonatomic, strong) NSString* NOT_FOLLOWING;
@property (nonatomic, strong) NSString* ERROR;

@property (nonatomic, strong) NSDictionary* statusCodeDictionary;

- (NSDictionary *) createUserWithUsername:(NSString *)username
                          andPassword:(NSString *)password;
- (NSDictionary *) loginWithUsername:(NSString *)username
                     andPassword:(NSString *)password;
- (NSDictionary *) logout:(NSString *)userid;

- (NSDictionary *) createMealRequest:(MealRequest *)mealRequest;
- (NSDictionary *) getAllMealRequests:(NSString *)userid;
- (NSDictionary *) handleMealRequestsForRequest:(NSString *)req_id
                                     WithAction:(NSString *)action
                                        ForUser:(NSString *)userid;

- (NSDictionary *) searchUserByUsername:(NSString *)username;
- (NSDictionary *) searchUserById:(NSString *)userid;
- (NSDictionary *) addFriend:(NSString *) friendid
                   toYou:(NSString *)userid;
- (NSDictionary *) deleteFriend:(NSString *) friendid
                    fromYou:(NSString *)userid;

- (NSDictionary *) getFriendList:(NSString *)userid;
- (NSDictionary *) getUserById:(NSString *)userid;


@end
