//
//  CategoryCellTableViewCell.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "CategoryCellTableViewCell.h"

@implementation CategoryCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
