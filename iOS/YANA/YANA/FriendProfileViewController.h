//
//  FriendProfileViewController.h
//  YANA
//
//  Created by Gavin Chu on 11/5/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Friend.h"

@interface FriendProfileViewController : UIViewController

@property (nonatomic, strong) NSString* targetid; //id of profile viewed
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Friend *currentFriend;
@property (nonatomic) BOOL removed;


@end
