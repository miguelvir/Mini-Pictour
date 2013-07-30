//
//  NewTourPointViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
@interface NewTourPointViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *noTitleButton;
    NSMutableArray *venuesName;
    CLLocationCoordinate2D coordinate;
    UIImage *image;
    PFObject *tour;
}

- (id)initWithImage:(UIImage *)image
       inCoordinate:(CLLocationCoordinate2D)coordinate
            forTour:(PFObject *)tour;
@end
