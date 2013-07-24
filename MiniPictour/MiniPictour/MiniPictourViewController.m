//
//  MiniPictourViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 22/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "MiniPictourViewController.h"
#import "MiniPictourMapViewController.h"
@interface MiniPictourViewController ()
@property (assign) IBOutlet UIActivityIndicatorView *loadingImage;
@property (assign) IBOutlet UIButton *login_logoutButton;
@property (assign) IBOutlet UIView *imageView;
@property (retain) FBProfilePictureView *userImage;
@property (assign) IBOutlet UIButton *goToMapButton;
@end

@implementation MiniPictourViewController

@synthesize loadingImage, login_logoutButton, userImage, imageView, goToMapButton;

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
    NSLog(@"View Did Load");
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [loadingImage startAnimating];
        [login_logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
        userImage = [[FBProfilePictureView alloc] initWithFrame:self.imageView.frame];
        [self.imageView addSubview:self.userImage];
        self.userImage.profileID = [[PFUser currentUser] objectForKey:@"facebookId"];
        [self.loadingImage stopAnimating];
        self.goToMapButton.hidden = NO;

    }
}
- (IBAction)loginButtonTaped:(UIButton *)sender  {
    // The permissions requested from the user
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [PFUser logOut];
        [self.login_logoutButton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.userImage removeFromSuperview];
        self.goToMapButton.hidden = YES;
        self.userImage = nil;
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
                            [user saveInBackground];
                            
                            
                            [userImage removeFromSuperview];
                            self.userImage = nil;
                            userImage = [[FBProfilePictureView alloc] initWithFrame:self.imageView.frame];
                            [self.imageView addSubview:self.userImage];
                            self.userImage.profileID = userData[@"id"];
                        }
                    }];
                } else {
                    [userImage removeFromSuperview];
                    self.userImage = nil;
                    userImage = [[FBProfilePictureView alloc] initWithFrame:self.imageView.frame];
                    [self.imageView addSubview:self.userImage];
                    self.userImage.profileID = [[PFUser currentUser] objectForKey:@"facebookId"];
                }
                [self.loadingImage stopAnimating];
                self.goToMapButton.hidden = NO;
                /*
                 NSLog(@"User with facebook logged in!");
                 [self.navigationController pushViewController:[[UserDetailsViewController alloc]    initWithStyle:UITableViewStyleGrouped] animated:YES];
                */
            }
        }];
    }
}

- (IBAction)goToMapTapped:(UIButton *)sender
{
    MiniPictourMapViewController *mapViewController = [[MiniPictourMapViewController alloc] init];
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //[login_logoutButton release];
    //[loadingImage release];
    //[userImage release];
    //[imageView release];
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
