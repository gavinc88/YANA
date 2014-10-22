//
//  APIHelper.m
//  YANA
//
//  Created by Gavin Chu on 10/21/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper()

@end

@implementation APIHelper

NSString* const base_url = @"http://yana169.herokuapp.com";

NSString* const action_create_user = @"users/create_user";
NSString* const action_login = @"users/login";
NSString* const action_logout = @"users/logout";
NSString* const action_create_request = @"request/create_request";
NSString* const action_view_requests = @"request/view_requests";
NSString* const action_handle_meal_request = @"request/handle_meal_request";
NSString* const action_search_users_by_name = @"users/search_users_by_name";
NSString* const action_search_users_by_id = @"users/search_users_by_id";
NSString* const action_add_friend = @"friends/add_friend";
NSString* const action_delete_friend = @"friends/delete_friend";
NSString* const action_get_friend_list = @"friends/get_friend_list";
NSString* const action_get_profile_by_id = @"users/get_profile_by_id";

NSString* const SUCCESS = @"SUCCESS";
NSString* const INVALID_USERNAME = @"INVALID_USERNAME";
NSString* const INVALID_PASSWORD = @"INVALID_PASSWORD";
NSString* const USERNAME_ALREADY_EXISTS = @"USERNAME_ALREADY_EXISTS";
NSString* const WRONG_USERNAME_OR_PASSWORD = @"WRONG_USERNAME_OR_PASSWORD";
NSString* const INVALID_USER_ID = @"INVALID_USER_ID";
NSString* const ALREADY_FOLLOWED = @"ALREADY_FOLLOWED";
NSString* const INVALID_FRIEND_ID = @"INVALID_FRIEND_ID";
NSString* const INVALID_PARAMS = @"INVALID_PARAMS";
NSString* const INVALID_ACTION = @"INVALID_ACTION";
NSString* const MEAL_REQUEST_EXPIRED = @"MEAL_REQUEST_EXPIRED";
NSString* const NO_PERMISSION = @"NO_PERMISSION";
NSString* const NOT_FOLLOWING = @"NOT_FOLLOWING";
NSString* const ERROR = @"ERROR";

- (instancetype) init{
    self = [super init];
    self.SUCCESS = @"SUCCESS";
    self.INVALID_USERNAME = @"INVALID_USERNAME";
    self.INVALID_PASSWORD = @"INVALID_PASSWORD";
    self.USERNAME_ALREADY_EXISTS = @"USERNAME_ALREADY_EXISTS";
    self.WRONG_USERNAME_OR_PASSWORD = @"WRONG_USERNAME_OR_PASSWORD";
    self.INVALID_USER_ID = @"INVALID_USER_ID";
    self.ALREADY_FOLLOWED = @"ALREADY_FOLLOWED";
    self.INVALID_FRIEND_ID = @"INVALID_FRIEND_ID";
    self.INVALID_PARAMS = @"INVALID_PARAMS";
    self.INVALID_ACTION = @"INVALID_ACTION";
    self.MEAL_REQUEST_EXPIRED = @"MEAL_REQUEST_EXPIRED";
    self.NO_PERMISSION = @"NO_PERMISSION";
    self.NOT_FOLLOWING = @"NOT_FOLLOWING";
    self.ERROR = @"ERROR";
    if(self){
        self.statusCodeDictionary = @{
          @"1": SUCCESS,
          @"-1" : INVALID_USERNAME,
          @"-2" : INVALID_PASSWORD,
          @"-3" : USERNAME_ALREADY_EXISTS,
          @"-4" : WRONG_USERNAME_OR_PASSWORD,
          @"-5" : INVALID_USER_ID,
          @"-6" : ALREADY_FOLLOWED,
          @"-7" : INVALID_FRIEND_ID,
          @"-8" : INVALID_PARAMS,
          @"-9" : INVALID_ACTION,
          @"-10" : MEAL_REQUEST_EXPIRED,
          @"-11" : NO_PERMISSION,
          @"-12" : NOT_FOLLOWING,
          @"-99" : ERROR
          };
    }
    return self;
}

- (NSString *) generateFullUrl:(NSString *)action{
    return [NSString stringWithFormat:@"%@/%@", base_url, action];
}

- (NSDictionary *) makeSynchronousPostRequestWithURL:(NSString *)url
                                      args:(NSDictionary *)args{
    NSLog(@"POST to %@", url);
    // Setup POST request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSError *jsonError = nil;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:args options:0 error:&jsonError];
    NSLog(@"args: %@", args);
    if(jsonError){
        NSLog(@"error forming json: %@", jsonError);
        return nil;
    }else{
        urlRequest.HTTPBody = postdata;
    }
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error){
        NSLog(@"server error: %@", error);
        return nil;
    }
    
//    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", responseString);
    
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
    
    if(jsonError){
        NSLog(@"error converting response to json: %@", jsonError);
        return nil;
    }else{
        NSLog(@"response: %@", jsonResponse);
        return jsonResponse;
    }
}

- (NSDictionary *) createUserWithUsername:(NSString *)username
                          andPassword:(NSString *)password{
    NSString *requestURL = [self generateFullUrl:action_create_user];

    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                         username, @"username",
                         password, @"password",
                         nil];

    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) loginWithUsername:(NSString *)username
                     andPassword:(NSString *)password{
    NSString *requestURL = [self generateFullUrl:action_login];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          username, @"username",
                          password, @"password",
                          nil];
    
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) logout:(NSString *)userid{
    return @{};
}

- (NSDictionary *) createMealRequest:(MealRequest *)mealRequestP{
    return @{};
}

- (NSDictionary *) getAllMealRequests:(NSString *)userid{
    return @{};
}

- (NSDictionary *) handleMealRequests:(NSString *)action{
    return @{};
}

- (NSDictionary *) searchUserByUsername:(NSString *)username{
    return @{};
}

- (NSDictionary *) searchUserById:(NSString *)userid{
    return @{};
}

- (NSDictionary *) addFriend:(NSString *) friendid
                   toYou:(NSString *)userid{
    return @{};
}

- (NSDictionary *) deleteFriend:(NSString *) friendid
                    fromYou:(NSString *)userid{
    return @{};
}

- (NSDictionary *) getFriendList:(NSString *)userid{
    return @{};
}

- (NSDictionary *) getUserById:(NSString *)userid{
    return @{};
}

@end
