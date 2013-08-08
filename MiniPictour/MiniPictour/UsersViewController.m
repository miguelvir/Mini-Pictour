//
//  UsersViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 07/08/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "UsersViewController.h"
#import "AFImageRequestOperation.h"
#import "UserToursViewController.h"
@interface UsersViewController ()

@end

@implementation UsersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *tempQuery = [PFUser query];
    if([PFUser currentUser]){
        [tempQuery whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    }
    [tempQuery orderByAscending:@"name"];
    return tempQuery;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"UsersCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square",[object valueForKey:@"facebookId"]]];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    AFImageRequestOperation *imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest success:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    [imageOperation start];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserToursViewController *userTours = [[UserToursViewController alloc] initWithClassName:@"Tour" forUser:(PFUser *)[self objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:userTours animated:YES];
    [userTours release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
