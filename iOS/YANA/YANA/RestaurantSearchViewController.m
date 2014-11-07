//
//  RestaurantSearchViewController.m
//  YANA
//
//  Created by Shane on 11/2/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "RestaurantSearchViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "OAMutableURLRequest.h"
#import "InviteFriendsTableViewController.h"
#import "CreateMealRequestViewController.h"

@interface RestaurantSearchViewController ()

@end

@implementation RestaurantSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    self.restaurants = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// initialize User
- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
    self.searchTerm = searchBar.text;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self.restaurants removeAllObjects];
    [self searchRestaurant];
}

- (void)searchRestaurant {
    NSLog(@"search restaurant....");
    NSLog(@"searchTerm is %@", self.searchTerm);
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=%@&location=berkeley",self.searchTerm];
    NSLog(@"urlString is %@", urlString);
    NSURL *URL = [NSURL URLWithString:urlString];
    //customer key and secret provided by Yelp
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"82yR04gPM2XKnQ_hAHEs6A" secret:@"8UqXa3N64AXvQFaj6ki3SUXzQKY"];
    //token and secret provided by yelp
    OAToken *token = [[OAToken alloc] initWithKey:@"-8H9NbueOkM2fugXfeW9L9HCLSWCQ4Ti" secret:@"UAEOWnFHtfUjMJbAQZBAsgpwHFU"] ;
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init] ;
    NSString *realm = nil;
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [requestReply dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    
    NSMutableArray *venueList = [JSON objectForKey:@"businesses"];
    
    for (int i = 0; i < [venueList count] ; i++) {
        [self.restaurants addObject:[[JSON objectForKey:@"businesses"][i] objectForKey:@"name"]];
    }
    [self.tableView reloadData];
    NSLog(@"Restaurants are %@", self.restaurants);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.restaurants count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.restaurants objectAtIndex:indexPath.row];
    
    if ([self.selectedRestaurant isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedRestaurant = [self.restaurants objectAtIndex:indexPath.row];
    NSLog(@"selected restaurant is %@", self.selectedRestaurant);
    [self.tableView reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inviteFriendsButton"]){
        NSLog(@"Preparing for segue to InviteFriendsViewController");
        
        //Create MealRequest object
        self.mealRequest = [self prepareMealRequest];
        
        //pass MealRequest object to InviteFriendViewController
        InviteFriendsTableViewController *controller = segue.destinationViewController;
        controller.mealRequest = self.mealRequest;
        
        [controller.mealRequest toString];
    }
    
}

- (MealRequest *)prepareMealRequest {
    return[[MealRequest alloc] initWithUserid:self.user.userid username:self.user.username type:self.type time:self.time restaurant:self.selectedRestaurant comment:nil];
}

#import "CreateMealRequestViewController.h"
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        NSLog(@"Back pressed");
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.selectedRestaurant = self.selectedRestaurant;
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
