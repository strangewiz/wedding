//
//  AgendaDetailViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/30/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "AgendaDetailViewController.h"

@interface AgendaDetailViewController ()
@property (nonatomic, strong) IBOutlet UITextView* textView;
@end

@implementation AgendaDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.textView.text =self.text;
}
@end
