//
//  MainTabControllerTest.m
//  YANA
//
//  Created by Gavin Chu on 11/3/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>

@interface MainTabControllerTest : KIFTestCase

@end

@implementation MainTabControllerTest

- (void)setUp {
    [super setUp];
    [self login];
}

- (void)tearDown {
    [self logout];
    [super tearDown];
}

- (void)login {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [tester enterText:@"iosTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"test" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
}

- (void)logout {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester tapViewWithAccessibilityLabel:@"logoutButton"];
}

- (void)test1SwitchingTabs {
    //verify switched to Friends tab
    [tester tapViewWithAccessibilityLabel:@"Friends"];
    [tester waitForViewWithAccessibilityLabel:@"Friends"];
    
    //verify switched bakc to Meal Requests tab
    [tester tapViewWithAccessibilityLabel:@"Requests"];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests"];
    
    //verify switched to Friends tab again
    [tester tapViewWithAccessibilityLabel:@"Friends"];
    [tester waitForViewWithAccessibilityLabel:@"Friends"];
}

- (void)test2OpenCreateMealRequest {
    [tester tapViewWithAccessibilityLabel:@"Requests"];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests"];
    
    //verify that CreateMealRequestViewController is opened
    [tester tapScreenAtPoint:CGPointMake(300, 20)];
    [tester waitForViewWithAccessibilityLabel:@"Create Meal Request"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
}

- (void)test3OpenSearchAndAddFriend {
    [tester tapViewWithAccessibilityLabel:@"Friends"];
    [tester waitForViewWithAccessibilityLabel:@"Friends"];
    
    //verify that SearchAndAddFriendViewController is opened
    [tester tapScreenAtPoint:CGPointMake(300, 20)];
    [tester waitForViewWithAccessibilityLabel:@"Friend Search"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

@end
