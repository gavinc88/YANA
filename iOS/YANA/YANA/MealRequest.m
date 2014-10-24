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
                     restaurant:(NSString *)restaurant
                        comment:(NSString *)comment {
    self = [super init];
    if(self){
        self.ownerid = ownerid;
        self.type= type;
        self.time = time;
        self.restaurant = restaurant;
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
                                  ownerid:(NSString *)ownerid
                                ownername:(NSString *)ownerUsername
                                     type:(NSString *)type
                                     time:(NSDate *)time
                               restaurant:(NSString *)restaurant
                             acceptedUser:(NSString *)acceptedUser
                                  comment:(NSString *)comment {
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerUsername= ownerUsername;
        self.type = type;
        self.time = time;
        self.restaurant = restaurant;
        self.isSelf = YES;
        self.acceptedUser = acceptedUser;
        if(![self.acceptedUser isEqualToString:@""]){
            self.matched = YES;
        }else{
            self.matched = NO;
        }
        self.comment = comment;
    }
    return self;
}
- (instancetype) initForOthersWithRequestId:(NSString *)requestid
                                    ownerid:(NSString *)ownerid
                                  ownername:(NSString *)ownerUsername
                                       type:(NSString *)type
                                       time:(NSDate *)time
                                 restaurant:(NSString *)restaurant
                               acceptedUser:(NSString *)acceptedUser
                              declinedUsers:(NSArray *)declinedUsers
                                  responded:(BOOL)responded
                                   accepted:(BOOL)accepted
                                    comment:(NSString *)comment{
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerUsername = ownerUsername;
        self.type = type;
        self.time = time;
        self.restaurant = restaurant;
        self.isSelf = NO;
        self.acceptedUser = acceptedUser;
        if(![self.acceptedUser isEqualToString:@""]){
            self.matched = YES;
        }else{
            self.matched = NO;
        }
        self.declinedUsers = declinedUsers;
        self.responded = responded;
        self.accepted = accepted;
        self.comment = comment;
    }
    return self;
}

- (void) toString{
    NSLog(@"Meal Request Object:  \n\trequestid: %@  \n\towner: %@ \n\ttype: %@  \n\trestaurant: %@ \n\t acceptedUser: %@",
          self.requestid, self.ownerid, self.type, self.restaurant, self.acceptedUser);
}

@end
