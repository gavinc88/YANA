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

NSDateFormatter *timeFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CreateMealRequestView loaded");
    [self initializeUser];
    [self initializeTimeFormatter];
    
    //set default type and time
    NSDate *currentTime = [NSDate date];
    [self.timePicker setDate: currentTime];
    self.time = [timeFormatter stringFromDate:[self.timePicker date]];
    self.type = @"other";
}

/* Pass the MealRequest Object to InviteFriendsViewController */
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
    NSString *time = [timeFormatter stringFromDate:[self.timePicker date]];
    return[[MealRequest alloc] initWithUserid:self.user.userid type:self.type time:time restaurant:self.restaurantTextBox.text comment:nil];
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

- (void)initializeTimeFormatter{
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
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
        self.time = [timeFormatter stringFromDate:date];
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
        self.time = [timeFormatter stringFromDate:date];
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
        self.time = [timeFormatter stringFromDate:date];
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
