//
//  EditCategoryViewController.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/05.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "ItemCategory.h"
#import "DataManager.h"

@interface EditCategoryViewController ()
- (IBAction)performCancelButtonAction:(id)sender;

- (IBAction)performSaveButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIView *colorView;
//-----------------------


@end

@implementation EditCategoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.itemCategory)
    {
        self.title = @"カテゴリを編集";
    }
    else{
        self.title = @"カテゴリを追加";
        
        //カテゴリが存在しない場合、新規に作成
        self.itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ItemCategory" inManagedObjectContext:[[DataManager sharedManager] managedObjectContext]];
        //色は黒
        self.itemCategory.color = [UIColor blackColor];
    
    }
    self.nameField.text = self.itemCategory.name;
    
    //カテゴリーの色から三原色の値を取得し、スライダーに設定
    CGFloat r, g, b, a;
    [self.itemCategory.color getRed:&r green:&g blue:&b alpha:&a];
    self.redSlider.value = r;
    self.greenSlider.value = g;
    self.blueSlider.value = b;
    
    //色のプレビューを表示
    self.colorView.backgroundColor = self.itemCategory.color;
}

- (void)reloadColorView
{
    //スライダーの各値を元に色のプレビューを更新
    self.colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redSliderValueChanged:(id)sender {
    [self reloadColorView];
}
- (IBAction)greenSliderValueChanged:(id)sender {
    [self reloadColorView];
}
- (IBAction)blueSliderValueChanged:(id)sender {
    [self reloadColorView];
}


- (IBAction)performCancelButtonAction:(id)sender {
    //キャンセルが押されたとき、新規の場合は削除、変更の場合は元に戻す
    if(self.itemCategory.isInserted)
        [[[DataManager sharedManager] managedObjectContext] deleteObject:self.itemCategory];
    else
        [[[DataManager sharedManager] managedObjectContext] refreshObject:self.itemCategory mergeChanges:NO];
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
}

- (IBAction)performSaveButtonAction:(id)sender {
    self.itemCategory.name = self.nameField.text;
    self.itemCategory.color = self.colorView.backgroundColor;
    
    [[[DataManager sharedManager] managedObjectContext] save:nil];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
