//
//  RestaurantSearchViewController.h
//  YANA
//
//  Created by Shane on 11/2/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealRequest.h"
#import "User.h"


@interface RestaurantSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *restaurantSearchBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *restaurants;

@property (nonatomic, strong) NSString *searchTerm;

@property (strong, nonatomic) NSString *selectedRestaurant;

@property (strong, nonatomic) MealRequest *mealRequest;

@property (nonatomic, strong) User *user;

@property (strong, nonatomic) NSString *time;

@property (strong, nonatomic) NSString *type;

@end
