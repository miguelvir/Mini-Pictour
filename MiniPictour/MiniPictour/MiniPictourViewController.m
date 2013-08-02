//
//  MiniPictourViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 22/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "MiniPictourViewController.h"
#import "MiniPictourMapViewController.h"
#import "UserToursViewController.h"

@interface MiniPictourViewController ()
@property (assign) IBOutlet UIActivityIndicatorView *loadingImage;
@property (assign) IBOutlet UIButton *login_logoutButton;
@property (assign) IBOutlet UIView *imageView;
@property (retain) FBProfilePictureView *userImage;
@end

@implementation MiniPictourViewController

@synthesize loadingImage, login_logoutButton, userImage, imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userImage = [[FBProfilePictureView alloc] initWithFrame:self.imageView.bounds];
    [self.imageView addSubview:self.userImage];
    self.userImage.profileID = nil;
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [loadingImage startAnimating];
        [login_logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
        self.userImage.profileID = [[PFUser currentUser] objectForKey:@"facebookId"];
        [self.loadingImage stopAnimating];
    }
}
- (IBAction)loginButtonTaped:(UIButton *)sender  {
    // The permissions requested from the user
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [PFUser logOut];
        [self.login_logoutButton setTitle:@"Log in" forState:UIControlStateNormal];
        self.userImage.profileID = nil;
        [self.tabBarController setViewControllers:@[self] animated:YES];
    } else {
        [self.loadingImage startAnimating];
        NSArray *permissionsArray = @[ @"basic_info"];
    
        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
            if (!user) {
                if (!error) {
                    NSLog(@"The user cancelled the Facebook login.");
                } else {
                    NSLog(@"An error occurred: %@", error);
                }
            } else {
                [self.login_logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
                
                if (![[PFUser currentUser] objectForKey:@"facebookId"]){
                    // Ask Facebook for data
                    FBRequest *request = [FBRequest requestForMe];
                    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if (!error) {
                            NSDictionary *userData = (NSDictionary *)result;
                            [user setObject:[NSString stringWithFormat:@"%@",userData[@"id"]] forKey:@"facebookId"];
                            [user setObject:[NSString stringWithFormat:@"%@",userData[@"username"]] forKey:@"facebookUsername"];
                            [user setObject:[NSString stringWithFormat:@"%@",userData[@"name"]] forKey:@"name"];
                            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if(succeeded){
                                    [self addTab];
                                }
                            }];
                            
                            self.userImage.profileID = userData[@"id"];
                            [self addTab];
                        }
                    }];
                } else {
                    self.userImage.profileID = [[PFUser currentUser] objectForKey:@"facebookId"];
                    [self addTab];
                }
                
                [self.loadingImage stopAnimating];
            }
        }];
    }
}

- (void)addTab
{
    UserToursViewController *userTours = [[UserToursViewController alloc] initWithClassName:@"Tour" forUser:[PFUser currentUser]];
    userTours.title = @"My Tours";
    UINavigationController *navTours = [[UINavigationController alloc]initWithRootViewController:userTours];
    
    MiniPictourMapViewController *map = [[MiniPictourMapViewController alloc] initWithUser:[PFUser  currentUser]];
    map.title = @"Map";
    UINavigationController *navTours2 = [[UINavigationController alloc]initWithRootViewController:map];

    [self.tabBarController setViewControllers:@[navTours,navTours2, self] animated:YES];
    [self.tabBarController setSelectedIndex:0];
    [userTours release];
    [navTours release];
    [map release];
    [navTours2 release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
   
    [userImage release];
    [super dealloc];
}

@end
