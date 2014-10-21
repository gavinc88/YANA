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

@interface InviteFriendsTableViewController ()

@end

@implementation InviteFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeFakeFriends];
    self.tableView.rowHeight = 44;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"inviteFriendsToMealRequests"]){
        MealRequestsNavigationController *controller = segue.destinationViewController;
        
    }
}

- (void) initializeFakeFriends {
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
