//
//  BuzzViewController.h
//  mySMU
//
//  Created by Bob Cao on 22/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <Parse/Parse.h>

@interface BuzzViewController : PFQueryTableViewController <UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    CIContext *context;
    NSMutableArray *filters;
    CIImage *beginImage;
}

@property (nonatomic,weak) IBOutlet UIScrollView *filtersScrollView;
@property (nonatomic,weak) IBOutlet UIImageView *imageView;


@end
