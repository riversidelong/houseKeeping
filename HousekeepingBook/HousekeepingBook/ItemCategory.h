//
//  ItemCategory.h
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface ItemCategory : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSSet *items;
@end

@interface ItemCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
