//
//  TourDescriptionViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 31/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourDescriptionViewController.h"
#import "TourViewController.h"
@interface TourDescriptionViewController ()

@end

@implementation TourDescriptionViewController

@synthesize image, tourDescription, tourTitle, tour;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTour:(PFObject *)tour
{
    self = [super init];
    if (self){
        self.tour = tour;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tourTitle.text = [tour valueForKey:@"title"];
    tourDescription.text = [tour valueForKey:@"details"];
    [[tour valueForKey:@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            image.image = [UIImage imageWithData:data];
        });
    }];
    UIBarButtonItem *viewTourInMap = [[UIBarButtonItem alloc]initWithTitle:@"View in Map" style:UIBarButtonItemStylePlain target:self action:@selector(viewInMap)];
    self.navigationItem.rightBarButtonItem = viewTourInMap;
    [viewTourInMap release];
    
    self.title = [tour valueForKey:@"title"];

}
- (void)viewInMap
{
    TourViewController *tourViewController = [[TourViewController alloc] initWithTour:tour];
    [self.navigationController pushViewController:tourViewController animated:YES];
    [tourViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [tour release];
    [super dealloc];
}

@end
