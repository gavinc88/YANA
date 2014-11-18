//
//  NearbyUsersFilterViewController.h
//  YANA
//
//  Created by Gavin Chu on 11/18/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface NearbyUsersFilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet NMRangeSlider *ageRangeSlider;
@property (retain, nonatomic) UILabel *lowerLabel;
@property (retain, nonatomic) UILabel *upperLabel;

@property (strong, nonatomic) NSString *gender;
@property int startAge;
@property int endAge;

@end
