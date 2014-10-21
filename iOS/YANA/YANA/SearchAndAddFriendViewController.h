//
//  SearchAndAddFriendViewController.h
//  YANA
//
//  Created by Gavin Chu on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface SearchAndAddFriendViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *friendSearchBar;
@property (weak, nonatomic) IBOutlet UILabel *friendSearchMessage;
@property (weak, nonatomic) IBOutlet UIButton *friendSearchButton;

@property (nonatomic, strong) Friend *addedFriend;

@end
