//
//  SearchAndAddFriendViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "SearchAndAddFriendViewController.h"

@interface SearchAndAddFriendViewController ()

@end

@implementation SearchAndAddFriendViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Search

- (void) searchFriend{
    
}

#pragma mark - Add
- (IBAction)addFriend:(UIButton *)sender {
    NSLog(@"add friend");
    self.addedFriend = [[Friend alloc] initWithid:@"friendid" andUsername:@"Added Friend"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
