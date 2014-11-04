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
    [tester enterText:@"login" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"test" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
}

- (void)logout {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester tapViewWithAccessibilityLabel:@"logoutButton"];
}

- (void)test00SwitchingTabs {
    NSLog(@"%s",__PRETTY_FUNCTION__);
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

- (void)test01OpenCreateMealRequest {
    [tester tapViewWithAccessibilityLabel:@"Requests"];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests"];
    
    //verify that CreateMealRequestViewController is opened
    [tester tapScreenAtPoint:CGPointMake(300, 20)];
    [tester waitForViewWithAccessibilityLabel:@"Create Meal Request"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
}

- (void)test02OpenSearchAndAddFriend {
    [tester tapViewWithAccessibilityLabel:@"Friends"];
    [tester waitForViewWithAccessibilityLabel:@"Friends"];
    
    //verify that CreateMealRequestViewController is opened
    [tester tapScreenAtPoint:CGPointMake(300, 20)];
    [tester waitForViewWithAccessibilityLabel:@"Friend Search"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

@end
