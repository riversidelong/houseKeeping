//
//  CategoriesViewController.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "CategoriesViewController.h"
#import "DataManager.h"
#import "CategoryCell.h"
#import "ItemCategory.h"
#import "EditCategoryViewController.h"
#import "MonthsViewController.h"

@interface CategoriesViewController ()
<
NSFetchedResultsControllerDelegate
>
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation CategoriesViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.delegate respondsToSelector:@selector(categoriesViewControllerDidCancel::)])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(performCancelButtonAction:)];
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    
    }
}
- (void) performCancelButtonAction:(id)sender
{
    [self.delegate categoriesViewControllerDidCancel:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(categoriesViewController:didSelectCategory:)])
    {
        ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.delegate categoriesViewController:self  didSelectCategory:category];
    }
    else {
        MonthsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MonthsViewController"];
        controller.itemCategory = [self.fetchedResultsController objectAtIndexPath:indexPath ];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if(!_fetchedResultsController)
    {
        NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ItemCategory"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        controller.delegate = self;
        [controller performFetch:nil];
        _fetchedResultsController = controller;
    }
    return _fetchedResultsController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[CategoryCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        UINavigationController *navigationController = segue.destinationViewController;
        EditCategoryViewController *controller = (id)[navigationController topViewController];
        controller.itemCategory = category;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections][section] objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:category];
        [self.fetchedResultsController.managedObjectContext save:nil];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //アイテムが結びついているカテゴリは削除できないようにする
    ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [category.items count] == 0;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            case NSFetchedResultsChangeUpdate:
            [self configureCell:(id)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
- (void)configureCell:(CategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ItemCategory *itemCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.itemCategory = itemCategory;
}
@end
