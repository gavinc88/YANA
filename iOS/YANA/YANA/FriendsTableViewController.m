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

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

static NSString * const addFriendCellIdentifier = @"addFriendCell";
static NSString * const inviteFriendCellIdentifier = @"inviteFriendCell";

APIHelper *apiHelper;

#pragma mark - Segue

- (IBAction)unwindFromSearchAndAddFriend:(UIStoryboardSegue *)segue
{
    SearchAndAddFriendViewController *source = [segue sourceViewController];
    if ([source.addedFriends count]) {
        [self sorthFriends];
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue for %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"openSearchAndAddFriend"]) {
        SearchAndAddFriendNavigationController *destViewController = segue.destinationViewController;
        // Hide bottom tab bar in the detail view
        destViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    [self initializeFriends];
    //[self initializeMockFriends];
    apiHelper = [[APIHelper alloc] init];
    self.tableView.rowHeight = 44;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
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
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
}

- (void)initializeMockUser{
    self.user = [[User alloc] initWithUserid:@"userid" username:@"Gavin"];
}

- (void)initializeFriends{
    self.friendsWhoAddedYou = [[NSMutableArray alloc] init];
    self.allFriends = self.user.friends;
    
    [self sorthFriends];
    
    [self saveFriends];
}

- (void)initializeMockFriends{
    self.friendsWhoAddedYou = [[NSMutableArray alloc] init];
    Friend *newf1 = [[Friend alloc] initWithid:@"123" andUsername:@"Shane Wong 2"];
    Friend *newf2 = [[Friend alloc] initWithid:@"456" andUsername:@"Kevin Hsieh 2"];
    Friend *newf3 = [[Friend alloc] initWithid:@"789" andUsername:@"Yaohui Ye 2"];
    [self.friendsWhoAddedYou addObject:newf1];
    [self.friendsWhoAddedYou addObject:newf2];
    [self.friendsWhoAddedYou addObject:newf3];
    
    self.allFriends = [[NSMutableArray alloc] init];
    Friend *f1 = [[Friend alloc] initWithid:@"1" andUsername:@"Shane Wong"];
    Friend *f2 = [[Friend alloc] initWithid:@"2" andUsername:@"Kevin Hsieh"];
    Friend *f3 = [[Friend alloc] initWithid:@"3" andUsername:@"Yaohui Ye"];
    [self.allFriends addObject:f1];
    [self.allFriends addObject:f2];
    [self.allFriends addObject:f3];
    
    [self sorthFriends];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return [self.friendsWhoAddedYou count];
    else if(section == 1)
        return [self.allFriends count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        if([self.friendsWhoAddedYou count]){
            return @"Who Added You";
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
    if (indexPath.section == 0){
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellIdentifier forIndexPath:indexPath];
        
        Friend *friend = self.friendsWhoAddedYou[indexPath.row];
        
        [cell.friendUsername setText:friend.friendUsername];
        
        cell.addButton.tag = indexPath.row;
        [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        InviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteFriendCellIdentifier forIndexPath:indexPath];
        
        Friend *friend = self.allFriends[indexPath.row];
        
        [cell.friendUsername setText:friend.friendUsername];
        
        cell.inviteButton.tag = indexPath.row;
        [cell.inviteButton addTarget:self action:@selector(inviteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
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
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.allFriends removeObject:friend];
                deleted = NO;
            }
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Actions

- (void)sorthFriends{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername"
                                                 ascending:YES];
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
    NSLog(@"add clicked");
    NSLog(@"current Row=%d", sender.tag);
    
    Friend *friend = self.friendsWhoAddedYou[sender.tag];
    
    //update server
    NSDictionary *response = [apiHelper addFriend:friend.friendid toYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            [self.friendsWhoAddedYou removeObject:friend];
            [self.allFriends addObject:friend];
            [self.user.friends addObject:friend];
            
            //resort all friends before reload
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [self.allFriends sortedArrayUsingDescriptors:sortDescriptors];
            [self.allFriends removeAllObjects];
            [self.allFriends addObjectsFromArray:sortedArray];
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
    NSLog(@"invite clicked");
    NSLog(@"current Row=%d",sender.tag);
    //Friend *friend = self.friendsWhoAddedYou[sender.tag];
    [self.tableView reloadData];
}

- (void)deleteFriend:(Friend *)friend {
    NSLog(@"delete clicked");
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
