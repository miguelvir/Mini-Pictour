//
//  TourCell.h
//  MiniPictour
//
//  Created by Miguel Elvir on 31/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface TourCell : PFTableViewCell
{
    PFObject *tour;
}

@property (retain) PFObject *tour;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTour:(PFObject *)newTour;

@end
