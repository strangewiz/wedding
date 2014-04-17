//
//  AgendaViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/16/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "AgendaViewController.h"

@interface AgendaViewController () {
  NSArray* data_;
  UIBarButtonItem* rightButton_;
  UISegmentedControl* segment_;
  IBOutlet UITableView* table_;
}
@end

@implementation AgendaViewController

- (void)awakeFromNib {
  NSString* filePath =
      [[NSBundle mainBundle] pathForResource:@"agenda" ofType:@"json"];
  NSData* data = [NSData dataWithContentsOfFile:filePath];
  __autoreleasing NSError* error = nil;
  data_ = [NSJSONSerialization JSONObjectWithData:data
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

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* mapIdentifier = @"mapcell";
  static NSString* agendaIdentifier = @"cell";
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:agendaIdentifier];
  NSString* cellId = segment_.selectedSegmentIndex == 0 ? agendaIdentifier : mapIdentifier;
  UITableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:cellId
                                      forIndexPath:indexPath];
  cell.textLabel.text = data_[indexPath.row][@"name"];
  return cell;
}

@end
