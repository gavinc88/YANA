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

#define ServerApiURL @"http://yana169.herokuapp.com"
NSString* const base_url = @"http://yana169.herokuapp.com";

NSString* const action_create_user = @"users/create_user";
NSString* const action_login = @"users/login";
NSString* const action_logout = @"users/logout";
NSString* const action_create_request = @"request/create_request";
NSString* const action_view_requests = @"request/request_list";
NSString* const action_handle_meal_request = @"request/handle_request";
NSString* const action_search_users_by_name = @"users/search_users_by_name";
NSString* const action_search_users_by_id = @"users/search_users_by_id";
NSString* const action_add_friend = @"friends/add_friend";
NSString* const action_delete_friend = @"friends/delete_friend";
NSString* const action_update_device_token = @"users/update_device_token";
NSString* const action_get_friend_list = @"friends/friend_list";
NSString* const action_get_friend_requests = @"friends/friend_requests";
NSString* const action_get_profile_by_id = @"users/profile";


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
          @"1": self.SUCCESS,
          @"-1" : self.INVALID_USERNAME,
          @"-2" : self.INVALID_PASSWORD,
          @"-3" : self.USERNAME_ALREADY_EXISTS,
          @"-4" : self.WRONG_USERNAME_OR_PASSWORD,
          @"-5" : self.INVALID_USER_ID,
          @"-6" : self.ALREADY_FOLLOWED,
          @"-7" : self.INVALID_FRIEND_ID,
          @"-8" : self.INVALID_PARAMS,
          @"-9" : self.INVALID_ACTION,
          @"-10" : self.MEAL_REQUEST_EXPIRED,
          @"-11" : self.NO_PERMISSION,
          @"-12" : self.NOT_FOLLOWING,
          @"-99" : self.ERROR
          };
    }
    return self;
}

- (NSString *) generateFullUrl:(NSString *)action{
    return [NSString stringWithFormat:@"%@/%@", base_url, action];
}

- (NSDictionary *) makeSynchronousGetRequestWithURL:(NSString *)url{
    NSLog(@"GET from %@", url);
    
    // Setup GET request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = @"GET";
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error){
        NSLog(@"server error: %@", error);
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
    
    if(jsonError){
        NSLog(@"error converting response to json: %@\n\nresponse: %@", jsonError, jsonResponse);
        return nil;
    }else{
        NSLog(@"response: %@", jsonResponse);
        return jsonResponse;
    }
}

- (NSDictionary *) makeSynchronousGetRequestWithURL:(NSString *)url
                                             andParams:(NSDictionary *)params{
    // Format params to url
    if([params count]){
        
        NSMutableArray *parts = [NSMutableArray array];
        for (NSString *key in [params allKeys]) {
            NSString *value = [params objectForKey:key];
            NSString *part = [NSString stringWithFormat: @"%@=%@", key, value];
            [parts addObject: part];
        }
        [url stringByAppendingFormat:@"?%@", [parts componentsJoinedByString: @"&"]];
    }
    NSLog(@"GET from %@", url);
    
    // Setup GET request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = @"GET";
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error){
        NSLog(@"server error: %@", error);
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
    
    if(jsonError){
        NSLog(@"error converting response to json: %@\n\nresponse: %@", jsonError, jsonResponse);
        return nil;
    }else{
        NSLog(@"response: %@", jsonResponse);
        return jsonResponse;
    }
}

