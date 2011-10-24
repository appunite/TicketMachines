//
//  TOMapper.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TOMapper.h"
#import "Ticketomat.h"

@implementation TOMapper 

- (id) initWithObjectManager:(RKObjectManager*) objectManager {
    self = [super init];
    if (self) {
        _objectManager = objectManager;
    }
    return self;
}

- (void) mapAttributesAndRelations {
    //RKObjectMapping* questsMapping = [self mapQuests];
}

- (RKObjectMapping*) mapQuests {
//    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Ticketomat class];
//    mapping.primaryKeyAttribute = @"guid";
//    [mapping mapAttributes:@"distance", @"guid", @"location", @"lat", @"lng", nil];
//    [mapping mapKeyPath:@"photo_url" toAttribute:@"imageUrl"];
//    [mapping mapKeyPath:@"description" toAttribute:@"desc"];
//    [mapping mapKeyPath:@"title" toAttribute:@"questTitle"];
//    
//    // Register our mappings with the provider
//    [_objectManager.mappingProvider setMapping:mapping forKeyPath:@"quests"];
//    
 //    return mapping;
    return nil;
}

@end
