//
//  TourPointViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 02/08/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourPointViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TourPointViewController ()

@end

@implementation TourPointViewController

@synthesize scrollView, tourPointDescription;
@synthesize tourPoint, imageView, editSaveTourPointButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTourPoint:(PFObject *)aTourPoint
{
    self = [super init];
    if (self) {
        self.tourPoint = aTourPoint;
        [[tourPoint objectForKey:@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
            [scrollView addSubview: imageView];
            scrollView.minimumZoomScale = 0.25;
            scrollView.maximumZoomScale = 1;
            [scrollView setContentSize:imageView.image.size];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    editSaveTourPointButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTourPoint)];
    self.navigationItem.rightBarButtonItem = editSaveTourPointButton;
    self.editing = NO;
    
    tourPointDescription.text = [tourPoint valueForKey:@"details"];
    [tourPointDescription.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [tourPointDescription.layer setBorderWidth:4.0];
    [tourPointDescription.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [tourPointDescription.layer setCornerRadius:5.0];
    
    self.title = [tourPoint valueForKey:@"title"];
}

- (void)editTourPoint
{
    if(self.editing){
        self.editing = NO;
        [editSaveTourPointButton setTitle:@"Edit"];
        [tourPointDescription setEditable:NO];
        //Save changes
        [tourPoint setObject:tourPointDescription.text forKey:@"details"];
    }else{
        self.editing = YES;
        [editSaveTourPointButton setTitle:@"Save"];
        [tourPointDescription setEditable:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [tourPoint release];
    [imageView release];
    [editSaveTourPointButton release];
    [super dealloc];
}

@end
