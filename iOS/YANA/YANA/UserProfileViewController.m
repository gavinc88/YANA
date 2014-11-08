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
    [self hideTextField];
    self.ageBox.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneNumberBox.keyboardType = UIKeyboardTypeDecimalPad;
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect visibleRect;
    visibleRect.origin = self.scrollView.contentOffset;
    visibleRect.size = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(visibleRect.size.width, visibleRect.size.height+40);
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void) hideTextField {
    self.aboutBox.hidden = YES;
    self.ageBox.hidden = YES;
    self.foodPreferencesBox.hidden = YES;
    self.genderBox.hidden = YES;
    self.phoneNumberBox.hidden = YES;
}

- (void) showTextField {
    self.aboutBox.hidden = NO;
    self.ageBox.hidden = NO;
    self.foodPreferencesBox.hidden = NO;
    self.genderBox.hidden = NO;
    self.phoneNumberBox.hidden = NO;
}

- (void) resetTextField {
    self.aboutBox.text = nil;
    self.ageBox.text = nil;
    self.foodPreferencesBox.text = nil;
    self.genderBox.text = nil;
    self.phoneNumberBox.text = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UI touched");
    [self.view endEditing:YES];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
        
        if([helper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:helper.SUCCESS]){
            

            NSDictionary *profile = [response objectForKey:@"profile"];
            self.username = [response objectForKey:@"username"];
            NSLog(@"dict:%@ \n username: %@",profile,self.username);
            self.about = [profile objectForKey:@"about"];
            self.age = [NSString stringWithFormat:@"%@",[profile objectForKey:@"age"]];
            self.foodPreferences = [profile objectForKey:@"food_preferences"];
            self.gender = [profile objectForKey:@"gender"];
            self.phoneNumber = [profile objectForKey:@"phone_number"];
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
    self.usernameLabel.text = self.username ? self.username : self.user.username;
    if ([self.about isEqualToString:@""]) {
        self.aboutLabel.text = @"(none)";
    } else self.aboutLabel.text = self.about;
    self.aboutLabel.text = self.about ? self.about : @"(none)";
    self.genderLabel.text = self.gender ? self.gender : @"(not specified)";
    self.ageLabel.text = [NSString stringWithFormat:@"%@",self.age]? : @"(not specified)";
    self.foodPreferencesLabel.text = self.foodPreferences ? self.foodPreferences : @"(not specified)";
    self.phoneNumberLabel.text = self.phoneNumber ? self.phoneNumber : @"(not specified)";
}



- (void)updateProfile {
    APIHelper *helper = [[APIHelper alloc] init];
    NSDictionary *response = [helper editProfile:self.user.userid withPrivacy:[NSNumber numberWithInt:[self.privacy intValue]]  about:self.about gender:self.gender age:self.age foodPreferences:self.foodPreferences phoneNumber:self.phoneNumber];
    NSLog(@"edit_profile response is %@", response);
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
    [self showTextField];
    self.aboutBox.placeholder = self.aboutLabel.text;
    self.ageBox.placeholder = self.ageLabel.text;
    self.genderBox.placeholder = self.genderLabel.text;
    self.phoneNumberBox.placeholder = self.phoneNumberLabel.text;
    self.foodPreferencesBox.placeholder = self.foodPreferencesLabel.text;
    
}

- (IBAction)updateButtonClicked:(id)sender {
//    [self validateInput];
    if (![self.aboutBox.text isEqualToString:@""]) {
        self.about = self.aboutBox.text;
    } else {
        self.about = nil;
    }
    if (![self.ageBox.text isEqualToString:@""]) {
        self.age = [NSNumber numberWithInt:[self.ageBox.text intValue]];
    } else {
        self.age = nil;
    }
    if (![self.genderBox.text isEqualToString:@""]) {
        self.gender = self.genderBox.text;
    } else {
        self.gender = nil;
    }
    if (![self.foodPreferencesBox.text isEqualToString:@""]) {
        self.foodPreferences = self.foodPreferencesBox.text;
    } else {
        self.foodPreferences = nil;
    }
    if (![self.phoneNumberBox.text isEqualToString:@""]) {
        self.phoneNumber = self.phoneNumberBox.text;
    } else {
        self.phoneNumber = nil;
    }
    [self updateProfile];
    [self getProfileInfo];
    [self displayProfileInfo];
    [self hideTextField];
}

- (IBAction)segmentedControllerValueChanged:(id)sender {
    self.privacy = [NSString stringWithFormat:@"%ld",(long)self.segmentedController.selectedSegmentIndex];
}

@end
