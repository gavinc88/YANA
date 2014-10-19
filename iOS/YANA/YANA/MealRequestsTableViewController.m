//
//  MealRequestsTableViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MealRequestsTableViewController.h"
#import "MealRequest.h"
#import "MealRequestWithButtonsTableViewCell.h"
#import "MealRequestWithoutButtonsTableViewCell.h"

@interface MealRequestsTableViewController ()

@end

@implementation MealRequestsTableViewController

static NSString * const requestWithButtonsCellIdentifier = @"requestWithButtons";
static NSString * const requestWithoutButtonsCellIdentifier = @"requestWithoutButtons";

NSDateFormatter *timeFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTimeFormatter];
    [self initializeMockUser];
    [self initializeMockMealRequests];
    
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

- (void)initializeMockUser{
    self.user = [[User alloc] initWithUserid:@"userid" username:@"Gavin"];
    
}

- (void)initializeMockMealRequests{
    self.mealRequestsFromSelf = [[NSMutableArray alloc] init];
    
    NSDate *t1 = [timeFormatter dateFromString:@"1:00 PM"];
    MealRequest *r1 = [[MealRequest alloc] initForSelfWithRequestId:@"1" ownername:self.user.username type:@"Lunch" time:t1 location:@"Restaurant A" status:@"accepted_id" comment:nil];
    [self.mealRequestsFromSelf addObject:r1];
    
    NSDate *t2 = [timeFormatter dateFromString:@"7:30 PM"];
    MealRequest *r2 = [[MealRequest alloc] initForSelfWithRequestId:@"2" ownername:self.user.username type:@"Dinner" time:t2 location:@"Restaurant B" status:nil comment:nil];
    [self.mealRequestsFromSelf addObject:r2];
    
    
    self.mealRequestsFromOthers = [[NSMutableArray alloc] init];
    NSDate *t3 = [timeFormatter dateFromString:@"6:00 PM"];
    MealRequest *r3 = [[MealRequest alloc] initForOthersWithRequestId:@"3" ownername:@"Kevin" type:@"Dinner" time:t3 location:@"Restaurant C" status:nil responded:NO accepted:nil comment:nil];
    [self.mealRequestsFromOthers addObject:r3]; //show buttons
    
    NSDate *t4 = [timeFormatter dateFromString:@"6:30 PM"];
    MealRequest *r4 = [[MealRequest alloc] initForOthersWithRequestId:@"4" ownername:@"Shane" type:@"Dinner" time:t4 location:@"Restaurant D" status:self.user.userid responded:YES accepted:YES comment:nil];
    [self.mealRequestsFromOthers addObject:r4];// show accepted
    
    NSDate *t5 = [timeFormatter dateFromString:@"7:00 PM"];
    MealRequest *r5 = [[MealRequest alloc] initForOthersWithRequestId:@"5" ownername:@"Yaohui" type:@"Dinner" time:t5 location:@"Restaurant E" status:nil responded:YES accepted:NO comment:nil];
    [self.mealRequestsFromOthers addObject:r5]; //show declined
    
    NSDate *t6 = [timeFormatter dateFromString:@"7:30 PM"];
    MealRequest *r6 = [[MealRequest alloc] initForOthersWithRequestId:@"6" ownername:@"George" type:@"Dinner" time:t6 location:@"Restaurant F" status:@"accepted_id" responded:nil accepted:nil comment:nil];
    [self.mealRequestsFromOthers addObject:r6]; //show someone else accepted it; check by checking if accepted_friends = nil
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
    
    if(section == 0)
        return @"Your Requests";
    if(section == 1)
        return @"Requests From Others";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        MealRequest *request = self.mealRequestsFromSelf[indexPath.row];
        MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
        NSString *title = [self constructTitleForSelf:request];
        NSString *message = [self constructMessageForSelf:request];
        [cell.mealLabel setText:title];
        [cell.messageLabel setText:message];
        return cell;
    } else {
        MealRequest *request = self.mealRequestsFromOthers[indexPath.row];
        if (request.matched) {
            if ([self.user.userid isEqualToString:request.status]){
                MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                NSString *message = @"You have accepted this request";
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
                MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                NSString *message = @"You have declined this request";
                [cell.mealLabel setText:title];
                [cell.messageLabel setText:message];
                return cell;
            }else{
                MealRequestWithButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                [cell.mealLabel setText:title];
                return cell;
            }
        }
    }
}

- (NSString *)constructTitleForSelf:(MealRequest *)request{
    return [NSString stringWithFormat:@"Requested %@ at %@\n%@",
            ([request.type isEqualToString:@"Other"] && request.comment) ? request.comment : request.type,
            [timeFormatter stringFromDate:request.time],
            request.location ? [NSString stringWithFormat:@"@ %@", request.location] : @"(Location TBD)"];
}

- (NSString *)constructMessageForSelf:(MealRequest *)request{
    if (request.matched){
        NSString *friendName = request.status;
        return [NSString stringWithFormat:@"%@ accepted your request!", friendName];
    }else{
        return @"Waiting for response.";
    }
}

- (NSString *)constructTitleForOther:(MealRequest *)request{
    return [NSString stringWithFormat:@"%@: %@ at %@\n%@ ",
            request.ownerUsername,
            ([request.type isEqualToString:@"Other"] && request.comment) ? request.comment : request.type,
            [timeFormatter stringFromDate:request.time],
            request.location ? [NSString stringWithFormat:@"@ %@", request.location] : @"(Location TBD)"];
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
