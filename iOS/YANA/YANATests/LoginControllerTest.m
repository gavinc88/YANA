//
//  LoginControllerUITest.m
//  YANA
//
//  Created by Gavin Chu on 11/3/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>

@interface LoginControllerTest : KIFTestCase

@end

@implementation LoginControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)navigateToLoginPage
{
    //[tester tapViewWithAccessibilityLabel:@"Login/Sign Up"];
}

- (void)returnToLoggedOutHomeScreen
{
    //[tester tapViewWithAccessibilityLabel:@"Logout"];
    //[tester tapViewWithAccessibilityLabel:@"Logout"]; // Dismiss alert.
}

- (void)test00FailLogin
{
    [tester enterText:@"login" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"wrong_password" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"Invalid Credentials"];
    [tester tapViewWithAccessibilityLabel:@"OK"];
}

- (void)test01SuccessfulLogin
{
    [tester clearTextFromAndThenEnterText:@"login"
           intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester clearTextFromAndThenEnterText:@"test"
           intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests"];
}

@end
