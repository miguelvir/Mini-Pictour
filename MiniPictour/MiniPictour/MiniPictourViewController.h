//
//  MiniPictourViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 22/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
@interface MiniPictourViewController : UIViewController //<UIWebViewDelegate>
{
    IBOutlet UIActivityIndicatorView *loadingImage;
    IBOutlet UIButton *login_logoutButton;
    IBOutlet FBProfilePictureView *userImage;
}

@end
