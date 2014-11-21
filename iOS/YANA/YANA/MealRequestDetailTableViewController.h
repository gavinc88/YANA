//
//  MealRequestDetailTableViewController.h
//  YANA
//
//  Created by Shane on 11/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealRequestDetailTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *mealRequestOwnerLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@end
