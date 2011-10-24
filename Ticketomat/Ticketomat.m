//
//  Ticketomat.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Ticketomat.h"


@implementation Ticketomat 

@dynamic guid;
@dynamic title;
@dynamic desc;
@dynamic lng;
@dynamic lat;

- (void) setCoordinate:(CLLocationCoordinate2D)coordinate {
    [self setLat:[NSNumber numberWithDouble:coordinate.latitude]];
    [self setLng:[NSNumber numberWithDouble:coordinate.longitude]];
    
}

- (CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake([[self lat] doubleValue], [[self lng] doubleValue]);
}
@end

@implementation TicketomatAnt
- (id) initWithTicketomat: (Ticketomat *)ticketomat {
    self = [self init];
    if (self) {
        _ticketomat = ticketomat;
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate {
    return [_ticketomat coordinate];
}

- (void) setCoordinate:(CLLocationCoordinate2D)coordinate {
    [_ticketomat setCoordinate:coordinate];

}
- (NSString *) title {
    return [[_ticketomat title] copy];
}

- (void)setTitle:(NSString *)title {
    [_ticketomat setTitle:title];
}

- (NSString *) subtitle {
    return [[_ticketomat desc] copy];
}
- (void)setSubtitle:(NSString *)subtitle {
    [_ticketomat setDesc:subtitle];
}

@end

