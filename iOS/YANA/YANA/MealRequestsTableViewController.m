//
//  MealRequestsTableViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MealRequestsTableViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "MealRequest.h"
#import "MealRequestWithButtonsTableViewCell.h"
#import "MealRequestWithoutButtonsTableViewCell.h"
#import "CreateMealRequestViewController.h"
#import "UserProfileViewController.h"
#import "InviteFriendsTableViewController.h"

@interface MealRequestsTableViewController ()

@end

@implementation MealRequestsTableViewController

static NSString * const requestWithButtonsCellIdentifier = @"requestWithButtons";
static NSString * const requestWithoutButtonsCellIdentifier = @"requestWithoutButtons";

NSDateFormatter *timeFormatter;

APIHelper *apiHelper;

#pragma mark - Segue

- (IBAction)unwindFromCreateMealRequest:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"exitFromInviteFriends"]) {
        NSLog(@"returned from InviteFriends");
        InviteFriendsTableViewController *source = [segue sourceViewController];
        if (source.mealRequestCreated && source.mealRequest) {
            //[source.mealRequest toString];
            [self.mealRequestsFromSelf addObject:source.mealRequest];
            [self.tableView reloadData];
        }else{
            NSLog(@"meal request is null");
        }
    }else if([segue.identifier isEqualToString:@"exitFromCreateMealRequest"]) {
        NSLog(@"returned from CreateMealRequest");
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue for %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"openCreateMealRequest"]) {
        CreateMealRequestViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    } else if([segue.identifier isEqualToString:@"openUserProfile"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc]init];
    [self initializeTimeFormatter];
    [self initializeUser];
    [self initializeMealRequests];
    //[self initializeMockMealRequests];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeTimeFormatter{
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
}

- (void)initializeUser{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
}

- (void)initializeMockUser{
    self.user = [[User alloc] initWithUserid:@"userid" username:@"Gavin"];
}

- (void)initializeMealRequests{
    self.mealRequestsFromSelf = [[NSMutableArray alloc] init];
    self.mealRequestsFromOthers = [[NSMutableArray alloc] init];
    
    for (MealRequest *mealRequest in self.user.mealRequests){
        if(mealRequest.isSelf){
            [self.mealRequestsFromSelf addObject:mealRequest];
        }else{
            [self.mealRequestsFromOthers addObject:mealRequest];
        }
    }
}

