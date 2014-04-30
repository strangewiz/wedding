//
//  AgendaViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/16/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "AgendaViewController.h"

@interface AgendaViewController () {
  NSArray* agendaData_;
  NSArray* placesData_;
  UIBarButtonItem* rightButton_;
  UISegmentedControl* segment_;
  IBOutlet UITableView* table_;
  IBOutlet NSString* agendaDetail_;
  BOOL showBridalParty_;
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)segmentChanged:(id)sender {
  // Update table view controller for segment_.selectedSegmentIndex.
  if (segment_.selectedSegmentIndex == 1) {
    self.navigationItem.rightBarButtonItem = rightButton_;
  } else {
    self.navigationItem.rightBarButtonItem = nil;
  }
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  showBridalParty_ = [defaults boolForKey:@"bridal_party"];
  [table_ reloadData];
}

- (void)toggleTableMap {
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
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

- (UITableViewCell*)tableView:(UITableView*)tableView
    agendaCellForRowAtIndexPath:(NSIndexPath*)indexPath {
//  [tableView registerClass:[UITableViewCell class]
//      forCellReuseIdentifier:@"agendacell"];
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
