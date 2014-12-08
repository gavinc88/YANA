//
//  APIHelperTest.m
//  YANA
//
//  Created by Gavin Chu on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "APIHelper.h"

@interface APIHelperTest : XCTestCase

@end

@implementation APIHelperTest

APIHelper *apiHelper;

- (void)setUp {
    [super setUp];
    apiHelper = [[APIHelper alloc] init];
}

- (void)tearDown {
    apiHelper = nil;
    [super tearDown];
}

#pragma mark - GetArgsForActionGetNearbyUsers

- (void)testGetParametersForActionGetNearbyUsersDefault{
    NSString *args = [apiHelper getParametersForActionGetNearbyUsers:@"user_id"
                                                   longitude:[NSNumber numberWithInt:10]
                                                    latitude:[NSNumber numberWithInt:20]
                                                       range:[NSNumber numberWithInt:5]
                                                 friendsOnly:NO
                                                      gender:nil
                                                    startAge:nil
                                                      endAge:nil];
    XCTAssertNotNil(args);
    
    //convert NSData to NSDictionary
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: args options: NSJSONReadingMutableContainers error: &jsonError];
    
    //check if json contains filter keys or not
    NSArray *allKeys = [json allKeys];
    XCTAssertTrue([allKeys containsObject:@"nearby"]);
    XCTAssertEqual(3, [[json objectForKey:@"nearby"] count]);
    XCTAssertTrue([allKeys containsObject:@"friends_only"]);
    XCTAssertFalse([[json objectForKey:@"friends_only"]boolValue]);
    XCTAssertFalse([allKeys containsObject:@"gender"]);
    XCTAssertFalse([allKeys containsObject:@"age"]);
}

- (void)testGetArgsForActionGetNearbyUsersWithFriendsOnlyFilter{
    NSString *args = [apiHelper getParametersForActionGetNearbyUsers:@"user_id"
                                                   longitude:[NSNumber numberWithInt:10]
                                                    latitude:[NSNumber numberWithInt:20]
                                                       range:[NSNumber numberWithInt:5]
                                                 friendsOnly:YES
                                                      gender:nil
                                                    startAge:nil
                                                      endAge:nil];
    XCTAssertNotNil(args);
    
    //convert NSData to NSDictionary
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: args options: NSJSONReadingMutableContainers error: &jsonError];
    
    //check if json contains filter keys or not
    NSArray *allKeys = [json allKeys];
    XCTAssertTrue([allKeys containsObject:@"nearby"]);
    XCTAssertEqual(3, [[json objectForKey:@"nearby"] count]);
    XCTAssertTrue([allKeys containsObject:@"friends_only"]);
    XCTAssertTrue([[json objectForKey:@"friends_only"]boolValue]);
    XCTAssertFalse([allKeys containsObject:@"gender"]);
    XCTAssertFalse([allKeys containsObject:@"age"]);
}

- (void)testGetArgsForActionGetNearbyUsersWithGenderFilter{
    NSString *args = [apiHelper getParametersForActionGetNearbyUsers:@"user_id"
                                                   longitude:[NSNumber numberWithInt:10]
                                                    latitude:[NSNumber numberWithInt:20]
                                                       range:[NSNumber numberWithInt:5]
                                                 friendsOnly:NO
                                                      gender:@"male"
                                                    startAge:nil
                                                      endAge:nil];
    XCTAssertNotNil(args);
    
    //convert NSData to NSDictionary
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: args options: NSJSONReadingMutableContainers error: &jsonError];
    
    //check if json contains filter keys or not
    NSArray *allKeys = [json allKeys];
    XCTAssertTrue([allKeys containsObject:@"nearby"]);
    XCTAssertEqual(3, [[json objectForKey:@"nearby"] count]);
    XCTAssertTrue([allKeys containsObject:@"friends_only"]);
    XCTAssertFalse([[json objectForKey:@"friends_only"]boolValue]);
    XCTAssertTrue([allKeys containsObject:@"gender"]);
    XCTAssertFalse([allKeys containsObject:@"age"]);
}

