//
//  InviteFriendsViewController.h
//  YANA
//
//  Created by Shane on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendsViewController.h"
#import "CreateMealRequestViewController.h"
#import "MealRequest.h"

@interface InviteFriendsViewController : UIViewController
@property(strong, nonatomic) MealRequest *mealRequest;
@end
