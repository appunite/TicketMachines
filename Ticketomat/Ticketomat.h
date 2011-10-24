//
//  Ticketomat.h
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>




@interface Ticketomat : NSManagedObject

@property (nonatomic, retain) NSNumber * guid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface TicketomatAnt : NSObject <MKAnnotation> {
@private
    Ticketomat *_ticketomat;
}
- (id) initWithTicketomat: (Ticketomat *)ticketomat;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@end
