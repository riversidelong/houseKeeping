//
//  EditItemViewController.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "EditItemViewController.h"
#import "CategoriesViewController.h"
#import "Item.h"
#import "ItemCategory.h"
#import "DataManager.h"
#import "DateField.h"
@interface EditItemViewController () <CategoriesViewControllerDelegate>

- (IBAction)performCancelButtonAction:(id)sender;
- (IBAction)performSaveButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet DateField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *signControl;
@property (weak, nonatomic) IBOutlet UITextField *expenseField;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteField;

@end

@implementation EditItemViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //キーボードが出現するときと隠れるタイミングを監視
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //このメソッドはカテゴリ選択画面から戻ってきたときにも呼ばれるため、タイトルが設定されているかどうかで初回のアクセスかどうか判断する
    if (self.title.length == 0)
    {
        if(self.item) {
            self.title = @"項目を編集";
        } else {
            self.title = @"項目を追加";
            self.item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:[[DataManager sharedManager] managedObjectContext]];
        }
        self.nameField.text = self.item.name;
        self.noteField.text = self.item.note;
        
        //expenseがプラスなら支出、マイナスなら収入
        NSInteger expense = [self.item.expense integerValue];
        self.signControl.selectedSegmentIndex = expense >= 0 ? 1 :0;
        self.expenseField.text = expense == 0 ? @"" : [NSString stringWithFormat:@"%ld", (long)ABS(expense)];
        
        self.categoryNameLabel.text = self.item.category.name;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    //キーボードが出現したら、キーボードで隠れたスペース分スクロールできるようにする
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = keyboardFrame.size.height;
    self.tableView.contentInset = inset;
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 0;
    self.tableView.contentInset = inset;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (self.item.isInserted)
        [[[DataManager sharedManager] managedObjectContext] deleteObject:self.item];
    else
        [[[DataManager sharedManager] managedObjectContext] refreshObject:self.item mergeChanges:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)performCancelButtonAction:(id)sender {
}

- (IBAction)performSaveButtonAction:(id)sender {
    NSMutableArray *errors = [NSMutableArray array];
    
    //収支とカテゴリーは入力必須にする
    if ([self.expenseField.text integerValue] == 0)
        [errors addObject:@"収支が入力されていません"];
    if(!self.item.category)
        [errors addObject:@"カテゴリが選択されていません"];
    
    if ([errors count] > 0) {
        [[[UIAlertView alloc] initWithTitle:@"エラー" message:[errors componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    self.item.date = self.dateField.date;
    self.item.name = self.nameField.text;
    self.item.note = self.noteField.text;
    //ここがよくわからん
    NSInteger value = [self.expenseField.text integerValue];
    if (self.signControl.selectedSegmentIndex == 0)
        value *= -1;
    self.item.expense = @(value);
    
    [[[DataManager sharedManager] managedObjectContext] save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)categoriesViewControllerDidCancel:(CategoriesViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategory:(ItemCategory *)category
{
    self.item.category = category;
    self.categoryNameLabel.text = self.item.category.name;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
