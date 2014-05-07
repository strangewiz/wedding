//
//  DCStuffViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/16/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "DCStuffViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"

@interface DCStuffViewController () {
  NSArray* dcstuff_;
  NSArray* dceats_;
  UIBarButtonItem* rightButton_;
  UISegmentedControl* segment_;
  GMSMapView* mapView_;
  IBOutlet UITableView* table_;
  BOOL showAllLocations_;
}

@end

@implementation DCStuffViewController

- (void)awakeFromNib {

  NSString* filePath =
      [[NSBundle mainBundle] pathForResource:@"dcstuff" ofType:@"json"];
  NSData* data = [NSData dataWithContentsOfFile:filePath];
  __autoreleasing NSError* error = nil;
  dcstuff_ = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];

  filePath =
      [[NSBundle mainBundle] pathForResource:@"dceats" ofType:@"json"];
  data = [NSData dataWithContentsOfFile:filePath];
  error = nil;
  dceats_ = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];

  showAllLocations_ = NO;
  
  segment_ = [[UISegmentedControl alloc] initWithItems:@[ @"Eats", @"To Do" ]];
  segment_.selectedSegmentIndex = 0;
  [segment_ addTarget:self
                action:@selector(segmentChanged:)
      forControlEvents:UIControlEventValueChanged];
  [segment_ sizeToFit];
  self.navigationItem.titleView = segment_;

  rightButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
  rightButton_ =
      [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                       style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(toggleTableMap)];
  self.navigationItem.rightBarButtonItem = rightButton_;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}



- (void)segmentChanged:(id)sender {
  // Update table view controller for segment_.selectedSegmentIndex.
  if (showAllLocations_) {
    [self toggleTableMap];
  }
  [table_ reloadData];
}

- (void)toggleTableMap {
  if (!mapView_) {
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:38.90723
                                                            longitude:-77.03646
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.hidden = YES;
    [self.view addSubview:mapView_];

  }
  [mapView_ clear];
  NSArray* data = [self getData];
  for (NSDictionary* dict in data) {
    GMSMarker* marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([dict[@"lat"] floatValue],
                                                 [dict[@"lon"] floatValue]);
    marker.title = dict[@"title"];
    marker.snippet = dict[@"snippet"];
    marker.map = mapView_;
  }

  [UIView transitionWithView:self.view
                    duration:1
                     options:UIViewAnimationOptionTransitionFlipFromRight |
   UIViewAnimationOptionAllowAnimatedContent
                  animations:^() {
                    table_.hidden = !showAllLocations_;
                    mapView_.hidden = showAllLocations_;
                  }
                  completion:^(BOOL finished) {
                    showAllLocations_ = !showAllLocations_;
                  }];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
  UITableViewCell* cell = (UITableViewCell*)sender;
  NSDictionary* agenda = [self itemForRow:[table_ indexPathForCell:cell].row];
  if ([segue.destinationViewController
       isKindOfClass:[MapViewController class]]) {
    MapViewController* controller = (MapViewController*)segue.destinationViewController;
    controller.lat = [agenda[@"lat"] floatValue];
    controller.lon = [agenda[@"lon"] floatValue];
    controller.title = agenda[@"title"];
    controller.markerTitle = agenda[@"title"];
    controller.markerSnippet = agenda[@"snippet"];
  }
}

- (NSArray*)getData {
  return segment_.selectedSegmentIndex == 0 ? dceats_ : dcstuff_;
}

- (NSDictionary*)itemForRow:(NSInteger)row {
  NSArray* data = [self getData];
  return data[row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSArray* data = [self getData];
  return [data count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* cellIdentifier = @"mapcell";
  UITableViewCell* cell =
  [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                  forIndexPath:indexPath];
  NSDictionary* dcthing = [self itemForRow:indexPath.row];
  cell.textLabel.text = dcthing[@"title"];
  return cell;
}

@end
