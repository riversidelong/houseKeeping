//
//  ItemsViewController.h
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemCategory;

@interface ItemsViewController : UITableViewController
@property(assign, nonatomic) NSInteger year;
@property(assign, nonatomic) NSInteger month;
@property(strong, nonatomic) ItemCategory *itemCategory;

@end
