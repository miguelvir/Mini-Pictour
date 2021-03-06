//
//  TourCreationViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 24/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourCreationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TourViewController.h"
#import "MBProgressHUD.h"
@interface TourCreationViewController ()
    @property (assign) IBOutlet UITextField *tourNameField;
    @property (assign) IBOutlet UITextView *tourDescriptionField;
    @property (assign) IBOutlet UIButton *saveButton;
    @property (assign) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation TourCreationViewController

@synthesize imageView, scrollView;
@synthesize tourNameField, tourDescriptionField, saveButton, loadingIndicator;
@synthesize locationManager, currentLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)beginLoading
{
    [tourDescriptionField resignFirstResponder];
    [tourNameField resignFirstResponder];
}

- (IBAction)saveTourTapped:(UIButton *)sender
{
    if (tourNameField.text && tourDescriptionField){
        [self beginLoading];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        //[imageFile saveInBackground];
    
        PFObject *newTour = [[PFObject alloc] initWithClassName:@"Tour"];
        [newTour setObject:self.tourNameField.text forKey:@"title"];
        [newTour setObject:self.tourDescriptionField.text forKey:@"details"];
        [newTour setObject:[PFUser currentUser] forKey:@"creator"];
        [newTour setObject:imageFile forKey:@"image"];
        //[newTour saveInBackground];
    
        PFObject *firstPoint = [[PFObject alloc] initWithClassName:@"TourPoint"];
        [firstPoint setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude] forKey:@"latitude"];
        [firstPoint setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude] forKey:@"longitude"];
        [firstPoint setObject:self.tourNameField.text forKey:@"title"];
        [firstPoint setObject:@"" forKey:@"details"];
        [firstPoint setObject:imageFile forKey:@"image"];
        [firstPoint setObject:newTour forKey:@"tour"];
        [firstPoint saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    TourViewController *tourController = [[TourViewController alloc] initWithTour:newTour];
                    UINavigationController *navcon = self.navigationController;
                    [navcon popViewControllerAnimated:NO];
                    [navcon pushViewController:tourController animated:YES];
                    [tourController release];
                });                
            }
        }];
   
        [newTour release];
        [firstPoint release];
    }
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
