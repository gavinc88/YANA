//
//  FriendProfileViewController.h
//  YANA
//
//  Created by Gavin Chu on 11/5/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendProfileViewController : UIViewController

@property (nonatomic, strong) NSString* userid; //id of logged in user
@property (nonatomic, strong) NSString* targetid; //id of profile viewed

@end
