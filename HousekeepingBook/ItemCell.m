//
//  ItemCell.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "ItemCell.h"
#import "Item.h"
#import "ItemCategory.h"

@interface ItemCell()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ItemCell

- (void)setItem:(Item *)item
{
    _item = item;
    NSInteger expense = [item.expense integerValue];
    self.dateLabel.text = [[ItemCell formatter] stringFromDate:item.date];
    
    //文字色を支出は赤、収入は青に設定
    self.expenseLabel.textColor = expense >= 0 ? [UIColor redColor] : [UIColor blueColor];
    self.expenseLabel.text = [NSString stringWithFormat:@"ld", (long)-expense];
    self.nameLabel.text = item.name;
    self.categoryLabel.text = item.category.name;
    self.colorView.backgroundColor = item.category.color;
    
    
}
+ (NSDateFormatter *)formatter
{
    static id formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
    });
    return formatter;
}

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
