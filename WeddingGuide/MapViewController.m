//
//  MapViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/17/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController () {
   GMSMapView* mapView_;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Create a GMSCameraPosition that tells the map to display the
  // coordinate -33.86,151.20 at zoom level 6.
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.lat
                                                          longitude:self.lon
                                                               zoom:17];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.settings.compassButton = YES;
  mapView_.myLocationEnabled = YES;
  self.view = mapView_;

  // Creates a marker in the center of the map.
  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.position = CLLocationCoordinate2DMake(self.lat,self.lon);
  marker.title = self.markerTitle;
  marker.snippet = self.markerSnippet;
  marker.map = mapView_;
}

@end
