//
//  RestaurantSearchViewController.h
//  YANA
//
//  Created by Shane on 11/2/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *restaurantSearchBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *restaurants;

@end
