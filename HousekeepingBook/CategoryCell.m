//
//  CategoryCell.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "CategoryCell.h"
#import "ItemCategory.h"
@interface CategoryCell()
@property(weak, nonatomic)UIView *colorView;
@end

@implementation CategoryCell

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
    UIView *colorView = [[UIView alloc] init];
    [self.contentView addSubview:colorView];
    _colorView = colorView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect colorViewFrame = CGRectMake(2, 2, 40, 40);
    self.colorView.frame = colorViewFrame;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x += CGRectGetMaxX(colorViewFrame);
    textLabelFrame.size.width -= CGRectGetMaxX(colorViewFrame);
    self.textLabel.frame = textLabelFrame;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemCategory:(ItemCategory *)itemCategory
{
    _itemCategory = itemCategory;
    
    self.textLabel.text = itemCategory.name;
    self.colorView.backgroundColor = itemCategory.color;
}
@end
