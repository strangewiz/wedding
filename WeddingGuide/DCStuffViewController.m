//
//  DCStuffViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/16/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "DCStuffViewController.h"

@interface DCStuffViewController () {
  NSArray* data_;
  UIBarButtonItem* rightButton_;
  UISegmentedControl* segment_;
}

@end

@implementation DCStuffViewController

- (void)awakeFromNib {
  NSString* filePath =
      [[NSBundle mainBundle] pathForResource:@"dcstuff" ofType:@"json"];
  NSData* data = [NSData dataWithContentsOfFile:filePath];
  __autoreleasing NSError* error = nil;
  data_ = [NSJSONSerialization JSONObjectWithData:data
                                          options:kNilOptions
                                            error:&error];

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
}

- (void)toggleTableMap {

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
  static NSString* cellIdentifier = @"cell";

  [tableView registerClass:[UITableViewCell class]
    forCellReuseIdentifier:cellIdentifier];
  UITableViewCell* cell =
  [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                  forIndexPath:indexPath];
  cell.textLabel.text = data_[indexPath.row][@"name"];
  return cell;
}

@end
