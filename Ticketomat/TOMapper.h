//
//  TOMapper.h
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_BASE @"http://www.poznan.pl/featureserver/featureserver.cgi/"
#define SERVER_TICKETOMATS @"biletomaty_wgs/"

@interface TOMapper : NSObject {
@protected
    RKObjectManager* _objectManager;
}
- (id) initWithObjectManager:(RKObjectManager*) objectManager; 
- (void) mapAttributesAndRelations;
- (RKObjectMapping*) mapQuests;
@end
