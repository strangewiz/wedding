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
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                          longitude:151.20
                                                               zoom:6];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.myLocationEnabled = YES;
  self.view = mapView_;

  // Creates a marker in the center of the map.
  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
  marker.title = @"Sydney";
  marker.snippet = @"Australia";
  marker.map = mapView_;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
