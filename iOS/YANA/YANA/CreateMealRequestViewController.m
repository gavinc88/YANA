//
//  CreateMealRequestViewController.m
//  YANA
//
//  Created by Shane on 10/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "CreateMealRequestViewController.h"
#import "InviteFriendsTableViewController.h"

@interface CreateMealRequestViewController ()

@end

@implementation CreateMealRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CreateMealRequestView loaded");
    // Do any additional setup after loading the view.
    self.time = [NSDate date];
}

/* Pass the MealRequest Object to InviteFriendsViewController */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inviteFriendsButton"]){
        InviteFriendsTableViewController *controller = segue.destinationViewController;
        controller.mealRequest = self.mealRequest;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    if (self.typeButtons.selectedSegmentIndex == 3) {
        [self.timePicker setDate: [NSDate date]];
    }
}

@end
