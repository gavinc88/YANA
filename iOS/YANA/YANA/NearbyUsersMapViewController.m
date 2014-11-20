//
//  NearbyUsersMapViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/11/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "NearbyUsersMapViewController.h"
#import "APIHelper.h"
#import "AppDelegate.h"
#import "User.h"
#import "Friend.h"

@interface NearbyUsersMapViewController ()

@property (nonatomic,strong) User *user;

@end

@implementation NearbyUsersMapViewController

#pragma mark - Setup

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

APIHelper *apiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    [self initializeUser];
    
    //initialize variable for no filter
    self.hasFilter = NO;
    self.friendsOnly = NO;
    self.gender= nil;
    self.startAge = nil;
    self.endAge = nil;
    
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    #endif
    [self.locationManager startUpdatingLocation];
    
    [self updateCurrentLocation];
    [self addMockUserAnnotations];
    [self getNearbyUsers];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"location manager: %@", [self deviceLocation]);
    
    self.longitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];
    self.latitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
    NSLog(@"latitude: %f longitude: %f", [self.latitude doubleValue], [self.longitude doubleValue]);
    
    //View Area
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation, 1500, 1500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    self.range = [NSNumber numberWithInt:10];
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}

#pragma mark - API Calls

- (void) updateCurrentLocation{
    NSDictionary *response = [apiHelper updateUserLocation:self.user.userid longitude:self.longitude latitude:self.latitude];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
        } else {
            NSLog(@"Update location failed. Please check your internet connection or try again later.");
        }
    }else{
        NSLog(@"Update location failed. Please check your internet connection or try again later.");
    }
}

- (void) getNearbyUsers {
    self.nearbyUsers = [[NSMutableDictionary alloc] init];
    
    NSDictionary *response = [apiHelper getNearbyUsers:self.user.userid longitude:self.longitude latitude:self.latitude range:self.range friendsOnly:self.friendsOnly gender:self.gender startAge:self.startAge endAge:self.endAge];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            //get an array of nearby users
            NSArray *nearbyUsers = [response objectForKey:@"users"];
            
            //create annotations and add them to self.nearbyUsers
            for(NSDictionary *user in nearbyUsers){
                
                NSString *userid = [user objectForKey:@"_id"];
                NSString *username = [user objectForKey:@"username"];
                
                NSDictionary *profile = [response objectForKey:@"profile"];
                NSString *about = nil;
                if(profile){
                    about = [profile objectForKey:@"about"];
                }
                
                //get latitude and longitude for creating annotation
                NSNumber *latitude = [user objectForKey:@"latitude"];
                NSNumber *longitude = [user objectForKey:@"longitiude"];
                
                MKPointAnnotation *userAnnotation = [[MKPointAnnotation alloc] init];
                userAnnotation.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
                userAnnotation.title = username;
                if(about){
                    userAnnotation.subtitle = about;
                }
                
                //add annotation to map view
                [self.mapView addAnnotation:userAnnotation];
                
                //save annotation and userid in self.nearbyUsers for access later
                NSDictionary *nearbyUser = [[NSDictionary alloc] initWithObjectsAndKeys:userAnnotation, @"annotation", userid, @"userid", nil];
                
                [self.nearbyUsers setObject:nearbyUser forKey:userAnnotation.title];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Get nearby users failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Get nearby users failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - LocationManager tools

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

#pragma mark - Map Annotations

- (void)addMockUserAnnotations {
    MKPointAnnotation *user1 = [[MKPointAnnotation alloc] init];
    user1.coordinate = CLLocationCoordinate2DMake(37.867427, -122.250);
    user1.title = @"User 1";
    user1.subtitle = @"about: this user is gavin and he has a long about message";
    [self.mapView addAnnotation:user1];
    
    MKPointAnnotation *user2 = [[MKPointAnnotation alloc] init];
    user2.coordinate = CLLocationCoordinate2DMake(37.867427, -122.2575);
    user2.title = @"User 2";
    [self.mapView addAnnotation:user2];
    
    MKPointAnnotation *user3 = [[MKPointAnnotation alloc] init];
    user3.coordinate = CLLocationCoordinate2DMake(37.862, -122.253364);
    user3.title = @"User 3";
    user3.subtitle = @"about: short";
    [self.mapView addAnnotation:user3];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NearbyUserPin"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPointAnnotation *userAnnotation = (MKPointAnnotation *)annotation;
        NSLog(@"%@ Clicked", userAnnotation.title);
    }
}

@end
