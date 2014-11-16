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
    [tester clearTextFromAndThenEnterText:@"shaneTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester clearTextFromAndThenEnterText:@"123" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"Settings"];
}

- (void)test1UpdateProfilePageAboutText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"aboutTextField"];
    [tester clearTextFromAndThenEnterText:@"about the user" intoViewWithAccessibilityLabel:@"aboutTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"aboutLabel" value:@"about the user" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"aboutTextField"];
}

- (void)test3UpdateProfilePageGenderText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"genderTextField"];
    [tester clearTextFromAndThenEnterText:@"male" intoViewWithAccessibilityLabel:@"genderTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"genderLabel" value:@"male" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"genderTextField"];
}

- (void)test3UpdateProfilePageAgeText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"ageTextField"];
    [tester clearTextFromAndThenEnterText:@"45" intoViewWithAccessibilityLabel:@"ageTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"ageLabel" value:@"45" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"ageTextField"];
}

- (void)test3UpdateProfilePageFoodPreferencesText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"foodPreferencesTextField"];
    [tester clearTextFromAndThenEnterText:@"Junk Food" intoViewWithAccessibilityLabel:@"foodPreferencesTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"foodPreferencesLabel" value:@"Junk Food" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"foodPreferencesTextFieldTextField"];
}

- (void)test5UpdateProfilePagePhoneNumberText {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"phoneNumberTextField"];
    [tester clearTextFromAndThenEnterText:@"415888256" intoViewWithAccessibilityLabel:@"phoneNumberTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"phoneNumberLabel" value:@"415888256" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"phoneNumberTextField"];
    
}

- (void) test6ResetEverything {
    [tester tapViewWithAccessibilityLabel:@"edit"];
    [tester waitForViewWithAccessibilityLabel:@"aboutTextField"];
    [tester waitForViewWithAccessibilityLabel:@"genderTextField"];
    [tester waitForViewWithAccessibilityLabel:@"ageTextField"];
    [tester waitForViewWithAccessibilityLabel:@"foodPreferencesTextField"];
    [tester waitForViewWithAccessibilityLabel:@"phoneNumberTextField"];
    [tester clearTextFromAndThenEnterText:@"(none)" intoViewWithAccessibilityLabel:@"aboutTextField"];
    [tester clearTextFromAndThenEnterText:@"(not specified)" intoViewWithAccessibilityLabel:@"genderTextField"];
    [tester clearTextFromAndThenEnterText:@"0" intoViewWithAccessibilityLabel:@"ageTextField"];
    [tester clearTextFromAndThenEnterText:@"(not specified)" intoViewWithAccessibilityLabel:@"foodPreferencesTextField"];
    [tester clearTextFromAndThenEnterText:@"(not specified)" intoViewWithAccessibilityLabel:@"phoneNumberTextField"];
    [tester tapViewWithAccessibilityLabel:@"updateButton"];
    [tester waitForViewWithAccessibilityLabel:@"aboutLabel" value:@"(none)" traits:UIAccessibilityTraitStaticText];
    [tester waitForViewWithAccessibilityLabel:@"genderLabel" value:@"(not specified)" traits:UIAccessibilityTraitStaticText];
    [tester waitForViewWithAccessibilityLabel:@"ageLabel" value:@"0" traits:UIAccessibilityTraitStaticText];
    [tester waitForViewWithAccessibilityLabel:@"foodPreferencesLabel" value:@"(not specified)" traits:UIAccessibilityTraitStaticText];
    [tester waitForViewWithAccessibilityLabel:@"phoneNumberLabel" value:@"(not specified)" traits:UIAccessibilityTraitStaticText];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"aboutTextField"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"genderTextField"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"ageTextField"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"foodPreferencesTextFieldTextField"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"phoneNumberTextField"];
}

- (void) afterAll {
    [tester tapViewWithAccessibilityLabel:@"logoutButton"];
}




@end