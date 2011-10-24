//
//  TicketomatCellLocator.h
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-21.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Locator : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    CLLocation * _previousLocation;
    
    CLLocationCoordinate2D _location;
    CLLocationDirection _heading;
    Boolean _haveLocation;
    Boolean _haveHeading;
    CLLocationAccuracy _accuracy;
}
@property(nonatomic, readonly) CLLocationCoordinate2D location;
@property(nonatomic, readonly) CLLocationDirection heading;
@property(nonatomic, readonly) Boolean haveLocation;
@property(nonatomic, readonly) Boolean haveHeading;
@property(nonatomic, readonly) CLLocationAccuracy accuracy;
@end
