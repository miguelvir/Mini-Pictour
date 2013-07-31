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
#import "TourViewController.h"

@interface UserToursViewController ()
@end

@implementation UserToursViewController

@synthesize user;

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
    //    cell.imageView.image =  [UIImage imageWithData:[[object objectForKey:@"image"] getData] ];
    [[object objectForKey:@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
        [cell.imageView setNeedsDisplay];
        [cell setNeedsDisplay];
    }];
    

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
    TourViewController *tourViewController = [[TourViewController alloc] initWithTour:[self objectAtIndexPath:indexPath]];
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
    self.imageKey = @"image";
    self.paginationEnabled = NO;
}

- (void)newTour
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Allow editing of image ?
        imagePicker.allowsEditing = YES;
        
        imagePicker.showsCameraControls = YES;
    } else {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate= self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [imagePicker release];
    
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
