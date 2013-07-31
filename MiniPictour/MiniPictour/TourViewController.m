//
//  TourViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourViewController.h"
#import "Annotation.h"
#import "NewTourPointViewController.h"
@interface TourViewController ()
    @property (retain) PFObject *tour;
    @property (retain) NSArray *tourPoints;
    @property (assign) IBOutlet MKMapView *mapView;
    @property (assign) CLLocationCoordinate2D coordinate;
@end

@implementation TourViewController

@synthesize tour, tourPoints, mapView, coordinate;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[PFUser currentUser] valueForKey:@"objectId"] isEqual:[[tour objectForKey:@"creator"] valueForKey:@"objectId"]]){
        self.mapView.delegate = self;
        [self.mapView setShowsUserLocation:YES];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Add Point" style:UIBarButtonItemStyleBordered target:self action:@selector(newPoint)] autorelease];
    }else{
        NSLog(@"Current User: %@ \n Tour creator: %@ ",[[PFUser currentUser] valueForKey:@"objectId"], [[tour objectForKey:@"creator"] valueForKey:@"objectId"]);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.coordinate = userLocation.coordinate;
}

- (void)newPoint
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
    
    /**/
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        NewTourPointViewController *tourPointController =
            [[NewTourPointViewController alloc] initWithImage:image inCoordinate:coordinate forTour:tour];
        [tourPointController setTitle:@"Select Point title"];
        [self.navigationController pushViewController:tourPointController animated:YES];
        [tourPointController release];
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
    [tour release];
    [tourPoints release];
    [super dealloc];
}

@end
