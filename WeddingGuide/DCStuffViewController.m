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

  UISegmentedControl* filter = [[UISegmentedControl alloc]
      initWithItems:@[ @"Eats", @"Places" ]];
  filter.selectedSegmentIndex = 0;
  [filter sizeToFit];
  self.navigationItem.titleView = filter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
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
