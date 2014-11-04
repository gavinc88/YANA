//
//  MainViewController.m
//  warmup2
//
//  Created by Gavin Chu on 9/27/14.
//  Copyright (c) 2014 cs169. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "User.h"
#import "MainTabBarController.h"

@interface LoginViewController ()

@property (nonatomic, strong) User *user;

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
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        NSLog(@"statusCode: %d", statusCode);
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSString *userid = [response objectForKey:@"user_id"];
            self.user = [[User alloc] initWithUserid:userid username:self.usernameText.text];
            [self performSegueWithIdentifier:@"openMain" sender:self];
            
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.WRONG_USERNAME_OR_PASSWORD]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Credentials"
                                  message:@"Wrong username or password."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
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
                              initWithTitle:@"Server Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)createUser:(UIButton *)sender {
    NSDictionary *response = [apiHelper createUserWithUsername:self.usernameText.text andPassword:self.passwordText.text];
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            NSString *userid = [response objectForKey:@"user_id"];
            self.user = [[User alloc] initWithUserid:userid username:self.usernameText.text];
            [self performSegueWithIdentifier:@"openMain" sender:self];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.INVALID_USERNAME]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Username"
                                  message:@"Username is empty or it's too long."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.INVALID_PASSWORD]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Password"
                                  message:@"Password is too long."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.USERNAME_ALREADY_EXISTS]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Username"
                                  message:@"Username already exists"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
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
                              initWithTitle:@"Server Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"openMain"]) {
        NSLog(@"preparingForSegue for LoginViewController");
        AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ad.user = self.user;
        [self registerDeviceToken];
    } else {
        return;
    }
}

- (void)registerDeviceToken{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(ad.deviceToken){
        NSDictionary *response = [apiHelper updateDeviceToken:ad.deviceToken forUser:ad.user.userid];
        if(response){
            int statusCode = [[response objectForKey:@"errCode"] intValue];
            if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
                //do nothing
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
                                  initWithTitle:@"Server Error"
                                  message:@"Can't register device. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

//- (IBAction)textFieldDidEnd:(id)sender {
//    if ([sender isEqual: self.usernameText]){
//        if ([self.usernameText.text length] == 0) {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Invalid Username"
//                                        message:@"Username cannot be empty."
//                                        delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                otherButtonTitles:nil];
//            [alert show];
//        }
//    }
//}

@end
