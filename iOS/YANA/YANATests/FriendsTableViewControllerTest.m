//
//  FriendsTableViewControllerTest.m
//  YANA
//
//  Created by Gavin Chu on 11/5/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>
#import "FriendsTableViewController.h"
#import "User.h"
#import "Friend.h"

@interface FriendsTableViewControllerTest : KIFTestCase

@property (nonatomic, strong) FriendsTableViewController *vc;

@end

@implementation FriendsTableViewControllerTest

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"FriendsTableViewController"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    self.vc.user = [[User alloc] initWithUserid:@"123" username:@"tester"];
    self.vc.user.friends = [[NSMutableArray alloc] init];
    self.vc.user.friendsWhoAddedYou = [[NSMutableArray alloc] init];
}

- (void)tearDown {
    self.vc = nil;
    [super tearDown];
}

- (void)initializeMockFriends {
    Friend *fb = [[Friend alloc] initWithid:@"1" andUsername:@"Friend B"];
    Friend *fa = [[Friend alloc] initWithid:@"2" andUsername:@"Friend A"];
    Friend *fc = [[Friend alloc] initWithid:@"3" andUsername:@"Friend C"];
    Friend *fd = [[Friend alloc] initWithid:@"4" andUsername:@"Friend D"];
    [self.vc.user.friends addObjectsFromArray:@[fb,fa,fc,fd]];
}

-(void)test1ThatTableViewLoads {
    XCTAssertNotNil(self.vc.tableView, @"TableView not initiated");
}

- (void)test2UserInitialized {
    XCTAssertEqual(self.vc.user.userid, @"123");
    XCTAssertEqual(self.vc.user.username, @"tester");
}

- (void)test3AddFriends {
    XCTAssertEqual([self.vc.user.friends count], 0);
    
    [self initializeMockFriends]; //add 4 friends
    
    //verify 4 friends added to allFriends and tableView
    XCTAssertEqual([self.vc.user.friends count], 4);
    XCTAssertEqual([self.vc.tableView numberOfRowsInSection:1], 4);
}

- (void)test4SortFriends {
    [self initializeMockFriends];
    
    //check default order
    Friend *friendAtIndex0 = [self.vc.user.friends objectAtIndex:0];
    XCTAssertEqual(friendAtIndex0.friendUsername, @"Friend B", @"Friend B should be at index 0 before sorting.");
    Friend *friendAtIndex3 = [self.vc.user.friends objectAtIndex:3];
    XCTAssertEqual(friendAtIndex3.friendUsername, @"Friend D", @"Friend D should be at index 3 before sorting.");
    
    [self.vc sortFriends];
    
    //check order after sort
    Friend *friendAtIndex0AfterSort = [self.vc.user.friends objectAtIndex:0];
    XCTAssertEqual(friendAtIndex0AfterSort.friendUsername, @"Friend A", @"Friend A should be at index 0 after sorting.");
    Friend *friendAtIndex3AfterSort = [self.vc.user.friends objectAtIndex:3];
    XCTAssertEqual(friendAtIndex3AfterSort.friendUsername, @"Friend D", @"Friend D should still be at index 3 after sorting.");
}

- (void)test5UseInviteFriendTableViewCell {
    [self initializeMockFriends];
    
    UITableViewCell *cellAtIndex0 = [self.vc tableView:self.vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    XCTAssertTrue([cellAtIndex0.reuseIdentifier isEqualToString:@"inviteFriendCell"]);
}

@end
