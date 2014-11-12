//
//  NearbyUsersMapViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/11/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "NearbyUsersMapViewController.h"

@interface NearbyUsersMapViewController ()

@end

@implementation NearbyUsersMapViewController

#pragma mark - Setup

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self addUserAnnotations];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation, 1200, 1200);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}

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

- (void)addUserAnnotations {
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
