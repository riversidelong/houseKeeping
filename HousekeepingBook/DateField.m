//
//  DateField.m
//  HousekeepingBook
//
//  Created by 川端伸彦 on 2014/06/06.
//  Copyright (c) 2014年 mikke. All rights reserved.
//

#import "DateField.h"

@interface DateField()
@property (strong, nonatomic) UIDatePicker *picker;
@property (strong ,nonatomic) NSDateFormatter *formatter;


@end
@implementation DateField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initialize
{
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    //未来に時間を設定できなようにする
    picker.maximumDate = [NSDate date];
    
    _picker = picker;
    self.inputView = picker;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    _formatter = formatter;
    [picker addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew context:nil];
    
    //初期化した日のタイムを表示するNSDateを作成
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    components.calendar = calender;
    picker.date = [components date];
    
}

- (void)dealloc
{
    [_picker removeObserver:self forKeyPath:@"date"];
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.text = [self.formatter stringFromDate:self.date];
}

- (void)pickerValueChanged
{
    self.text = [self.formatter stringFromDate:self.date];
}
- (NSDate *)date
{
    return self.picker.date;
}
- (void) setDate:(NSDate *)date
{
    self.picker.date = date;
}

@end
