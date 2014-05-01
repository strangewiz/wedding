//
//  MapViewController.h
//  WeddingGuide
//
//  Created by Justin Cohen on 4/17/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lon;
@property (nonatomic, strong) NSString* markerTitle;
@property (nonatomic, strong) NSString* markerSnippet;


@end
