//
//  ViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/16/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self performSelector:@selector(showTabs) withObject:nil afterDelay:2];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)showTabs {
  [self performSegueWithIdentifier:@"ToTabBar" sender:self];

}

@end
