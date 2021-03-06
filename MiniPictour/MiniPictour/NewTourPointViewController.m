//
//  NewTourPointViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "NewTourPointViewController.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"

@interface NewTourPointViewController ()
    @property (retain) NSMutableArray *venuesName;
    @property (assign) CLLocationCoordinate2D coordinate;
    @property (retain) PFObject *tour;
    @property (retain) UIImage *image;
    @property (copy) NSDictionary *tempVenue;

    @property (assign) IBOutlet UITableView *tableView;
    @property (assign) IBOutlet UIButton *noTitleButton;
@end

@implementation NewTourPointViewController

@synthesize tableView, noTitleButton;
@synthesize venuesName, coordinate, tour, image,  tempVenue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)image inCoordinate:(CLLocationCoordinate2D)coordinate forTour:(PFObject *)tour
{
    self = [super init];
    if (self){
        self.image = image;
        self.coordinate = coordinate;
        self.tour = tour;
        self.venuesName = [NSMutableArray array];
        [self searchVenuesName];
    }
    return self;
}
- (void)searchVenuesName
{
#define FOURSQUARE_CLIENT_ID "I4VMDYZB00XTJMRHJKEUQHDBLRVRXSITCS5PBGVT1LG5FZWL"
#define FOURSQUARE_CLIENT_SECRET "ZSHJXFEIF3TWKMVXA35PBQSTLRLVDWEGBGZTCA500DKIR4ZS"
    
    NSURL *placeNamesURl = [NSURL URLWithString:[@"https://api.foursquare.com/v2/venues/explore?" stringByAppendingFormat:@"ll=%f,%f&radius=%d&time=any&day=any&client_id=%s&client_secret=%s",coordinate.latitude, coordinate.longitude,200,FOURSQUARE_CLIENT_ID,FOURSQUARE_CLIENT_SECRET]];
    NSURLRequest *request = [NSURLRequest requestWithURL:placeNamesURl];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *data =[[[[JSON valueForKey:@"response" ] valueForKey:@"groups" ]
                              lastObject] valueForKey:@"items"];
            int count = 0;
            
            for (NSDictionary *venueData in data) {
                self.tempVenue = [venueData objectForKey:@"venue"];
                [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]];
                count++;
            }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];
    
    [operation start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [venuesName count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Venues near you";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VenueListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[venuesName objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[venuesName objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSDictionary *location = [[venuesName objectAtIndex:indexPath.row] objectForKey:@"location"];
    [self createTourPointWithTitle:title andCoordinate:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue])];
}

- (void)createTourPointWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D) coordinate;
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    PFObject *newTourPoint = [PFObject objectWithClassName:@"TourPoint"];
    [newTourPoint setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
    [newTourPoint setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
    [newTourPoint setObject:title forKey:@"title"];
    [newTourPoint setObject:tour forKey:@"tour"];
    [newTourPoint setObject:imageFile forKey:@"image"];
    
    [newTourPoint saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self goBack];
            });            
        }
    }];
}


- (IBAction)noTitleButtonTapped:(UIButton *)sender
{
    NSString *title = [NSString stringWithFormat:@"Location: %f , %f",coordinate.latitude, coordinate.longitude];
    [self createTourPointWithTitle:title andCoordinate:coordinate];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleInsert){
        [venuesName addObject:tempVenue];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [tempVenue release];
    [venuesName release];
    [tour release];
    [image release];
    [super dealloc];
}

@end
