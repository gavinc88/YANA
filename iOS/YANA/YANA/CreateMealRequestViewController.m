//
//  CreateMealRequestViewController.m
//  YANA
//
//  Created by Shane on 10/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "CreateMealRequestViewController.h"
#import "InviteFriendsTableViewController.h"
#import "AppDelegate.h"
#import "MealRequest.h"


@interface CreateMealRequestViewController ()

@end

@implementation CreateMealRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CreateMealRequestView loaded");
    // Do any additional setup after loading the view.
    self.time = [NSDate date];
    [self initializeUser];
    
    //set default type and time
    NSDate *currentTime = [NSDate date];
    [self.timePicker setDate: currentTime];
    self.time = currentTime;
    self.type = @"other";
}

/* Pass the MealRequest Object to InviteFriendsViewController */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inviteFriendsButton"]){
        NSLog(@"Preparing for segue to InviteFriendsViewController");

        InviteFriendsTableViewController *controller = segue.destinationViewController;
        //Create MealRequest object
        self.mealRequest = [[MealRequest alloc] initWithUserid:self.user.userid type:self.type time:self.time restaurant:self.restaurantTextBox.text comment:nil];
        
        //pass MealRequest object to InviteFriendViewController
        controller.mealRequest = self.mealRequest;
        [controller.mealRequest toString];
        
    }
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

- (IBAction)mealTypeSelected:(id)sender {
    NSLog(@"mealTypeSelected");
    NSLog(@"the meal type picked is number %li", (long)self.typeButtons.selectedSegmentIndex);
    
    /* Get current NSDate components */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDateComponents *currComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currDay = [currComponents day];
    NSInteger currMonth = [currComponents month];
    NSInteger currYear = [currComponents year];
    
    if (self.typeButtons.selectedSegmentIndex == 0) {
        [components setYear:currYear];
        [components setMonth:currMonth];
        [components setDay:currDay];
        [components setHour:9];
        [components setMinute:0];
        NSDate *date = [calendar dateFromComponents:components];
        [self.timePicker setDate: date];
        self.time = date;
        self.type = @"breakfast";
    }
    if (self.typeButtons.selectedSegmentIndex == 1) {
        [components setYear:currYear];
        [components setMonth:currMonth];
        [components setDay:currDay];
        [components setHour:12];
        [components setMinute:0];
        NSDate *date = [calendar dateFromComponents:components];
        [self.timePicker setDate: date];
        self.time = date;
        self.type = @"lunch";
    }
    if (self.typeButtons.selectedSegmentIndex == 2) {
        [components setYear:currYear];
        [components setMonth:currMonth];
        [components setDay:currDay];
        [components setHour:19];
        [components setMinute:0];
        NSDate *date = [calendar dateFromComponents:components];
        [self.timePicker setDate: date];
        self.time = date;
        self.type = @"dinner";
    }
    if (self.typeButtons.selectedSegmentIndex == 3) {
        [self.timePicker setDate: [NSDate date]];
        self.type = @"other";
    }
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [self.tabBarController.tabBar setHidden:YES];
}
@end
