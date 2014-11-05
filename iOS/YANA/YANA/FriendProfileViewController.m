//
//  FriendProfileViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/5/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "APIHelper.h"

@interface FriendProfileViewController ()

//properties for profile viewed
@property (nonatomic, weak) NSString *username;
@property (nonatomic, weak) NSString *about;
@property (nonatomic, weak) NSString *age;
@property (nonatomic, weak) NSString *foodPreferences;
@property (nonatomic, weak) NSString *gender;
@property (nonatomic, weak) NSString *phoneNumber;

@property (nonatomic) BOOL isFriend;

@end

@implementation FriendProfileViewController

APIHelper *apiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    [self getProfileInfo];
    [self addToolbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProfileInfo {
    NSDictionary *response = [apiHelper getProfile:self.userid targetid:self.targetid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            int follow = [[response objectForKey:@"follow"] intValue];
            self.isFriend = follow == 1 ? YES : NO;
            
            NSDictionary *profile = [response objectForKey:@"profile"];
            self.username = [profile objectForKey:@"username"];
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

- (void)addToolbar {
    NSArray *toolbarItems;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if(self.isFriend){
        UIBarButtonItem *inviteItem = [[UIBarButtonItem alloc]initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteClicked:)];
        UIBarButtonItem *removeItem = [[UIBarButtonItem alloc]initWithTitle:@"Remove" style:UIBarButtonItemStyleBordered target:self action:@selector(removeClicked:)];
        toolbarItems = [NSArray arrayWithObjects:inviteItem, spaceItem, removeItem, nil];
    }else{
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addClicked:)];
        toolbarItems = [NSArray arrayWithObjects:spaceItem, addItem, spaceItem, nil];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,screenHeight-44,320,44)];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setItems:toolbarItems];
    [self.view addSubview:toolbar];
}

- (IBAction)inviteClicked:(id)sender {
    NSLog(@"Invite Selected");
}

- (IBAction)removeClicked:(id)sender {
    NSLog(@"Remove Selected");
}

- (IBAction)addClicked:(id)sender {
    NSLog(@"Remove Selected");
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
