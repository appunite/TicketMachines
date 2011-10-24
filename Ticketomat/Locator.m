//
//  TicketomatCellLocator.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-21.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Locator.h"
#import "Notiffications.h"

@implementation Locator

@synthesize location = _location;
@synthesize heading = _heading;
@synthesize haveHeading = _haveHeading;
@synthesize haveLocation = _haveLocation;
@synthesize accuracy = _accuracy;


#pragma mark - GPS

- (void)startUpdatingGPS
{
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setHeadingFilter: 10.0];
    [_locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
        [_locationManager setDelegate:self];
    [_locationManager startUpdatingHeading];
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    if ([newHeading headingAccuracy] > 0 ) {
        _haveHeading = YES;
        _heading = [newHeading magneticHeading];
    } else {
        _haveHeading = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HeadingChangedNotifficationName object:newHeading];

}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    _location = [newLocation coordinate];
    _accuracy = [newLocation horizontalAccuracy];
    _haveLocation = YES;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationChangedNotifficationName object:newLocation];
    
    if (_previousLocation == nil ||
        [newLocation distanceFromLocation:_previousLocation] > 0.1) {
        _previousLocation = newLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:SlowLocationChangedNotifficationName object:newLocation];
    }
}

#pragma mark -

- (id) init {
    self = [super init];
    if (self) {
        [self startUpdatingGPS];
    }
    return self;
}
@end
