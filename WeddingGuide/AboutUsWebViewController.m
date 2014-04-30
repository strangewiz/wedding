//
//  AboutUsWebViewController.m
//  WeddingGuide
//
//  Created by Justin Cohen on 4/29/14.
//  Copyright (c) 2014 Justin and Rachel. All rights reserved.
//

#import "AboutUsWebViewController.h"

@interface AboutUsWebViewController () {
  IBOutlet UIWebView* webView_;
}

@end

@implementation AboutUsWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString* filePath =
      [[NSBundle mainBundle] pathForResource:@"aboutus" ofType:@"html"];
  NSData* data = [NSData dataWithContentsOfFile:filePath];
  [webView_ loadData:data
              MIMEType:@"text/html"
      textEncodingName:@"utf8"
               baseURL:nil];
}

@end
