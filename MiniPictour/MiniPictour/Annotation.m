//
//  Annotation.m
//  MiniPictour
//
//  Created by Miguel Elvir on 24/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import "Annotation.h"
@implementation Annotation
@synthesize coordinate, title, subtitle;


- (id)initWithCLLocation:(CLLocationCoordinate2D)initialCoordinate
                andTitle:(NSString *)initialTitle
             andSubtitle: (NSString *)initialSubtitle
{
    self = [super init];
    if (self){
        self.coordinate = initialCoordinate;
        self.title = initialTitle;
        self.subtitle = initialSubtitle;
    }
    return self;

}

@end
