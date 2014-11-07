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
#import "LoginViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
APIHelper *apiHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUser];
    //TODO: user response data instead
    [self getProfileInfo];
    [self displayProfileInfo];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"edit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(editButtonPressed:)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.usernameBox.hidden = YES;
    self.aboutBox.hidden = YES;
    self.ageBox.hidden = YES;
    self.foodPreferencesBox.hidden = YES;
    self.genderBox.hidden = YES;
    self.phoneNumberBox.hidden = YES;

}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"resizing scrollview");
    CGRect visibleRect;
    visibleRect.origin = self.scrollView.contentOffset;
    visibleRect.size = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(visibleRect.size.width, visibleRect.size.height);
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProfileInfo {
    APIHelper *helper = [[APIHelper alloc] init];
    NSDictionary *response = [helper getProfile:self.user.userid targetid:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            

            NSDictionary *profile = [response objectForKey:@"profile"];
            self.username = [profile objectForKey:@"username"];
            NSLog(@"dict:%@ \n username: %@",profile,self.username);
            self.about = [profile objectForKey:@"about"];
            self.age = [profile objectForKey:@"age"];
            self.foodPreferences = [profile objectForKey:@"foodPreferences"];
            self.gender = [profile objectForKey:@"gender"];
            self.phoneNumber = [profile objectForKey:@"phoneNumber"];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Get profile info failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)displayProfileInfo {
    self.usernameLabel.text = self.username ? self.username : @"(error)";
    self.aboutLabel.text = self.about ? self.about : @"(none)";
    self.genderLabel.text = self.gender ? self.gender : @"(not specified)";
    self.ageLabel.text = self.age ? self.age : @"(not specified)";
    self.foodPreferencesLabel.text = self.foodPreferences ? self.foodPreferences : @"(not specified)";
    self.phoneNumberLabel.text = self.phoneNumber ? self.phoneNumber : @"(not specified)";
}

- (void)updateProfile {
    APIHelper *helper = [[APIHelper alloc] init];
    NSDictionary *response = [helper editProfile:self.user.userid withPrivacy:[[NSNumber alloc] initWithInt:2]  about:self.aboutLabel.text gender:self.genderLabel.text age:self.ageLabel.text foodPreferences:self.foodPreferencesLabel.text phoneNumber:self.phoneNumberLabel.text];
    NSLog(@"response is %@", response);
}

- (IBAction)logoutClicked:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.user = nil;
    
    [self presentViewController:loginController
                       animated:YES
                     completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"backToLoginPage"]){
        APIHelper *helper = [[APIHelper alloc] init];
        NSDictionary *response = [helper logout:self.user.userid];
        NSLog(@"Logout response is %@", response);
    }
}

- (void)editButtonPressed:(id)sender
{
    self.usernameBox.hidden = NO;
    self.aboutBox.hidden = NO;
    self.ageBox.hidden = NO;
    self.foodPreferencesBox.hidden = NO;
    self.genderBox.hidden = NO;
    self.phoneNumberBox.hidden = NO;
}

- (IBAction)updateButtonClicked:(id)sender {
    [self updateProfile];
    [self getProfileInfo];
    [self displayProfileInfo];
    self.usernameBox.hidden = YES;
    self.aboutBox.hidden = YES;
    self.ageBox.hidden = YES;
    self.foodPreferencesBox.hidden = YES;
    self.genderBox.hidden = YES;
    self.phoneNumberBox.hidden = YES;
}
@end