- (void)testGetArgsForActionGetNearbyUsersWithStartAgeFilter{
    NSString *args = [apiHelper getParametersForActionGetNearbyUsers:@"user_id"
                                                   longitude:[NSNumber numberWithInt:10]
                                                    latitude:[NSNumber numberWithInt:20]
                                                       range:[NSNumber numberWithInt:5]
                                                 friendsOnly:NO
                                                      gender:nil
                                                    startAge:[NSNumber numberWithInt:18]
                                                      endAge:nil];
    XCTAssertNotNil(args);
    
    //convert NSData to NSDictionary
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: args options: NSJSONReadingMutableContainers error: &jsonError];
    
    //check if json contains filter keys or not
    NSArray *allKeys = [json allKeys];
    XCTAssertTrue([allKeys containsObject:@"nearby"]);
    XCTAssertEqual(3, [[json objectForKey:@"nearby"] count]);
    XCTAssertTrue([allKeys containsObject:@"friends_only"]);
    XCTAssertFalse([[json objectForKey:@"friends_only"]boolValue]);
    XCTAssertFalse([allKeys containsObject:@"gender"]);
    XCTAssertTrue([allKeys containsObject:@"age"]);
    XCTAssertTrue([[json objectForKey:@"age"] objectForKey:@"age_low"]);
    XCTAssertFalse([[json objectForKey:@"age"] objectForKey:@"age_high"]);
}

- (void)testGetArgsForActionGetNearbyUsersWithEndAgeFilter{
    NSString *args = [apiHelper getParametersForActionGetNearbyUsers:@"user_id"
                                                   longitude:[NSNumber numberWithInt:10]
                                                    latitude:[NSNumber numberWithInt:20]
                                                       range:[NSNumber numberWithInt:5]
                                                 friendsOnly:NO
                                                      gender:nil
                                                    startAge:nil
                                                      endAge:[NSNumber numberWithInt:32]];
    XCTAssertNotNil(args);
    
    //convert NSData to NSDictionary
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: args options: NSJSONReadingMutableContainers error: &jsonError];
    
    //check if json contains filter keys or not
    NSArray *allKeys = [json allKeys];
    XCTAssertTrue([allKeys containsObject:@"nearby"]);
    XCTAssertEqual(3, [[json objectForKey:@"nearby"] count]);
    XCTAssertTrue([allKeys containsObject:@"friends_only"]);
    XCTAssertFalse([[json objectForKey:@"friends_only"]boolValue]);
    XCTAssertFalse([allKeys containsObject:@"gender"]);
    XCTAssertTrue([allKeys containsObject:@"age"]);
    XCTAssertFalse([[json objectForKey:@"age"] objectForKey:@"age_low"]);
    XCTAssertTrue([[json objectForKey:@"age"] objectForKey:@"age_high"]);
}

- (void)testGetArgsForActionGetNearbyUsersWithAllFilters{
    NSString *args = [apiHelper getParametersForActionGetNearbyUsers:@"user_id"
                                                   longitude:[NSNumber numberWithInt:10]
                                                    latitude:[NSNumber numberWithInt:20]
                                                       range:[NSNumber numberWithInt:5]
                                                 friendsOnly:YES
                                                      gender:@"female"
                                                    startAge:[NSNumber numberWithInt:18]
                                                      endAge:[NSNumber numberWithInt:32]];
    XCTAssertNotNil(args);
    
    //convert NSData to NSDictionary
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: args options: NSJSONReadingMutableContainers error: &jsonError];
    
    //check if json contains filter keys or not
    NSArray *allKeys = [json allKeys];
    XCTAssertTrue([allKeys containsObject:@"nearby"]);
    XCTAssertEqual(3, [[json objectForKey:@"nearby"] count]);
    XCTAssertTrue([allKeys containsObject:@"friends_only"]);
    XCTAssertTrue([[json objectForKey:@"friends_only"]boolValue]);
    XCTAssertTrue([allKeys containsObject:@"gender"]);
    XCTAssertTrue([allKeys containsObject:@"age"]);
    XCTAssertTrue([[json objectForKey:@"age"] objectForKey:@"age_low"]);
    XCTAssertTrue([[json objectForKey:@"age"] objectForKey:@"age_high"]);
}

@end
