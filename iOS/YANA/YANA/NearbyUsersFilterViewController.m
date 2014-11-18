//
//  NearbyUsersFilterViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/18/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "NearbyUsersFilterViewController.h"

@interface NearbyUsersFilterViewController ()

@end

@implementation NearbyUsersFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startAge = 0;
    self.endAge = 60;
    [self configureAgeSlider];
    [self initializeAgeLabels];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSliderLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) configureAgeSlider{
    NSLog(@"configureAgeSlider");
    self.ageRangeSlider.minimumValue = 0;
    self.ageRangeSlider.maximumValue = 60;
    
    self.ageRangeSlider.lowerValue = self.startAge;
    self.ageRangeSlider.upperValue = self.endAge;
    
    self.ageRangeSlider.minimumRange = 1;
}

- (void) initializeAgeLabels{
    //programmatically add age label positioned above slider center
    self.lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ageRangeSlider.lowerCenter.x + self.ageRangeSlider.frame.origin.x, self.ageRangeSlider.center.y - 30.0f, 20, 20)];
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageRangeSlider.lowerValue];
    [self.view addSubview:self.lowerLabel];
    
    self.upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ageRangeSlider.upperCenter.x + self.ageRangeSlider.frame.origin.x, self.ageRangeSlider.center.y - 30.0f, 20, 20)];
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageRangeSlider.upperValue];
    [self.view addSubview:self.upperLabel];
}

- (void) updateSliderLabels{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.ageRangeSlider.lowerCenter.x + self.ageRangeSlider.frame.origin.x);
    lowerCenter.y = (self.ageRangeSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageRangeSlider.lowerValue];
    self.startAge = self.ageRangeSlider.lowerValue;
    
    CGPoint upperCenter;
    upperCenter.x = (self.ageRangeSlider.upperCenter.x + self.ageRangeSlider.frame.origin.x);
    upperCenter.y = (self.ageRangeSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageRangeSlider.upperValue];
    self.endAge = self.ageRangeSlider.upperValue;
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender{
    [self updateSliderLabels];
}

@end