- (void)initializeMockMealRequests{
    self.mealRequestsFromSelf = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempNSMutableArray = [[NSMutableArray alloc] init];
    
    MealRequest *r1 = [[MealRequest alloc]initForSelfWithRequestId:@"requestid" ownerid:self.user.userid ownername:@"Gavin" type:@"Lunch" time:@"1:00 PM"restaurant:@"Restaurant A" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray];
    [self.mealRequestsFromSelf addObject:r1];
    
    MealRequest *r2 = [[MealRequest alloc]initForSelfWithRequestId:@"requestid" ownerid:self.user.userid ownername:@"Gavin" type:@"Dinner" time:@"7:30 PM"restaurant:@"Restaurant B" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray];
    [self.mealRequestsFromSelf addObject:r2];
    
    
    self.mealRequestsFromOthers = [[NSMutableArray alloc] init];
    
    MealRequest *r3 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Kevin" type:@"Dinner" time:@"6:00 PM" restaurant:@"Restaurant C" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray selfId:self.user.userid];
    [self.mealRequestsFromOthers addObject:r3]; //show buttons
    
    MealRequest *r4 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Shane" type:@"Other" time:@"6:30 PM" restaurant:@"Restaurant D" comment:@"latenight" acceptedUser:self.user.userid declinedUsers:tempNSMutableArray selfId:self.user.userid];
    [self.mealRequestsFromOthers addObject:r4];// show accepted
    
    NSMutableArray *declinedUsers = [[NSMutableArray alloc] init];
    [declinedUsers addObject:self.user.userid];
    MealRequest *r5 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Kevin" type:@"Lunch" time:@"1:30 PM" restaurant:@"Restaurant E" comment:nil acceptedUser:@"" declinedUsers:declinedUsers selfId:self.user.userid];
    [self.mealRequestsFromOthers addObject:r5]; //show declined
    
    MealRequest *r6 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Yaohui" type:@"Dinner" time:@"7:00 PM" restaurant:@"Restaurant F" comment:nil acceptedUser:@"someone's id" declinedUsers:tempNSMutableArray selfId:self.user.userid];
    [self.mealRequestsFromOthers addObject:r6]; //show someone else accepted it; check by checking if accepted_friends = nil
    
    MealRequest *r7 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Kevin" type:@"Dinner" time:@"8:30 AM" restaurant:@"Restaurant G" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray selfId:self.user.userid];
    [self.mealRequestsFromOthers addObject:r7]; //test accept
    
    MealRequest *r8 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Kevin" type:@"Dinner" time:@"11:00 PM" restaurant:@"Restaurant H" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray selfId:self.user.userid];
    [self.mealRequestsFromOthers addObject:r8]; //test decline
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return [self.mealRequestsFromSelf count];
    else if(section == 1)
        return [self.mealRequestsFromOthers count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if([self.mealRequestsFromSelf count]){
            return @"Your Requests";
        }else{
            return nil;
        }
    }

    if(section == 1){
        if([self.mealRequestsFromOthers count]){
            return @"Requests From Others";
        }else{
            return nil;
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) { //self requests
        MealRequest *request = self.mealRequestsFromSelf[indexPath.row];
        MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
        NSString *title = [self constructTitleForSelf:request];
        NSString *message = [self constructMessageForSelf:request];
        [cell.mealLabel setText:title];
        [cell.messageLabel setText:message];
        return cell;
    } else { //other requests
        MealRequest *request = self.mealRequestsFromOthers[indexPath.row];
        
        if (request.matched) {
            if ([self.user.userid isEqualToString:request.acceptedUser]){
                MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                NSString *message = @"You have accepted this request.";
                [cell.mealLabel setText:title];
                [cell.messageLabel setText:message];
                return cell;
            } else {
                MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                NSString *message = @"Someone else accepted this request.";
                [cell.mealLabel setText:title];
                [cell.messageLabel setText:message];
                return cell;
            }
        } else {
            if(request.responded){
                if(request.accepted){
                    MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                    NSString *title = [self constructTitleForOther:request];
                    NSString *message = @"You have accepted this request.";
                    [cell.mealLabel setText:title];
                    [cell.messageLabel setText:message];
                    return cell;
                }else{
                    MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                    NSString *title = [self constructTitleForOther:request];
                    NSString *message = @"You have declined this request.";
                    [cell.mealLabel setText:title];
                    [cell.messageLabel setText:message];
                    return cell;
                }
            }else{
                MealRequestWithButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                [cell.mealLabel setText:title];
                cell.acceptButton.tag = indexPath.row;
                cell.declineButon.tag = indexPath.row;
                [cell.acceptButton addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.declineButon addTarget:self action:@selector(declineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    }
}

- (NSString *)constructTitleForSelf:(MealRequest *)request{
    return [NSString stringWithFormat:@"Requested %@ at %@\n%@",
            request.type,
            request.time,
            ([request.restaurant isEqualToString:@""] || !request.restaurant) ? @"(Location TBD)" : [NSString stringWithFormat:@"@ %@", request.restaurant]];
}

- (NSString *)constructMessageForSelf:(MealRequest *)request{
    if (request.matched){
        NSString *friendName = [self getUsernameByid:request.acceptedUser];
        return [NSString stringWithFormat:@"%@ accepted your request!", friendName];
    }else{
        return @"Waiting for response.";
    }
}

- (NSString *)constructTitleForOther:(MealRequest *)request{
    return [NSString stringWithFormat:@"%@: %@ at %@\n%@ ",
            request.ownerUsername,
            request.type,
            request.time,
            ([request.restaurant isEqualToString:@""] || !request.restaurant) ? @"(Location TBD)" : [NSString stringWithFormat:@"@ %@", request.restaurant]];
}

- (NSString *)getUsernameByid:(NSString *)userid {
    
    NSDictionary *response = [apiHelper searchUserById:userid];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            return response[@"username"];
        }
    }
    return nil;
}

- (IBAction)acceptButtonClicked:(UIButton *)sender {
    NSLog(@"accept clicked");
    NSLog(@"current Row=%d", sender.tag);
    MealRequest *request = self.mealRequestsFromOthers[sender.tag];
    
    NSDictionary *response = [apiHelper handleMealRequestsForRequest:request.requestid WithAction:@"accept" ForUser:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            request.acceptedUser = self.user.userid;
            request.matched = YES;
            request.responded = YES;
            request.accepted = YES;
            [self.tableView reloadData];
            
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.MEAL_REQUEST_EXPIRED]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Request Expired"
                                  message:@"Sorry, someone else accepted this request before you."
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
    
    //delete after integration with live data
    request.acceptedUser = self.user.userid;
    request.matched = YES;
    request.responded = YES;
    request.accepted = YES;
    [self.tableView reloadData];
}

- (IBAction)declineButtonClicked:(UIButton *)sender {
    NSLog(@"decline clicked");
    NSLog(@"current Row=%d",sender.tag);
    MealRequest *request = self.mealRequestsFromOthers[sender.tag];
    
    NSDictionary *response = [apiHelper handleMealRequestsForRequest:request.requestid WithAction:@"decline" ForUser:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            request.responded = YES;
            request.accepted = NO;
            [self.tableView reloadData];
            
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.MEAL_REQUEST_EXPIRED]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Request Expired"
                                  message:@"Sorry, someone else accepted this request before you."
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

    //delete after integration with live data
    request.responded = YES;
    request.accepted = NO;
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
