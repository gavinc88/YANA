//
//  EditProfileTest.m
//  YANA
//
//  Created by Shane on 11/7/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KIF/KIF.h>
@interface EditProfileTest : KIFTestCase

@end

@implementation EditProfileTest

- (void)beforeAll {
    [tester enterText:@"shaneTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"123" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"Settings"];
}

- (void)test1UpdateProfilePageAboutText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"aboutTextField"];
    [tester enterText:@"about the user" intoViewWithAccessibilityLabel:@"aboutTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"aboutLabel" value:@"about the user" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"aboutTextField"];
}

- (void)test3UpdateProfilePageGenderText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"ageTextField"];
    [tester enterText:@"male" intoViewWithAccessibilityLabel:@"genderTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"genderLabel" value:@"male" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"genderTextField"];
}

- (void)test3UpdateProfilePageAgeText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"ageTextField"];
    [tester enterText:@"45" intoViewWithAccessibilityLabel:@"ageTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"ageLabel" value:@"45" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"ageTextField"];
}

- (void)test3UpdateProfilePageFoodPreferencesText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"foodPreferencesTextField"];
    [tester enterText:@"Junk Food" intoViewWithAccessibilityLabel:@"foodPreferencesTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"foodPreferencesLabel" value:@"Junk Food" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"foodPreferencesTextFieldTextField"];
}

- (void)test5UpdateProfilePagePhoneNumberText {
    [tester tapViewWithAccessibilityLabel:@"edit"];

    [tester waitForViewWithAccessibilityLabel:@"phoneNumberTextField"];
    [tester enterText:@"415888256" intoViewWithAccessibilityLabel:@"phoneNumberTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"phoneNumberLabel" value:@"415888256" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"phoneNumberTextField"];
    
}

- (void) afterAll {
    [tester tapViewWithAccessibilityLabel:@"logoutButton"];
}




@end