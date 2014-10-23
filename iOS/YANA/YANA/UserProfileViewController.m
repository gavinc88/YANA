//
//  UserProfileViewController.m
//  YANA
//
//  Created by Shane on 10/23/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "UserProfileViewController.h"
#import "APIHelper.h"
#import "AppDelegate.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    APIHelper *helper = [[APIHelper alloc] init];
    [self initializeUser];
    NSDictionary *response = [helper getUserById:self.user.userid];
    NSLog(@"user info is %@", response);
    self.userInfo.text = [NSString stringWithFormat:@"My profile: %@", response];
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Hide main tab bar
-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"backToLoginPage"]){
        APIHelper *helper = [[APIHelper alloc] init];
        NSDictionary *response = [helper logout:self.user.userid];
        NSLog(@"Logout response is %@", response);
    }
}


@end
