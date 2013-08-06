//
//  UserToursViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 30/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "UserToursViewController.h"
#import "TourCell.h"
#import "TourCreationViewController.h"
#import "TourDescriptionViewController.h"

@interface UserToursViewController ()
    @property (readonly, retain) PFUser *user;
    @property (retain) UIImagePickerController *imagePicker;
@end

@implementation UserToursViewController

@synthesize user, imagePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithClassName:(NSString *)aClassName forUser:(PFUser *)aUser
{
    self = [super initWithClassName:aClassName];
    if (self) {
        user = [aUser retain];
    }
    return self;
}
- (PFQuery *)queryForTable
{
    PFQuery *tempQuery = [[PFQuery alloc] initWithClassName:@"Tour"];
    [tempQuery whereKey:@"creator" equalTo:user];
    return [tempQuery autorelease];
}

// Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"UserTourListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[TourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andTour:object ] autorelease];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[PFUser currentUser] valueForKey:@"name"] stringByAppendingString:@"'s Tours"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// End of Data Source Methods

// Table view Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TourDescriptionViewController *tourViewController = [[TourDescriptionViewController alloc] initWithTour:[self objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:tourViewController animated:YES];
    [tourViewController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *addTour = [[UIBarButtonItem alloc]initWithTitle:@"New Tour" style:UIBarButtonItemStylePlain target:self action:@selector(newTour)];
    self.navigationItem.rightBarButtonItem = addTour;
    [addTour release];

    self.textKey = @"title";
    //self.imageKey = @"image";
    self.paginationEnabled = NO;
}

- (void)newTour
{
    if (!imagePicker){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add a new Point" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo",@"Select from Gallery", nil];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    } else {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Muajaja");
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.showsCameraControls = YES;
            break;
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
    }
    [self presentViewController:imagePicker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        TourCreationViewController *tourCreator = [[TourCreationViewController alloc] init];
        [tourCreator setTitle:@"Create new Tour"];
        [self.navigationController pushViewController:tourCreator animated:YES];
        [tourCreator.imageView setImage:image];
        [tourCreator release];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [user release];
    [super dealloc];
}
@end
