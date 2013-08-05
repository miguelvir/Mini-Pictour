//
//  UserToursViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 30/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserToursViewController : PFQueryTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    PFUser *user;
}

@property (readonly, retain) PFUser *user;

- (id)initWithClassName:(NSString *)aClassName forUser:(PFUser *)aUser;

@end
