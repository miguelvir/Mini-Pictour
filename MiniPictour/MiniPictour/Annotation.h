//
//  Annotation.h
//  MiniPictour
//
//  Created by Miguel Elvir on 24/07/13.
//  Copyright (c) 2013 Miguel Elvir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>
{
    
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCLLocation:(CLLocationCoordinate2D)coordinate
                andTitle:(NSString *)title
                andSubtitle: (NSString *)subtitle;
@end
