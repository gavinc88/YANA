//
//  MealRequest.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MealRequest : NSObject

//Variables for any MealRequest:
@property (nonatomic, strong) NSString *type; //breakfast, lunch, dinner, other
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *location; //optional

//Variables for create meal request:
@property (nonatomic, strong) NSString *ownerid; //userid of meal reqeust owner
@property (nonatomic, strong) NSString *comment; //only assigned if type == other
@property (nonatomic, strong) NSMutableArray *invitedFriends; //list of friend ids

//Variables for displaying meal request:
@property (nonatomic, strong) NSString *requestid; //meal request id from databae primary key
@property (nonatomic, strong) NSString *ownerUsername; //self or friend username for display purposes
@property (nonatomic, strong) NSString *status; //userid of friend who accepted the request; nil if no one accepted the request

@property (nonatomic) BOOL isSelf; //used to determine if the request is made by self or others

//bool used for self requests
@property (nonatomic) BOOL matched;

//bool used for others' requests
@property (nonatomic) BOOL responded; //used to display buttons or message
@property (nonatomic) BOOL accepted; //used to determine message

- (instancetype) initWithUserid:(NSString *)ownerid
                           type:(NSString *)type
                           time:(NSDate *)time
                       location:(NSString *)location
                        comment:(NSString *)comment;

- (void) addInvitedFriends:(NSMutableArray *)friends;

- (instancetype) initForSelfWithRequestId:(NSString *)requestid
                                ownername:(NSString *)ownerUsername
                                     type:(NSString *)type
                                     time:(NSDate *)time
                                 location:(NSString *)location
                                   status:(NSString *)status
                                  comment:(NSString *)comment;

- (instancetype) initForOthersWithRequestId:(NSString *)requestid
                                  ownername:(NSString *)    ownerUsername
                                       type:(NSString *)type
                                       time:(NSDate *)time
                                   location:(NSString *)location
                                     status:(NSString *)status
                                  responded:(BOOL)responded
                                   accepted:(BOOL)accepted
                                    comment:(NSString *)comment;

@end
