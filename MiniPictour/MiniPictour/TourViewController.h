//
//  TourViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface TourViewController : UIViewController <MKMapViewDelegate>
{
    PFObject *tour;
    NSArray *tourPoints;
    IBOutlet MKMapView *mapView;
}

- (id)initWithTour:(PFObject *)tour;
@end
