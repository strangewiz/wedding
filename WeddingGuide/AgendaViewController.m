//
//  AgendaViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/16/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "AgendaViewController.h"

#import "AgendaDetailViewController.h"
#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface AgendaViewController () {
  NSArray* agendaData_;
  NSArray* placesData_;
  UIBarButtonItem* rightButton_;
  UISegmentedControl* segment_;
  IBOutlet UITableView* table_;
  IBOutlet NSString* agendaDetail_;
  BOOL showBridalParty_;
  BOOL showAllLocations_;
  GMSMapView* mapView_;
}
@end

@implementation AgendaViewController

- (void)awakeFromNib {
  NSString* filePath =
      [[NSBundle mainBundle] pathForResource:@"agenda" ofType:@"json"];
  NSData* data = [NSData dataWithContentsOfFile:filePath];
  __autoreleasing NSError* error = nil;
  agendaData_ = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];
  showAllLocations_ = NO;

  filePath =
      [[NSBundle mainBundle] pathForResource:@"agenda_places" ofType:@"json"];
  data = [NSData dataWithContentsOfFile:filePath];
  error = nil;
  placesData_ = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];

  segment_ =
      [[UISegmentedControl alloc] initWithItems:@[ @"Timeline", @"Places" ]];
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
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  showBridalParty_ = [defaults boolForKey:@"bridal_party"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)segmentChanged:(id)sender {
  // Update table view controller for segment_.selectedSegmentIndex.
  if (segment_.selectedSegmentIndex == 1) {
    self.navigationItem.rightBarButtonItem = rightButton_;
  } else {
    self.navigationItem.rightBarButtonItem = nil;
    if (showAllLocations_) {
      [self toggleTableMap];
    }
  }
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  showBridalParty_ = [defaults boolForKey:@"bridal_party"];
  [table_ reloadData];
}

- (void)toggleTableMap {
  if (!mapView_) {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:38.89034
                                                            longitude:-77.07379
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.hidden = YES;
    [self.view addSubview:mapView_];

    for (NSDictionary* dict in placesData_) {
      if (!showBridalParty_ && dict[@"bridal_party"] != nil)
        continue;
      GMSMarker* marker = [[GMSMarker alloc] init];
      marker.position = CLLocationCoordinate2DMake([dict[@"lat"] floatValue],
                                                   [dict[@"lon"] floatValue]);
      marker.title = dict[@"title"];
      marker.snippet = dict[@"snippet"];
      marker.map = mapView_;
    }
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
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
  } else if ([segue.destinationViewController
                 isKindOfClass:[AgendaDetailViewController class]]) {
    AgendaDetailViewController* controller = (AgendaDetailViewController*)segue.destinationViewController;
    controller.text = agenda[@"details"];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  return 1;
}

- (NSInteger)itemCount {
  NSUInteger count = 0;
  NSArray* data =
      segment_.selectedSegmentIndex == 0 ? agendaData_ : placesData_;

  for (NSDictionary* dict in data) {
    if (!showBridalParty_ && dict[@"bridal_party"] != nil)
      continue;
    count++;
  }
  return count;
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self itemCount];
}

- (NSDictionary*)itemForRow:(NSInteger)row {
  NSUInteger actualRow = 0;
  NSArray* data =
      segment_.selectedSegmentIndex == 0 ? agendaData_ : placesData_;
  for (NSDictionary* dict in data) {
    if (!showBridalParty_ && dict[@"bridal_party"] != nil)
      continue;
    if (actualRow == row)
      return dict;
    actualRow++;
  }
  return nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  if([sender isKindOfClass:[UITableViewCell class]]) {
    UITableViewCell* cell = (UITableViewCell*)sender;
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
      return YES;
    }
  }
  return NO;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
    agendaCellForRowAtIndexPath:(NSIndexPath*)indexPath {
  UITableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:@"agendacell"
                                      forIndexPath:indexPath];
  NSDictionary* agenda = [self itemForRow:indexPath.row];
  cell.textLabel.text = agenda[@"title"];
  if (agenda[@"details"] != nil) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return cell;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
     mapCellForRowAtIndexPath:(NSIndexPath*)indexPath {
  UITableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:@"mapcell"
                                      forIndexPath:indexPath];
  NSDictionary* places = [self itemForRow:indexPath.row];
  cell.textLabel.text = places[@"title"];
  return cell;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  if (segment_.selectedSegmentIndex == 0) {
    return [self tableView:tableView agendaCellForRowAtIndexPath:indexPath];
  } else {
    return [self tableView:tableView mapCellForRowAtIndexPath:indexPath];
  }
}

@end
