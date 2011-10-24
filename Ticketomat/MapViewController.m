//
//  SecondViewController.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize items = _items;
@synthesize place = _place;

- (MKMapRect) mapRectForAnnotations:(NSArray*)annotationsArray
{
    MKMapRect mapRect = MKMapRectNull;
    
    //annotations is an array with all the annotations I want to display on the map
    for (id<MKAnnotation> annotation in annotationsArray) { 
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
        if (MKMapRectIsNull(mapRect)) 
        {
            mapRect = pointRect;
        } else 
        {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    
    return mapRect;
}

- (void) localizeButtonClicked: (id) sender {
    if (_haveLocation) {
        [self loadObjects];
    } else {
        _findLocation = YES;
    }
}
- (id)initWithPlace: (Ticketomat *) ticketomat {
    self = [self init];
    if (self) {
        [self setPlace:ticketomat];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"map"];
        _findLocation = NO;
        
        UIBarButtonItem * localizeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(localizeButtonClicked:)];
        self.navigationItem.rightBarButtonItem = localizeButton;
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) moveToVisibleBounds:(MKUserLocation *)userLocation {
    NSMutableArray* array = [NSMutableArray arrayWithArray: _items];
    [array addObject: userLocation];
    
    // Position the map so that all overlays and annotations are visible on screen.
    MKMapRect regionToDisplay = [self mapRectForAnnotations:array];
    if (!MKMapRectIsNull(regionToDisplay)) {
        [_mapView setVisibleMapRect:regionToDisplay edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
    if( annotation == _mapView.userLocation ){ return nil; }
    
    static NSString *annotationViewID = @"TicketomatAnt";
    
    MKPinAnnotationView *annotationView =
    (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    }
    
    annotationView.annotation = annotation;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.animatesDrop = NO;
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)loadObjects {
    _items = [Ticketomat allObjects];
    NSMutableArray * array = [NSMutableArray new];
    NSMutableArray * selectedItems = [NSMutableArray new];
    for (Ticketomat *ticketomat in _items) {
        TicketomatAnt * ann = [[TicketomatAnt alloc] initWithTicketomat:ticketomat];
        [array addObject:ann];
        
        if (_place != nil) {
            if ([[ticketomat guid] isEqual:[_place guid]]) {
                [selectedItems addObject:ann];
            }
        }
    }
    
    NSArray *oldAnnotations = _mapView.annotations;
    [_mapView removeAnnotations:oldAnnotations];
    [_mapView addAnnotations:array];
    [_mapView setSelectedAnnotations:selectedItems];
    
    NSArray * calibrationArray;
    if (_place == nil) {
        calibrationArray = array;
    } else {
        if (_haveLocation) {
            calibrationArray = [NSArray arrayWithObjects:_place, _mapView.userLocation, nil];
        } else {
            calibrationArray = [NSArray arrayWithObjects:_place, nil];
            _findLocation = YES;
        }
    }
    
    MKMapRect regionToDisplay = [self mapRectForAnnotations:calibrationArray];
    if (!MKMapRectIsNull(regionToDisplay)) {
        [_mapView setVisibleMapRect:regionToDisplay edgePadding:UIEdgeInsetsMake(10.0, 10.0, 40.0, 20.0) animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    //[_mapView setFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    
    MKCoordinateRegion newRegion;
    if (_place == nil) {
        
        [_mapView setShowsUserLocation:YES];
        
        // Pozen (52.458223,16.924647)
        newRegion.center.latitude = 52.458223;
        newRegion.center.longitude = 16.924647;
        
        newRegion.span.latitudeDelta = 0.5;
        newRegion.span.longitudeDelta = 0.5;
    } else {
        
        [_mapView setShowsUserLocation:YES];
        newRegion.center = CLLocationCoordinate2DMake([[_place lat] doubleValue], [[_place lng] doubleValue]);
        
        newRegion.span.latitudeDelta = 0.01;
        newRegion.span.longitudeDelta = 0.01;
    }
    
    [_mapView setRegion:newRegion animated:YES];
    [_mapView setMapType:MKMapTypeStandard];
    
    [self loadObjects];
}

- (void)layoutSubviews
{
    [_mapView layoutSubviews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([view.annotation isKindOfClass:[TicketomatAnt class]]) {
        TicketomatAnt *ann = view.annotation;
        CLLocationCoordinate2D cord = [ann coordinate];
        NSString *stringURL;
        if (_haveLocation) {
            stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=(%f,%f)&saddr=(%f,%f)&dirflg=w", cord.latitude, cord.longitude, _location.latitude, _location.longitude];
        } else {
            stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=(%f,%f)", cord.latitude, cord.longitude];
        }
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _haveLocation = YES;
    _location = [userLocation coordinate];
    if (_findLocation) {
        _findLocation = NO;
        [self loadObjects];
    }
}

@end
