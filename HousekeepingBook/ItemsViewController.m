//
//  ItemsViewController.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "ItemsViewController.h"
#import "DataManager.h"
#import "ItemCell.h"
#import "Item.h"
#import "EditItemViewController.h"

@interface ItemsViewController ()
<
NSFetchedResultsControllerDelegate
>
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ItemsViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if(!_fetchedResultsController)
    {
        NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
        //日付の降順でソート
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        request.sortDescriptors = @[sortDescriptor];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        //指定の年月の最初の時間を示す　NSDateを生成
        NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
        firstComponents.calendar = calendar;
        firstComponents.year = self.year;
        firstComponents.month = self.month;
        firstComponents.day = 1;
        NSDate *firstDate = [firstComponents date];
        
        //指定の年月の翌月の最初の時間を示すNSDateを作成
        NSDateComponents *lastComponents = [firstComponents copy];
        lastComponents.month = self.month + 1;
        NSDate *lastDate = [lastComponents date];
        
        //指定年月の最初の時間以上、かつ指定年月の次の月の最初の時間未満の検索条件を生成
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ and date < %@", firstDate, lastDate];
        if(self.itemCategory)
        {
            //カテゴリが指定されている場合は、上記の検索条件とカテゴリを組み合わせた検索条件を生成
            NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category = %@", self.itemCategory];
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, categoryPredicate]];
            
        }
        [request setPredicate:predicate];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        controller.delegate = self;
        [controller performFetch:nil];
        _fetchedResultsController = controller;
    }
    return _fetchedResultsController;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[ItemCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        UINavigationController *navigationController = segue.destinationViewController;
        EditItemViewController *controller = (id)[navigationController topViewController];
        controller.item = item;
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections][section] objects] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:item];
        [self.fetchedResultsController.managedObjectContext save:nil];
    }
       
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
- (void)configureCell:(ItemCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.item = item;
}
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



@end
