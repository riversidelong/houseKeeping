//
//  MonthsViewController.h
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemCategory;

@interface MonthsViewController : UITableViewController
@property(strong, nonatomic) ItemCategory *itemCategory;
@end
