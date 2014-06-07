//
//  MonthsViewController.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "MonthsViewController.h"
#import "DataManager.h"
#import "Item.h"
#import "ItemsViewController.h"

@interface MonthsViewController ()
@property(strong, nonatomic) NSCalendar *calendar;
@property(assign, nonatomic) NSInteger yearForNow;
@property(assign, nonatomic) NSInteger monthForNow;
@property(assign, nonatomic) NSInteger yearForFirstDate;
@property(assign, nonatomic) NSInteger monthForFirstDate;
@end

@implementation MonthsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSData *now = [NSData date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.calendar = calendar;
    
    //表示時点の年月を取得
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *nowComponents = [calendar components:units fromDate:now];
    self.yearForNow = nowComponents.year;
    self.monthForNow = nowComponents.month;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    
    //日付の昇り順でソート
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    NSArray *results = [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    if ([results count] > 0)
    {
        //一件以上項目がある場合は一番最初に登録された項目の年月を保持
        NSDate *firstDate = [results[0] date];
        NSDateComponents *firstDateComponents = [calendar components:units fromDate:firstDate];
        self.yearForFirstDate = firstDateComponents.year;
        self.monthForFirstDate = firstDateComponents.month;
    } else {
        //項目が0件の場合、現在の年月を最初の年月として保持
        self.yearForFirstDate = self.yearForNow;
        self.monthForFirstDate = self.monthForNow;
    }
    [self.tableView reloadData];
    
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        //選択された行の年月および現在のカテゴリを渡してItemsViewControllerを表示
        NSInteger year, month;
        [self getYear:&year month:&month atIndexPath:indexPath];
        ItemsViewController *controller = segue.destinationViewController;
        controller.year = year;
        controller.month = month;
        controller.itemCategory = self.itemCategory;
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //最初の項目から現在の項目までの月数を行数として返す
    return (self.yearForNow - self.yearForFirstDate) * 12 + (self.monthForNow - self.monthForFirstDate) + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //indexPathで示される行の年月を取得し、その月に存在する項目の支出の合計を計算
    NSInteger year, month;
    [self getYear:&year month:&month atIndexPath:indexPath];
    
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    
    NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
    firstComponents.calendar = self.calendar;
    firstComponents.year = year;
    firstComponents.month = month;
    firstComponents.day = 1;
    NSDate *firstDate = [firstComponents date];
    
    NSDateComponents *lastComponents = [firstComponents copy];
    lastComponents.month = month + 1;
    NSData *lastDate = [lastComponents date];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ and date < %@", firstDate, lastDate];
    if(self.itemCategory)
    {
        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category = %@", self.itemCategory];
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, categoryPredicate]];
    }
    [request setPredicate:predicate];
    NSArray *results = [context executeFetchRequest:request error:nil];
    NSInteger expense = 0;
    for (Item *item in results)
    {
        expense += [Item.expense integerValue];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d/%d", (int)year, (int)month];
    cell.detailTextLabel.textColor = expense >= 0 ? [UIColor redColor] : [UIColor blueColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)-expense];
    return cell;
}
- (void)getYear:(NSInteger *)year month:(NSInteger *)month atIndexPath:(NSIndexPath *)indexPath
{
    //indexPathを元に年と月を計算してポインタの示す値を変数に値を設定する
    NSInteger y = self.yearForNow - indexPath.row / 12;
    NSInteger m = self.monthForNow - indexPath.row % 12;
    if (m >= 12) {
        y += 1;
        m -= 12;
    }
    *year = y;
    *month = m;
}


@end
