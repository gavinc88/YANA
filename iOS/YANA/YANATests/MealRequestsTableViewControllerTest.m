//
//  MealRequestsTableViewControllerTest.m
//  YANA
//
//  Created by Gavin Chu on 11/6/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MealRequestsTableViewController.h"
#import "MealRequestWithoutButtonsTableViewCell.h"
#import "MealRequestWithButtonsTableViewCell.h"
#import "User.h"
#import "MealRequest.h"


@interface MealRequestsTableViewControllerTest : XCTestCase

@property (nonatomic, strong) MealRequestsTableViewController *vc;

@end

@implementation MealRequestsTableViewControllerTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"MealRequestsTableViewController"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    self.vc.user = [[User alloc] initWithUserid:@"123" username:@"tester"];
    self.vc.mealRequestsFromSelf = [[NSMutableArray alloc] init];
    self.vc.mealRequestsFromOthers = [[NSMutableArray alloc] init];
}

- (void)tearDown {
    self.vc = nil;
    [super tearDown];
}

- (void)initializeMealRequestsFromSelf {
    NSMutableArray *tempNSMutableArray = [[NSMutableArray alloc] init];
    
    MealRequest *r1 = [[MealRequest alloc]initForSelfWithRequestId:@"requestid" ownerid:self.vc.user.userid ownername:self.vc.user.username type:@"Breakfast" time:@"9:00am" restaurant:@"Restaurant A" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray];
    [self.vc.mealRequestsFromSelf addObject:r1]; //request waiting for response
    
    MealRequest *r2 = [[MealRequest alloc]initForSelfWithRequestId:@"requestid" ownerid:self.vc.user.userid ownername:self.vc.user.username type:@"Lunch" time:@"12:30pm" restaurant:@"Restaurant B" comment:nil acceptedUser:@"friend" declinedUsers:tempNSMutableArray];
    [self.vc.mealRequestsFromSelf addObject:r2]; //request with response
}

- (void)initializeMealRequestsFromOthers {
    NSMutableArray *tempNSMutableArray = [[NSMutableArray alloc] init];
    
    MealRequest *r3 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Kevin" type:@"Dinner" time:@"6:00 PM" restaurant:@"Restaurant C" comment:nil acceptedUser:@"" declinedUsers:tempNSMutableArray selfId:self.vc.user.userid];
    [self.vc.mealRequestsFromOthers addObject:r3]; //show buttons
    
    MealRequest *r4 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Shane" type:@"Other" time:@"6:30 PM" restaurant:@"Restaurant D" comment:@"latenight" acceptedUser:self.vc.user.userid declinedUsers:tempNSMutableArray selfId:self.vc.user.userid];
    [self.vc.mealRequestsFromOthers addObject:r4];// show accepted
    
    NSMutableArray *declinedUsers = [[NSMutableArray alloc] init];
    [declinedUsers addObject:self.vc.user.userid];
    
    MealRequest *r5 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Kevin" type:@"Lunch" time:@"1:30 PM" restaurant:@"Restaurant E" comment:nil acceptedUser:@"" declinedUsers:declinedUsers selfId:self.vc.user.userid];
    [self.vc.mealRequestsFromOthers addObject:r5]; //show declined
    
    MealRequest *r6 = [[MealRequest alloc] initForOthersWithRequestId:@"requestid" ownerid:@"ownerid" ownername:@"Yaohui" type:@"Dinner" time:@"7:00 PM" restaurant:@"Restaurant F" comment:nil acceptedUser:@"someone's id" declinedUsers:tempNSMutableArray selfId:self.vc.user.userid];
    [self.vc.mealRequestsFromOthers addObject:r6]; //show someone else accepted it; check by checking if accepted_friends = nil
}

-(void)test1ThatTableViewLoads {
    XCTAssertNotNil(self.vc.tableView, @"TableView not initiated");
}

- (void)test2UserInitialized {
    XCTAssertEqual(self.vc.user.userid, @"123");
    XCTAssertEqual(self.vc.user.username, @"tester");
}

- (void)test3AddRequestsFromSelf {
    [self initializeMealRequestsFromSelf];
    
    //verify 2 requests added to mealRequestsFromSelf and tableView
    XCTAssertEqual([self.vc.mealRequestsFromSelf count], 2);
    XCTAssertEqual([self.vc.tableView numberOfRowsInSection:0], 2);
}

- (void)test4AddRequestsFromOthers {
    [self initializeMealRequestsFromOthers];
    
    //verify 4 requests added to mealRequestsFromOthers and tableView
    XCTAssertEqual([self.vc.mealRequestsFromOthers count], 4);
    XCTAssertEqual([self.vc.tableView numberOfRowsInSection:1], 4);
}

- (void)test5CorrectTableViewCell {
    [self initializeMealRequestsFromSelf];
    [self initializeMealRequestsFromOthers];
    
    MealRequestWithoutButtonsTableViewCell *selfCellAtIndex0 = (MealRequestWithoutButtonsTableViewCell *)[self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue([selfCellAtIndex0.reuseIdentifier isEqualToString:@"requestWithoutButtons"]);
    XCTAssertTrue([selfCellAtIndex0.messageLabel.text isEqualToString:@"Waiting for response."]);
    
    MealRequestWithoutButtonsTableViewCell *selfCellAtIndex1 = (MealRequestWithoutButtonsTableViewCell *)[self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertTrue([selfCellAtIndex1.reuseIdentifier isEqualToString:@"requestWithoutButtons"]);
    XCTAssertTrue([selfCellAtIndex1.messageLabel.text isEqualToString:@"(null) accepted your request!"]);
    
    MealRequestWithButtonsTableViewCell *otherCellAtIndex0 = (MealRequestWithButtonsTableViewCell *)[self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    XCTAssertTrue([otherCellAtIndex0.reuseIdentifier isEqualToString:@"requestWithButtons"]);
    
    MealRequestWithoutButtonsTableViewCell *otherCellAtIndex1 = (MealRequestWithoutButtonsTableViewCell *)[self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    XCTAssertTrue([otherCellAtIndex1.reuseIdentifier isEqualToString:@"requestWithoutButtons"]);
    XCTAssertTrue([otherCellAtIndex1.messageLabel.text isEqualToString:@"You have accepted this request."]);
    
    MealRequestWithoutButtonsTableViewCell *otherCellAtIndex2 = (MealRequestWithoutButtonsTableViewCell *)[self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    XCTAssertTrue([otherCellAtIndex2.reuseIdentifier isEqualToString:@"requestWithoutButtons"]);
    XCTAssertTrue([otherCellAtIndex2.messageLabel.text isEqualToString:@"You have declined this request."]);
    
    MealRequestWithoutButtonsTableViewCell *otherCellAtIndex3 = (MealRequestWithoutButtonsTableViewCell *)[self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    XCTAssertTrue([otherCellAtIndex3.reuseIdentifier isEqualToString:@"requestWithoutButtons"]);
    XCTAssertTrue([otherCellAtIndex3.messageLabel.text isEqualToString:@"Someone else accepted this request."]);
}

@end
