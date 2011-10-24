//
//  TicketomatsViewController.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TicketomatsViewController.h"
#import "Notiffications.h"
#import "MyMath.h"
#import "SVProgressHUD.h"

@implementation TicketomatsViewController

#pragma mark - JSON parsing

- (Ticketomat *)createFeature:(NSDictionary *)feature {
    NSDictionary *geometry = [feature objectForKey:@"geometry"];
    NSDictionary *properties = [feature objectForKey:@"properties"];
    NSNumber * guid = [feature objectForKey:@"id"];
    
    if (geometry == nil)
        return nil;
    if (properties == nil)
        return nil;
    
    NSArray* coordinates = [geometry objectForKey:@"coordinates"];
    if ([coordinates count] != 2)
        return nil;
    
    NSNumber * lat = [coordinates objectAtIndex:1];
    NSNumber * lng = [coordinates objectAtIndex:0];
    if (lng == nil)
        return nil;
    if (lat == nil)
        return nil;
    
    NSString * title = [properties objectForKey:@"opis"];
    NSString * desc = [properties objectForKey:@"opis_long"];
    if (title == nil)
        return nil;
    if (desc == nil)
        return nil;
    RKManagedObjectStore * objectStore = [[RKObjectManager sharedManager] objectStore];
    NSManagedObjectContext * managedObjectContext = [objectStore managedObjectContext];
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Ticketomat" inManagedObjectContext:managedObjectContext];
    Ticketomat *ret = (Ticketomat*)[objectStore findOrCreateInstanceOfEntity:entityDesc withPrimaryKeyAttribute:@"guid" andValue:guid];
                                           
    [ret setGuid:guid];
    [ret setTitle:title];
    [ret setDesc:desc];
    [ret setLng:lng];
    [ret setLat:lat];
    return ret;
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSError *error;
    if (![response isOK])
        return;
    if ([response isNotFound])
        return;
    NSDictionary * json = [response parsedBody:&error];
    if (json == nil)
        return;
    // TODO remove all objects
    NSArray * features = [json objectForKey:@"features"];
    for (NSDictionary *feature in features) {
        [self createFeature:feature];    
    }
    [[[RKObjectManager sharedManager] objectStore] save];
    
    [self loadObjects];
    _pending = NO;
    [SVProgressHUD dismissWithSuccess:@"Data loaded"];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    _pending = NO;
    [SVProgressHUD dismissWithError:@"Network problem"];
    NSLog(@"error: %@", error);
}


- (NSString *) resourcePath {
    return @"biletomaty_wgs/";
}



- (double) calculateDistance: (CLLocationCoordinate2D) cord1 {
    CLLocationCoordinate2D cord2 = self->_location;
    
    double dLatitude = cord1.latitude - cord2.latitude;
    double dLongtitue = cord1.longitude - cord2.longitude;
    
    double earthR = 6371; // km
    
    double a = sin(DEG2RAD(dLatitude)/2) * sin(DEG2RAD(dLatitude)/2) + sin(DEG2RAD(dLongtitue)/2) * sin(DEG2RAD(dLongtitue)/2) * cos(DEG2RAD(cord1.latitude)) * cos(DEG2RAD(cord2.latitude)); 
    double c = 2 * atan2(sqrt(a), sqrt(1-a)); 
    double distance = earthR * c;
    return distance;
}


- (void) sortObjects {
    if (_haveLocation == NO)
        return;
    NSMutableArray *mutableItems = [NSMutableArray arrayWithArray:_items];
    [mutableItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Ticketomat *first = obj1;
        Ticketomat *second = obj2;
        if (_haveLocation) {
            double firstDistance = [self calculateDistance:[first coordinate]];
            double secondDistance = [self calculateDistance:[second coordinate]];
            if (firstDistance < secondDistance)
                return NSOrderedAscending;
            else if (firstDistance > secondDistance)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        } else {
            return [[ first title ] compare:[second title]];
        }
    }];
    _items = mutableItems;
    [self.tableView reloadData];
}

- (void)loadObjects {
    _items = [Ticketomat allObjects];
    [self sortObjects];
    [self.tableView reloadData];
}

- (void) refreshData {
    if (_pending == YES)
        return;
    _pending = YES;
    
    RKClient * client = [RKClient sharedClient];
    assert(client != nil);
    [client get:[self resourcePath] delegate:self];
    
    [SVProgressHUD showInView:self.parentViewController.view status:@"Refreshing" networkIndicator:YES];
    
}

#pragma mark - UI delegate

- (void) refreshButtonClicked:(id)sender
{
    [self refreshData];
}

#pragma mark - View lifecycle

- (void)onSlowLocationChange:(id)sender {
    NSNotification *notiffication = sender;
    id object = [notiffication object];
    CLLocation * newLocation = object;
    assert(newLocation != nil);
    self->_location = [newLocation coordinate];
    self->_haveLocation = YES;
    [self sortObjects];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSlowLocationChange:) name:SlowLocationChangedNotifficationName object:nil];
}
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SlowLocationChangedNotifficationName object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addObservers];
    
    [self refreshData];
    
    [self loadObjects];
    self.tableView.rowHeight = [TicketomatCell getHeight];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self removeObservers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_items count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TicketomatCell";
    
    TicketomatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TicketomatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Ticketomat *ticketomat = [_items objectAtIndex:[indexPath row]];
    [cell setLocator:_locator];
    [cell setTicketomatData:ticketomat];
    return cell;
}

#pragma mark - Table view delegate


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Ticketomat *ticketomat = [_items objectAtIndex:[indexPath row]];
    UIViewController * detailViewController = [[MapViewController alloc] initWithPlace:ticketomat];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Ticketomats", @"Ticketomats");
        self.tabBarItem.image = [UIImage imageNamed:@"ticketomats"];
        
        UIBarButtonItem * refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked:)];
        self.navigationItem.rightBarButtonItem = refreshButton;
        
        [[self navigationItem] setTitle:@"Ticketomats"];
        _locator = [Locator new];
        _haveLocation = NO;
        _pending = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
