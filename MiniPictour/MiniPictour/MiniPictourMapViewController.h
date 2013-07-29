//
//  MiniPictourMapViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 23/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MiniPictourMapViewController : UIViewController <MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet MKMapView *mapView;
    CLLocation *userInitialLocation;
}
- (void)newTour;

@property (retain) CLLocation *userInitialLocation;
@end
