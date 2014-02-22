//
//  AnnouncementCell.h
//  mySMU
//
//  Created by Bob Cao on 22/2/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *faulty;
@property (strong, nonatomic) IBOutlet UILabel *announcementDate;
@property (strong, nonatomic) IBOutlet UITextView *announcementText;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *symbol;


@end
