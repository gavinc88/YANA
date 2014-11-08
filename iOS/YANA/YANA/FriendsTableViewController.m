//
//  FriendsTableViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "Friend.h"
#import "AddFriendTableViewCell.h"
#import "InviteFriendTableViewCell.h"
#import "SearchAndAddFriendNavigationController.h"
#import "SearchAndAddFriendViewController.h"
#import "UserProfileViewController.h"
#import "FriendProfileViewController.h"
#import "MealRequestsTableViewController.h"
#import "InviteFriendsTableViewController.h"
#import "MealRequestsNavigationController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

static NSString * const addFriendCellIdentifier = @"addFriendCell";
static NSString * const inviteFriendCellIdentifier = @"inviteFriendCell";

APIHelper *apiHelper;

#pragma mark - Segue

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateFriends];
}

- (IBAction)unwindFromSearchAndAddFriend:(UIStoryboardSegue *)segue {
    NSLog(@"unwindFromSearchAndAddFriend");
    [self refreshFriendList];
}

- (IBAction)unwindFromCreateMealRequest:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"exitFromInviteFriends"]) {
        //update meal request table view with new meal request
        InviteFriendsTableViewController *source = [segue sourceViewController];
        if (source.mealRequestCreated && source.mealRequest) {
            self.tabBarController.selectedIndex = 0;
            MealRequestsNavigationController *requestTab = [self.tabBarController.childViewControllers objectAtIndex:0];
            MealRequestsTableViewController *requestTabView = (MealRequestsTableViewController *)requestTab.topViewController;
            [requestTabView.mealRequestsFromSelf addObject:source.mealRequest];
            [requestTabView.tableView reloadData];
        }else{
            NSLog(@"meal request is null");
        }
    }else if([segue.identifier isEqualToString:@"exitFromCreateMealRequest"]) {
        self.tabBarController.selectedIndex = 0;
        //clear friend selection
        for(Friend *friend in self.user.friends){
            friend.selected = NO;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue for %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"openSearchAndAddFriend"]) {
        SearchAndAddFriendNavigationController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    }else if([segue.identifier isEqualToString:@"openUserProfile"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    }else if([segue.identifier isEqualToString:@"inviteToMealRequest"]) {
        
    }
}

#pragma mark - Setup

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    [self initializeUser];
    [self initializeFriends];
    
    apiHelper = [[APIHelper alloc] init];
    self.tableView.rowHeight = 44;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    //for testing purposes
    [self.tableView setIsAccessibilityElement:YES];
    [self.tableView setAccessibilityLabel:@"Friend List"];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshFriendList)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
}

- (void)initializeFriends{
    NSLog(@"initialize friends");
    self.friendsWhoAddedYou = self.user.friendsWhoAddedYou;
    self.allFriends = self.user.friends;
    [self sortFriends];
}

- (void)updateFriends{
    [self initializeUser];
    [self initializeFriends];
    [self.tableView reloadData];
}

- (void)refreshFriendList {
    [self getAllFriends];
    [self getFriendsWhoAddedYou];
    [self updateFriends];
    [self.refreshControl endRefreshing];
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
            [self saveFriends];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Get all friends failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Get all friends failed. Please check your internet connection or try again later."
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
            [self saveFriends];
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
                              message:@"Can't get friends who added you. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows in section");
    if ([self.allFriends count] || [self.friendsWhoAddedYou count]) {
        if(section == 0)
            return [self.friendsWhoAddedYou count];
        else if(section == 1)
            return [self.allFriends count];
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No friends found.\nPlease add friends by\npressing the \"+\" button.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        if([self.friendsWhoAddedYou count]){
            return @"Friends Who Added You";
        }else{
            return nil;
        }
    }
    if(section == 1){
        return @"All Friends";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellIdentifier forIndexPath:indexPath];
        
        Friend *friend = self.friendsWhoAddedYou[indexPath.row];
        
        [cell.friendUsername setText:friend.friendUsername];
        
        cell.addButton.tag = indexPath.row;
        [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //for testing purposes
        [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
        return cell;
    }else{
        InviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteFriendCellIdentifier forIndexPath:indexPath];
        
        Friend *friend = self.allFriends[indexPath.row];
        [cell.friendUsername setText:friend.friendUsername];
        
        cell.inviteButton.tag = indexPath.row;
        [cell.inviteButton addTarget:self action:@selector(inviteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //for testing purposes
        [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Friend *selectedFriend;
    if(indexPath.section == 0){
        selectedFriend = self.friendsWhoAddedYou[indexPath.row];
    }else{
        selectedFriend = self.allFriends[indexPath.row];
    }
    FriendProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
    if(selectedFriend){
        viewController.targetid = selectedFriend.friendid;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Can't open friend profile. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

BOOL deleted = NO;

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if(indexPath.section == 0){
            [self.friendsWhoAddedYou removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(indexPath.section == 1){
            Friend *friend = self.allFriends[indexPath.row];
            [self deleteFriend:friend];
            if(deleted){
                [self.allFriends removeObject:friend];
                deleted = NO;
            }
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Actions

- (void)sortFriends{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //sort alphabetically
    NSArray *sortedArray;
    sortedArray = [self.friendsWhoAddedYou sortedArrayUsingDescriptors:sortDescriptors];
    [self.friendsWhoAddedYou removeAllObjects];
    [self.friendsWhoAddedYou addObjectsFromArray:sortedArray];
    
    sortedArray = [self.allFriends sortedArrayUsingDescriptors:sortDescriptors];
    [self.allFriends removeAllObjects];
    [self.allFriends addObjectsFromArray:sortedArray];
}

- (IBAction)addButtonClicked:(UIButton *)sender {
    Friend *friend = self.friendsWhoAddedYou[sender.tag];
    
    //update server
    NSDictionary *response = [apiHelper addFriend:friend.friendid toYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
//            [self.friendsWhoAddedYou removeObject:friend];
//            [self.allFriends addObject:friend];
            [self.user.friendsWhoAddedYou removeObject:friend];
            [self.user.friends addObject:friend];
            
            //resort all friends before reload
//            NSSortDescriptor *sortDescriptor;
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername"
//                                                         ascending:YES];
//            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//            NSArray *sortedArray = [self.allFriends sortedArrayUsingDescriptors:sortDescriptors];
//            [self.allFriends removeAllObjects];
//            [self.allFriends addObjectsFromArray:sortedArray];
            [self.tableView reloadData];
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
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)inviteButtonClicked:(UIButton *)sender {
    Friend *friend = self.allFriends[sender.tag];
    friend.selected = YES;
}

- (void)deleteFriend:(Friend *)friend {
    //update server
    NSDictionary *response = [apiHelper deleteFriend:friend.friendid fromYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            deleted = YES;
            [self.user.friends removeObject:friend];
            [self.tableView reloadData];
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
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self saveFriends];
}

- (void) saveFriends{
    self.user.friends = self.allFriends;
    self.user.friendsWhoAddedYou = self.friendsWhoAddedYou;
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.user = self.user;
}

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
