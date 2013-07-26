//
//  TourCreationViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 24/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourCreationViewController.h"
#import <Parse/Parse.h>

@interface TourCreationViewController ()
    @property (assign) IBOutlet UITextField *tourNameField;
    @property (assign) IBOutlet UITextField *tourDescriptionField;

@end

@implementation TourCreationViewController

@synthesize imageView, scrollView;
@synthesize tourNameField, tourDescriptionField;
@synthesize locationManager, currentLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)saveTourTapped:(UIButton *)sender
{
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackground];
    
    PFObject *newTour = [[PFObject alloc] initWithClassName:@"Tour"];
    [newTour setObject:self.tourNameField.text forKey:@"title"];
    [newTour setObject:self.tourDescriptionField.text forKey:@"description"];
    [newTour setObject:[PFUser currentUser] forKey:@"creator"];
    [newTour saveInBackground];
    
    PFObject *firstPoint = [[PFObject alloc] initWithClassName:@"TourPoint"];
    [firstPoint setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude] forKey:@"latitude"];
    [firstPoint setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude] forKey:@"longitude"];
    [firstPoint setObject:imageFile forKey:@"image"];
    [firstPoint setObject:newTour forKey:@"tour"];
    [firstPoint saveInBackground];
    
    [newTour release];
    [firstPoint release];
    NSLog(@"Se guardó bien");
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

- (void)dealloc
{
    [locationManager release];
    [currentLocation release];
    [super dealloc];
}

@end
