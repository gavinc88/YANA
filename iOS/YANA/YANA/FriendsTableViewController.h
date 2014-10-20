//
//  FriendsTableViewController.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *allFriends;

@property (nonatomic, strong) NSMutableArray *friendsWhoAddedYou;

@property (nonatomic, strong) User *user;

@end
