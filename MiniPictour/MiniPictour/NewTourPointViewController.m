//
//  NewTourPointViewController.m
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "NewTourPointViewController.h"

@interface NewTourPointViewController ()
@property (retain) NSArray *venuesName;
@property (assign) IBOutlet UITableView *tableView;
@property (assign) IBOutlet UIButton *noTitleButton;
@end

@implementation NewTourPointViewController

@synthesize venuesName, tableView, noTitleButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [venuesName objectAtIndex:indexPath.row];
    return cell;
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

@end
