//
//  MiniPictourViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 22/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "MiniPictourViewController.h"
@interface MiniPictourViewController ()
@property (retain) IBOutlet UIActivityIndicatorView *loadingImage;
@property (retain) IBOutlet UIButton *login_logoutButton;
@property (retain) IBOutlet UIView *imageView;
@property (retain) IBOutlet FBProfilePictureView *userImage;
@end

@implementation MiniPictourViewController

@synthesize loadingImage, login_logoutButton, userImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define CLIENT_ID       @"I4VMDYZB00XTJMRHJKEUQHDBLRVRXSITCS5PBGVT1LG5FZWL"
#define CLIENT_SECRET   @"ZSHJXFEIF3TWKMVXA35PBQSTLRLVDWEGBGZTCA500DKIR4ZS"
#define CALLBACK_URL    @"http://pictour.us/"
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /* Test for sending an object to Parse
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
     */
    
    /* Test for foursquare authentication
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    self.webView.delegate = self;
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@", CLIENT_ID, CALLBACK_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
     */
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [self.loadingImage startAnimating]; // Hide loading indicator
        [self.login_logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                userImage = [[FBProfilePictureView alloc] initWithFrame:self.imageView.frame];
                [self.imageView addSubview:self.userImage];
                NSDictionary *userData = (NSDictionary *)result;
                NSString *facebookID = userData[@"id"];
                self.userImage.profileID = facebookID;
                [self.loadingImage stopAnimating]; // Hide loading indicator
            }
        }];

    }
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [PFUser logOut];
        [self.login_logoutButton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.userImage removeFromSuperview];

        self.userImage = nil;
    } else {
        [self.loadingImage startAnimating];
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
            if (!user) {
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                }
            } else {
                [self.login_logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
                FBRequest *request = [FBRequest requestForMe];
            
                // Send request to Facebook
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        [self.userImage removeFromSuperview];
                        self.userImage = nil;
                        userImage = [[FBProfilePictureView alloc] initWithFrame:self.imageView.frame];
                        [self.imageView addSubview:self.userImage];
                        NSDictionary *userData = (NSDictionary *)result;
                        NSString *facebookID = userData[@"id"];
                        self.userImage.profileID = facebookID;
                        [self.loadingImage stopAnimating]; // Hide loading indicator
                        
                    }
                }];
                /*
                 NSLog(@"User with facebook logged in!");
                 [self.navigationController pushViewController:[[UserDetailsViewController alloc]    initWithStyle:UITableViewStyleGrouped] animated:YES];
                */
            }
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [login_logoutButton release];
    [loadingImage release];
    [userImage release];
    [super dealloc];
}
/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"itms-apps"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *URLString = [[self.webView.request URL] absoluteString];
    NSLog(@"--> %@", URLString);
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }
}
*/

@end
