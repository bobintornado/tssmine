//
//  WebViewController.h
//  mySMUShop
//
//  Created by Bob Cao on 20/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong,nonatomic) NSString *urlText;

@end
