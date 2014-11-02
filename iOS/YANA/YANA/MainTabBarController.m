//
//  MainTabBarController.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MainTabBarController.h"
#import "APIHelper.h"
#import "AppDelegate.h"
#import "User.h"
#import "Friend.h"
#import "MealRequest.h"

@interface MainTabBarController ()

@property (nonatomic,strong) User *user;

@end

@implementation MainTabBarController

APIHelper *apiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    [self initializeUser];
    [self getAllRequests];
    [self getAllFriends];
    [self getFriendsWhoAddedYou];
    [self updateUser];
    [self.user toString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return [self.selectedViewController viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
    [self.user toString];
}

- (void)updateUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.user = self.user;
}

- (void)getAllRequests{
    self.user.mealRequests = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [apiHelper getAllMealRequests:self.user.userid];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSArray *requests = [response objectForKey:@"requests"];
            for(NSDictionary *request in requests){
                NSString *requestid = request[@"_id"];
                NSString *ownerid = request[@"owner_id"];
                //make separate request to get owner username
                NSString *ownerUsername = [self getOwnerUsername:ownerid];
                NSString *mealTime = request[@"meal_time"];
                NSString *mealType = request[@"meal_type"];
                NSString *restaurant = request[@"restaurant"];
                NSString *comment = request[@"comment"];
                NSString *acceptedUser = request[@"accepted_user"];
                NSMutableArray *declinedUsers = request[@"declined_users"];
                
                MealRequest *mealRequest = [[MealRequest alloc] initWithRequestId:requestid ownerid:ownerid ownername:ownerUsername type:mealType time:mealTime restaurant:restaurant comment:comment acceptedUser:acceptedUser declinedUsers:declinedUsers selfId:self.user.userid];
                [self.user.mealRequests addObject:mealRequest];
            }
        } else {
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

- (NSString *)getOwnerUsername:(NSString *)ownerid {
    
    NSDictionary *response = [apiHelper searchUserById:ownerid];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            return response[@"username"];
        }
    }
    return nil;
}

- (void)getAllFriends{
    self.user.friends = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [apiHelper getFriendList:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            NSArray *friends = [response objectForKey:@"friends"];
            for(NSDictionary *friend in friends){
                Friend *f = [[Friend alloc] initWithid:friend[@"to_id"] andUsername:friend[@"to_username"]];
                [self.user.friends addObject:f];
            }
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

- (void)getFriendsWhoAddedYou{
    self.user.friendsWhoAddedYou = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [apiHelper getFriendRequests:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            NSArray *friends = [response objectForKey:@"friends"];
            for(NSDictionary *friend in friends){
                Friend *f = [[Friend alloc] initWithid:friend[@"from_id"] andUsername:friend[@"from_username"]];
                [self.user.friendsWhoAddedYou addObject:f];
            }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
