//
//  TourDescriptionViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 31/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface TourDescriptionViewController : UIViewController
{
    IBOutlet UIImageView *image;
    IBOutlet UILabel *tourTitle;
    IBOutlet UITextView *tourDescription;
    PFObject *tour;
}
@property (assign) IBOutlet UIImageView *image;
@property (assign) IBOutlet UILabel *tourTitle;
@property (assign) IBOutlet UITextView *tourDescription;
@property (retain) PFObject *tour;

- (id)initWithTour:(PFObject *)tour;
@end
