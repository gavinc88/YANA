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

@interface RestaurantSearchViewController ()

@end

@implementation RestaurantSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurants = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchRestaurant];
}

- (void)searchRestaurant {
    NSLog(@"search restaurant....");
    NSURL *URL = [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&location=berkeley"];
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
    NSLog(@"First restaurant is: %@", [[JSON objectForKey:@"businesses"][0] objectForKey:@"name"]);
    [self.restaurants addObject:[[JSON objectForKey:@"businesses"][0] objectForKey:@"name"]];
    NSLog(@"Second restaurant is: %@", [[JSON objectForKey:@"businesses"][1] objectForKey:@"name"]);
    [self.restaurants addObject:[[JSON objectForKey:@"businesses"][1] objectForKey:@"name"]];
    NSLog(@"Third restaurant is: %@", [[JSON objectForKey:@"businesses"][2] objectForKey:@"name"]);
    [self.restaurants addObject:[[JSON objectForKey:@"businesses"][2] objectForKey:@"name"]];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.restaurants objectAtIndex:indexPath.row];
    
    
    
    NSLog(@"tableview loaded");
    return cell;
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
