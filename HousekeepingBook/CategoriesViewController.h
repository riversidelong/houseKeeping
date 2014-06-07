//
//  CategoriesViewController.h
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CategoriesViewControllerDelegate;
@class ItemCategory;

@interface CategoriesViewController : UITableViewController
@property (weak, nonatomic) id<CategoriesViewControllerDelegate> delegate;
@end

@protocol CategoriesViewControllerDelegate <NSObject>

- (void)categoriesViewControllerDidCancel:(CategoriesViewController *)controller;
- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategory:(ItemCategory *)category;


@end
