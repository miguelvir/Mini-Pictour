//
//  TourViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourViewController.h"
#import "Annotation.h"
@interface TourViewController ()
    @property (retain) PFObject *tour;
    @property (retain) NSArray *tourPoints;
    @property (assign) IBOutlet MKMapView *mapView;
@end

@implementation TourViewController

@synthesize tour, tourPoints, mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTour:(PFObject *)tour
{
    self = [super init];
    if (self){
        self.tour = tour;
        PFQuery *query = [PFQuery queryWithClassName:@"TourPoint"];
        [query whereKey:@"tour" equalTo:tour];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                self.tourPoints = objects;
                for (PFObject *tourPoint in tourPoints) {
                    [mapView addAnnotation:[Annotation annotationWithTourPoint:tourPoint]];
                }
                MKCoordinateRegion region;
                region.center = CLLocationCoordinate2DMake([[[tourPoints objectAtIndex:0] valueForKey:@"latitude"] doubleValue] , [[[tourPoints objectAtIndex:0] valueForKey:@"longitude"] doubleValue]);
                region.span = MKCoordinateSpanMake(0.01, 0.01);
         
                region = [self.mapView regionThatFits:region];
                [self.mapView setRegion:region animated:NO];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [tour release];
    [tourPoints release];
    [super dealloc];
}

@end
