//
//  NearbyUsersMapViewController.h
//  YANA
//
//  Created by Gavin Chu on 11/11/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NearbyUsersMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end
