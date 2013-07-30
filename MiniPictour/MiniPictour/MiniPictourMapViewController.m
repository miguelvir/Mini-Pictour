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
@interface MiniPictourMapViewController ()
@property (assign) IBOutlet MKMapView *mapView;
@end

@implementation MiniPictourMapViewController
@synthesize userInitialLocation;
@synthesize mapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
        [self.mapView addAnnotation:[[[Annotation alloc] initWithCLLocation:userInitialLocation.coordinate andTitle:@"Initial Location" andSubtitle:@"User initial location"]autorelease]];

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
    [userInitialLocation release];
    [super dealloc];
}
@end
