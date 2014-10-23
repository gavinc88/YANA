//
//  UserProfileViewController.h
//  YANA
//
//  Created by Shane on 10/23/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *userInfo;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) User *user;

@end
