//
//  SecondViewController.h
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Ticketomat.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView* _mapView;
    NSArray *_items;
    Ticketomat *_place;
    CLLocationCoordinate2D _location;
    Boolean _haveLocation;
    Boolean _findLocation;
}

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) Ticketomat *place;

- (id)initWithPlace: (Ticketomat *) ticketomat;
- (void) loadObjects;
@end
