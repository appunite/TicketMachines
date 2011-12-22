//
//  AppDelegate.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MapViewController.h"
#import "TOMapper.h"
#import "TicketomatsViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupRestKit];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *ticketomatsViewController = [[TicketomatsViewController alloc] init];
    UIViewController *mapViewController = [[MapViewController alloc] init ];
    
    UINavigationController *ticketomatsNaviViewController = [[UINavigationController alloc] initWithRootViewController:ticketomatsViewController];
    UINavigationController *mapNaviViewController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
                                                
    UITabBarController * tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:ticketomatsNaviViewController, mapNaviViewController, nil]];
//    UISplitViewController* splitVC = [[UISplitViewController alloc] init];
//    splitVC.viewControllers = [NSArray arrayWithObjects:ticketomatsViewController, mapViewController, nil];
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) setupRestKit
{
    RKClient * client = [RKClient clientWithBaseURL:SERVER_BASE];
    assert(client != nil);
    [RKClient setSharedClient:client];
    assert([RKClient sharedClient] != nil);
    // Initialize RestKit
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:SERVER_BASE];
    [objectManager setClient:[RKClient sharedClient]];
    [RKObjectManager setSharedManager:objectManager];
    
    //Create object store
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Ticketomat.sqlite" usingSeedDatabaseName:nil managedObjectModel:nil delegate:self];
    //    [[objectManager.objectStore managedObjectContext] setRetainsRegisteredObjects:NO];
    
    //Create mapper
    TOMapper* mapper = [[TOMapper alloc] initWithObjectManager:objectManager];
    //Map attributes and relations
    [mapper mapAttributesAndRelations];
    Class<RKParser> parserClass = [[RKParserRegistry sharedRegistry] parserClassForMIMEType:@"application/json"];
    [[RKParserRegistry sharedRegistry] setParserClass:parserClass forMIMEType:@"text/plain"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
