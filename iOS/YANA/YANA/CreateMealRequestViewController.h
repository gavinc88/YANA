//
//  CreateMealRequestViewController.h
//  YANA
//
//  Created by Shane on 10/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "CreateMealRequestViewController.h"
#import "MealRequest.h"
#import <UIKit/UIKit.h>
#import "MealRequest.h"
#import "InviteFriendsViewController.h"
#import "User.h"

@interface CreateMealRequestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeButtons;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) IBOutlet UITextField *restaurantTextBox;
@property (strong, nonatomic) IBOutlet UIButton *inviteFriendsButton;
@property (strong, nonatomic) NSString *restaurant;
@property (strong, nonatomic) IBOutlet UITextField *locationTextBox;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) MealRequest *mealRequest;





@end
