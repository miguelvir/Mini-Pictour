//
//  TourCreationViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 24/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourCreationViewController.h"
#import "AFJSONRequestOperation.h"
#import <QuartzCore/QuartzCore.h>
#import "TourViewController.h"
@interface TourCreationViewController ()
    @property (assign) IBOutlet UITextField *tourNameField;
    @property (assign) IBOutlet UITextView *tourDescriptionField;
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
    //[imageFile saveInBackground];
    
    PFObject *newTour = [[PFObject alloc] initWithClassName:@"Tour"];
    [newTour setObject:self.tourNameField.text forKey:@"title"];
    [newTour setObject:self.tourDescriptionField.text forKey:@"description"];
    [newTour setObject:[PFUser currentUser] forKey:@"creator"];
    //[newTour saveInBackground];
    
    PFObject *firstPoint = [[PFObject alloc] initWithClassName:@"TourPoint"];
    [firstPoint setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude] forKey:@"latitude"];
    [firstPoint setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude] forKey:@"longitude"];
    [firstPoint setObject:@"Temp title" forKey:@"title"];
    [firstPoint setObject:imageFile forKey:@"image"];
    [firstPoint setObject:newTour forKey:@"tour"];
    [firstPoint saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            TourViewController *tourController = [[TourViewController alloc] initWithTour:newTour];
            UINavigationController *navcon = self.navigationController;
            [navcon popViewControllerAnimated:NO];
            [navcon pushViewController:tourController animated:YES];
            [tourController release];
        }
    }];

    [newTour release];
    [firstPoint release];
    
    

    /** Get close venues given a position
     #define FOURSQUARE_CLIENT_ID "I4VMDYZB00XTJMRHJKEUQHDBLRVRXSITCS5PBGVT1LG5FZWL"
     #define FOURSQUARE_CLIENT_SECRET "ZSHJXFEIF3TWKMVXA35PBQSTLRLVDWEGBGZTCA500DKIR4ZS"

    NSURL *placeNamesURl = [NSURL URLWithString:[@"https://api.foursquare.com/v2/venues/explore?" stringByAppendingFormat:@"ll=%f,%f&radius=%d&time=any&day=any&client_id=%s&client_secret=%s",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude,200,FOURSQUARE_CLIENT_ID,FOURSQUARE_CLIENT_SECRET]];
    NSURLRequest *request = [NSURLRequest requestWithURL:placeNamesURl];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *data =[[[[JSON valueForKey:@"response" ] valueForKey:@"groups" ]
                                lastObject] valueForKey:@"items"];
            NSMutableArray *venues = [NSMutableArray array];
            for (NSDictionary *venueData in data) {
                [venues addObject:[[venueData objectForKey:@"venue"] objectForKey:@"name"]];
            }
            NSLog(@"Venues: %@",venues);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"%@",error);
        }];
    
    [operation start];
    **/
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    [tourDescriptionField.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [tourDescriptionField.layer setBorderWidth:4.0];
    [tourDescriptionField.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [tourDescriptionField.layer setCornerRadius:5.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
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
