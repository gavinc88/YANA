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
    [tester enterText:@"login" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"test" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
}

- (void)logout {
    
}

@end
