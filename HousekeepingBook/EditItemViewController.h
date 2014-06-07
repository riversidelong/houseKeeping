//
//  EditItemViewController.h
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;
@interface EditItemViewController : UITableViewController
@property(strong, nonatomic) Item *item;
@end
