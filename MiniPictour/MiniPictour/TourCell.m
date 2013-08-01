//
//  TourCell.m
//  MiniPictour
//
//  Created by Miguel Elvir on 31/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "TourCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TourCell

@synthesize tour;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTour:(PFObject *)newTour
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tour = newTour;
        [[tour objectForKey:@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData:data];
            });
        }];     
        self.textLabel.text = [tour valueForKey:@"title"];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    [tour release];
    [super dealloc];
}
@end
