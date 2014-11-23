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
#import "RestaurantSearchViewController.h"


@interface CreateMealRequestViewController ()

@end

@implementation CreateMealRequestViewController

NSDateFormatter *timeFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    [self initializeTimeFormatter];
    
    //set default type and time
    NSDate *currentTime = [NSDate date];
    [self.timePicker setDate: currentTime];
    self.time = [timeFormatter stringFromDate:[self.timePicker date]];
    self.type = @"other";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.restaurantTextBox setText:@""];
    appDelegate.selectedRestaurant = @"";
}

- (void) viewDidAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.restaurantTextBox setText:appDelegate.selectedRestaurant];
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
    if([segue.identifier isEqualToString:@"searchRestaurantButton"]){
        NSLog(@"Preparing for segue to RestaurantSearchViewController");
        RestaurantSearchViewController *controller = segue.destinationViewController;
        //pass time and type to RestaurantSearchViewController
        controller.time = self.time;
        controller.type = self.type;
    }

    
}

- (MealRequest *)prepareMealRequest {
    NSString *time = [timeFormatter stringFromDate:[self.timePicker date]];
    return[[MealRequest alloc] initWithUserid:self.user.userid username:self.user.username type:self.type time:time restaurant:self.restaurantTextBox.text comment:self.commentTextBox.text];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
