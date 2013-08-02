//
//  TourPointViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 02/08/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface TourPointViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextView *tourPointDescription;
    UIBarButtonItem *editSaveTourPointButton;
    UIImageView *imageView;
    PFObject *tourPoint;
}

@property (assign) IBOutlet UIScrollView *scrollView;
@property (assign) IBOutlet UITextView *tourPointDescription;
@property (retain) UIBarButtonItem *editSaveTourPointButton;
@property (retain) UIImageView *imageView;
@property (retain) PFObject *tourPoint;

- (id)initWithTourPoint:(PFObject *)aTourPoint;

@end
