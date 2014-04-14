//
//  ImageContentViewController.h
//  mySMUShop
//
//  Created by Bob Cao on 14/4/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageContentViewController : UINavigationController

@property (strong,nonatomic) NSString *imageURLStr;
@property (strong, nonatomic) IBOutlet UIImageView *pIV;


@end
