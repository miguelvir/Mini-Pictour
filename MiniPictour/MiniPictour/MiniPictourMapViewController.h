//
//  MiniPictourMapViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 23/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MiniPictourMapViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
    CLLocation *userInitialLocation;
}
@property (retain) CLLocation *userInitialLocation;
@end