- (NSDictionary *) makeSynchronousPostRequestWithURL:(NSString *)url
                                      args:(NSDictionary *)args{
    NSLog(@"POST to %@", url);
    // Setup POST request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your args to json and set it to request's HTTPBody
    NSError *jsonError = nil;
    NSData *json;
    if ([NSJSONSerialization isValidJSONObject:args]){
        json = [NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (json != nil && jsonError == nil){
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
            urlRequest.HTTPBody = json;
        }else{
            NSLog(@"error forming json: %@", jsonError);
            return nil;
        }
    }else{
        NSLog(@"Invalid args");
        return nil;
    }
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error){
        NSLog(@"server error: %@", error);
        return nil;
    }
    
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
    
    if(jsonError){
        NSLog(@"error converting response to json: %@\n\nresponse: %@", jsonError, jsonResponse);
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
    NSString *requestURL = [self generateFullUrl:action_logout];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          userid, @"user_id",
                          nil];
    
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) createMealRequest:(MealRequest *)mealRequest {
    NSString *requestURL = [self generateFullUrl:action_create_request];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          mealRequest.ownerid, @"user_id",
                          mealRequest.ownerUsername, @"username",
                          mealRequest.invitedFriends, @"invitations",
                          mealRequest.type, @"meal_type",
                          mealRequest.time, @"meal_time",
                          mealRequest.restaurant, @"restaurant",
                          mealRequest.comment, @"comment",
                          nil];
    NSLog(@"%@",args);
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) getAllMealRequests:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_view_requests];
    
    requestURL = [requestURL stringByAppendingFormat:@"/%@", userid];
    
    NSDictionary *jsonResponse = [self makeSynchronousGetRequestWithURL:requestURL];
    
    return jsonResponse;
}

- (NSDictionary *) handleMealRequestsForRequest:(NSString *)req_id
                                     WithAction:(NSString *)action
                                        ForUser:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_handle_meal_request];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          req_id, @"request_id",
                          action, @"action",
                          userid, @"user_id",
                          nil];
    
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) searchUserByUsername:(NSString *)username{
    NSString *requestURL = [self generateFullUrl:action_search_users_by_name];
    
    requestURL = [requestURL stringByAppendingFormat:@"/%@", username];
    
    NSDictionary *jsonResponse = [self makeSynchronousGetRequestWithURL:requestURL];
    
    return jsonResponse;
}

- (NSDictionary *) searchUserById:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_search_users_by_id];
    
    requestURL = [requestURL stringByAppendingFormat:@"/%@", userid];
    
    NSDictionary *jsonResponse = [self makeSynchronousGetRequestWithURL:requestURL];
    
    return jsonResponse;
}

- (NSDictionary *) addFriend:(NSString *) friendid
                   toYou:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_add_friend];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          friendid, @"to_id",
                          userid, @"from_id",
                          nil];
    
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) deleteFriend:(NSString *) friendid
                    fromYou:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_delete_friend];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          friendid, @"to_id",
                          userid, @"from_id",
                          nil];
    
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

- (NSDictionary *) getFriendList:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_get_friend_list];
    
    requestURL = [requestURL stringByAppendingFormat:@"/%@", userid];
    
    NSDictionary *jsonResponse = [self makeSynchronousGetRequestWithURL:requestURL];
    
    return jsonResponse;
}

- (NSDictionary *) getFriendRequests:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_get_friend_requests];
    
    requestURL = [requestURL stringByAppendingFormat:@"/%@", userid];
    
    NSDictionary *jsonResponse = [self makeSynchronousGetRequestWithURL:requestURL];
    
    return jsonResponse;
}

- (NSDictionary *) getProfile:(NSString *)userid
                     targetid:(NSString *)targetid{
    NSString *requestURL = [self generateFullUrl:action_get_profile_by_id];
    
    requestURL = [requestURL stringByAppendingFormat:@"/%@/%@", userid, targetid];
    
    NSDictionary *jsonResponse = [self makeSynchronousGetRequestWithURL:requestURL];
    
    return jsonResponse;
}

- (NSDictionary *) updateDeviceToken:(NSString *)deviceToken
                             forUser:(NSString *)userid{
    NSString *requestURL = [self generateFullUrl:action_update_device_token];
    
    NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:
                          deviceToken, @"device_token",
                          userid, @"user_id",
                          nil];
    
    NSDictionary *jsonResponse = [self makeSynchronousPostRequestWithURL:requestURL args:args];
    
    return jsonResponse;
}

@end
