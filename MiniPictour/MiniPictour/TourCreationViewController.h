//
//  TourCreationViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 24/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface TourCreationViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    IBOutlet UITextField *tourNameField;
    IBOutlet UITextView *tourDescriptionField;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (assign) IBOutlet UIImageView *imageView;
@property (assign) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (retain) CLLocationManager *locationManager;
@property (retain) CLLocation *currentLocation;

@end
