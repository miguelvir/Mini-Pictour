//
//  MiniPictourMapViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 23/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "MiniPictourMapViewController.h"
#import "Annotation.h"
#import "TourCreationViewController.h"
#import "TourPointViewController.h"
@interface MiniPictourMapViewController ()
@property (assign) IBOutlet MKMapView *mapView;
@property (retain) PFUser *user;
@end

@implementation MiniPictourMapViewController
@synthesize userInitialLocation;
@synthesize mapView;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(PFUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)loadTours
{
    PFQuery *query = [PFQuery queryWithClassName:@"Tour"];
    [query whereKey:@"creator" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int count = 0;
        int actualColor = 0;
        for (PFObject *tour in objects) {
            actualColor = (count % 3);
            count++;
            PFQuery *query2 = [PFQuery queryWithClassName:@"TourPoint"];
            [query2 whereKey:@"tour" equalTo:tour];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *tourPoint in objects) {
                    Annotation *tempAnnotation = [Annotation annotationWithTourPoint:tourPoint];
                    tempAnnotation.headColor = actualColor;
                    [mapView addAnnotation: tempAnnotation];
                }
            }];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"TourAnnotationIdentifier";
    
    if([annotation isKindOfClass:[Annotation class]]){
        MKPinAnnotationView *aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        Annotation *myAnnotation = (Annotation *)annotation;        
        [[myAnnotation.tourPoint objectForKey:@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            tempView.image = [UIImage imageWithData:data];
            aView.leftCalloutAccessoryView = tempView;
            [tempView release];
        }];
        
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        aView.annotation = annotation;
        aView.canShowCallout = YES;
        aView.pinColor = myAnnotation.headColor;
        return [aView autorelease];
        
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Annotation *myAnnotation = view.annotation;
    TourPointViewController *tourPoint = [[TourPointViewController alloc] initWithTourPoint:myAnnotation.tourPoint];
    [self.navigationController pushViewController:tourPoint animated:YES];
    [tourPoint release];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!userInitialLocation)
    {
        self.userInitialLocation = userLocation.location;
        
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.01, 0.01);
        
        region = [self.mapView regionThatFits:region];
        [self.mapView setRegion:region animated:YES];
        //[self.mapView addAnnotation:[[[Annotation alloc] initWithCLLocation:userInitialLocation.coordinate andTitle:@"Initial Location" andSubtitle:@"User initial location"]autorelease]];

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    UIBarButtonItem *addTour = [[UIBarButtonItem alloc]initWithTitle:@"New Tour" style:UIBarButtonItemStylePlain target:self action:@selector(newTour)];
    self.navigationItem.rightBarButtonItem = addTour;
    [addTour release];
    [self loadTours];

    //[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES ];
}

- (void)newTour
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Allow editing of image ?
        imagePicker.allowsEditing = YES;
        
        imagePicker.showsCameraControls = YES;
    } else {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate= self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [imagePicker release];

}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{

        TourCreationViewController *tourCreator = [[TourCreationViewController alloc] init];
        [tourCreator setTitle:@"Create new Tour"];
        [self.navigationController pushViewController:tourCreator animated:YES];
        [tourCreator.imageView setImage:image];
        [tourCreator release];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [user release];
    [userInitialLocation release];
    [super dealloc];
}
@end
