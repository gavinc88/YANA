//
//  MealRequest.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MealRequest.h"

@interface MealRequest ()

@end

@implementation MealRequest

//used by CreateMealRequestViewController
- (instancetype) initWithUserid:(NSString *)ownerid
                           type:(NSString *)type
                           time:(NSDate *)time
                       location:(NSString *)location
                        comment:(NSString *)comment {
    self = [super init];
    if(self){
        self.ownerid = ownerid;
        self.type= type;
        self.time = time;
        self.location = location;
        self.comment = comment;
    }
    return self;
}

//used by InviteFriendsViewController
- (void) addInvitedFriends:(NSMutableArray *)friends {
    self.invitedFriends = friends;
}

//MealRequestsTableViewController
- (instancetype) initForSelfWithRequestId:(NSString *)requestid
                                ownername:(NSString *)ownerUsername
                                     type:(NSString *)type
                                     time:(NSDate *)time
                                 location:(NSString *)location
                                   status:(NSString *)status
                                  comment:(NSString *)comment {
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerUsername= ownerUsername;
        self.type = type;
        self.time = time;
        self.location = location;
        self.isSelf = YES;
        self.status = status;
        if(self.status){
            self.matched = YES;
        }else{
            self.matched = NO;
        }
        self.comment = comment;
    }
    return self;
}
- (instancetype) initForOthersWithRequestId:(NSString *)requestid
                                  ownername:(NSString *)ownerUsername
                                       type:(NSString *)type
                                       time:(NSDate *)time
                                   location:(NSString *)location
                                     status:(NSString *)status
                                  responded:(BOOL)responded
                                   accepted:(BOOL)accepted
                                    comment:(NSString *)comment{
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerUsername= ownerUsername;
        self.type = type;
        self.time = time;
        self.location = location;
        self.isSelf = NO;
        self.status = status;
        if(self.status){
            self.matched = YES;
        }else{
            self.matched = NO;
        }
        self.responded = responded;
        self.accepted = accepted;
        self.comment = comment;
    }
    return self;
}

@end
