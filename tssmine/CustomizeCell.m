//
//  CustomizeCell.m
//  TheSMUShop
//
//  Created by Bob Cao on 27/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "CustomizeCell.h"

@implementation CustomizeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
