//
//  ACPNote.h
//  ACPNotes
//
//  Created by Anna Parks on 3/16/13.
//  Copyright (c) 2013 Anna Parks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ACPNote : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property CLLocationCoordinate2D location;

- (CLLocationCoordinate2D)getLocation;



@end
