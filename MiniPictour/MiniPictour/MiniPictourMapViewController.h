//
//  MiniPictourMapViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 23/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
@interface MiniPictourMapViewController : UIViewController <MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKAnnotation>
{
    IBOutlet MKMapView *mapView;
    CLLocation *userInitialLocation;
    PFUser *user;
}
- (void)newTour;
- (id)initWithUser:(PFUser *)user;

@property (retain) CLLocation *userInitialLocation;
@end
