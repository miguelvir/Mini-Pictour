//
//  NewTourPointViewController.h
//  MiniPictour
//
//  Created by Miguel Elvir on 29/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTourPointViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *noTitleButton;
    NSArray *venuesName;
}
@end
