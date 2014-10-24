//
//  InviteFriendsTableViewController.m
//  YANA
//
//  Created by Shane on 10/21/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "InviteFriendsTableViewController.h"
#import "Friend.h"
#import "MealRequestsNavigationController.h"
#import "APIHelper.h"
#import "AppDelegate.h"
#import "MealRequestsTableViewController.h"

@interface InviteFriendsTableViewController ()

@end

@implementation InviteFriendsTableViewController
APIHelper *apiHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mealRequestCreated = NO;
    apiHelper = [[APIHelper alloc] init];
    [self initializeUser];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self initializeFriends];
    
    self.tableView.rowHeight = 44;
    //check if mealRequest received from CreateMealRequestViewController
    NSLog(@"Mealrequest type is %@", self.mealRequest.type);
    NSLog(@"Mealrequest time is %@", self.mealRequest.time);
    NSLog(@"Mealrequest ownerid is %@", self.mealRequest.ownerid);
    NSLog(@"--------------------------");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepraring segue back to MealRequestsViewController");
    [self.mealRequest addInvitedFriends:self.selectedFriends];
    //check if friends are added to mealRequest
    NSLog(@"Mealrequest friends are %@", self.mealRequest.invitedFriends);
    NSDictionary *response = [apiHelper createMealRequest:self.mealRequest];
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            self.mealRequestCreated = YES;
        } else {
            NSLog(@"Bool mealRequestCreated is %@", (self.mealRequestCreated) ? @"YES" : @"NO");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSLog(@"Bool mealRequestCreated is %@", (self.mealRequestCreated) ? @"YES" : @"NO");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) initializeMockFriends {
    self.allFriends = [[NSMutableArray alloc] init];
    self.selectedFriends = [[NSMutableArray alloc] init];
    Friend *friend1 = [[Friend alloc] initWithid:@"1" andUsername:@"Shane Wang"];
    Friend *friend2 = [[Friend alloc] initWithid:@"2" andUsername:@"Gavin Chu"];
    Friend *friend3 = [[Friend alloc] initWithid:@"3" andUsername:@"Yaohui Ye"];
    Friend *friend4 = [[Friend alloc] initWithid:@"4" andUsername:@"Kevin Hsieh"];
    [self.allFriends addObject:friend1];
    [self.allFriends addObject:friend2];
    [self.allFriends addObject:friend3];
    [self.allFriends addObject:friend4];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername" ascending:YES];
    NSArray *nameDescriptors = @[nameDescriptor];
    NSArray *sortedFriendList = [self.allFriends sortedArrayUsingDescriptors:nameDescriptors];
    [self.allFriends removeAllObjects];
    [self.allFriends addObjectsFromArray:sortedFriendList];
    
}

- (void) initializeFriends {
    APIHelper *helper = [[APIHelper alloc] init];
    self.allFriends = [[NSMutableArray alloc] init];
    self.selectedFriends = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [helper getFriendList:self.user.userid];
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([helper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:helper.SUCCESS]){
            
            NSArray *friends = [response objectForKey:@"friends"];
            for(NSDictionary *friend in friends){
                Friend *f = [[Friend alloc] initWithid:friend[@"user_id"] andUsername:friend[@"user_name"]];
                [self.allFriends addObject:f];
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
    
    //prepare for sorting
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //sort
    NSArray *sortedArray;
    sortedArray = [self.allFriends sortedArrayUsingDescriptors:sortDescriptors];
    [self.allFriends removeAllObjects];
    [self.allFriends addObjectsFromArray:sortedArray];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    Friend *friend = [self.allFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.friendUsername;
    if (friend.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// User selects a friend
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Friend *selectedFriend = [self.allFriends objectAtIndex:indexPath.row];
    selectedFriend.selected = !selectedFriend.selected;
    if (selectedFriend.selected == YES) {
        //add friend to SelectedFriends array
        [self.selectedFriends addObject: selectedFriend];
        NSLog(@"selectedFriends are %@", self.selectedFriends);
    } else {
        //delete friend from SelectedFriends array
        [self.selectedFriends removeObject: selectedFriend];
        NSLog(@"selectedFriends are %@", self.selectedFriends);
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([self.selectedFriends count]){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
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
