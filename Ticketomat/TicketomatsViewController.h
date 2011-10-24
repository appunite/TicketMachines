//
//  TicketomatsViewController.h
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticketomat.h"
#import "TicketomatCell.h"
#import "MapViewController.h"
#import "Locator.h"

@interface TicketomatsViewController : UITableViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate>{
    @private
    NSArray * _items;
    Locator *_locator;
    CLLocationCoordinate2D _location;
    Boolean _haveLocation;
    Boolean _pending;
}
- (NSString *)resourcePath;
- (void)loadObjects;
@end
