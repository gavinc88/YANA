//
//  MainViewController.m
//  warmup2
//
//  Created by Gavin Chu on 9/27/14.
//  Copyright (c) 2014 cs169. All rights reserved.
//

#import "LoginViewController.h"
#import "APIHelper.h"
#import "User.h"
#import "MainTabBarController.h"

@interface LoginViewController ()

@property (nonatomic,weak) User *user;

@end

@implementation LoginViewController

APIHelper *apiHelper;

- (void)viewDidLoad
{
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(UIButton *)sender {
    NSDictionary *response = [apiHelper loginWithUsername:self.usernameText.text andPassword:self.passwordText.text];
    if(response){
        [self performSegueWithIdentifier:@"openMain" sender:self];
    }
}

- (IBAction)createUser:(UIButton *)sender {
    NSDictionary *response = [apiHelper createUserWithUsername:self.usernameText.text andPassword:self.passwordText.text];
    if(response){
        [self performSegueWithIdentifier:@"openMain" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"openMain"]) {
        NSLog(@"preparingForSegue");
        
        MainTabBarController *vc = [segue destinationViewController];
        vc.user = self.user;
    } else {
        return;
    }
}

- (IBAction)textFieldDidEnd:(id)sender {
    if ([sender isEqual: self.usernameText]){
        if ([self.usernameText.text length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Username"
                                        message:@"Username cannot be empty."
                                        delegate:nil
                                  cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
