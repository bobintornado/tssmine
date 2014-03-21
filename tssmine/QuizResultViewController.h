//
//  QuizResultViewController.h
//  mySMUShop
//
//  Created by Bob Cao on 21/3/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizResultViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* products;

@end
