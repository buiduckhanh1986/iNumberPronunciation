//
//  ViewController.m
//  iNumberPronunciation
//
//  Created by Bui Duc Khanh on 8/19/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtDayOfYear;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Lấy năm hiện tại gán vào text box year
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    [self.txtYear setText:[NSString stringWithFormat:@"%ld", (long)[components year]]];
    [self onButtonResultTouchUpInside:nil];
    
}


// Xử lý hiển thị thông tin ngày tháng năm
- (IBAction)onButtonResultTouchUpInside:(id)sender {
    int year = [_txtYear.text intValue];
    int dayOfYear = [_txtDayOfYear.text intValue];
    
    
    // Lấy thông tin ngày 01/01/năm lựa chọn
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth:1];
    [components setYear:year];
    
    // Cộng thêm Interval để ra ngày kết quả
    NSDate *result = [NSDate dateWithTimeInterval:((dayOfYear - 1)*24*60*60)
                                        sinceDate:[calendar dateFromComponents:components]];
    
    // Tạo date format tạo format string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN_POSIX"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"dd/MM/y"];
    
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday fromDate:result];
    
    // Lấy ngày trong tuần theo chuẩn việt nam
    NSString *weekday;
    
    switch([components weekday])
    {
        
        case 2 : weekday = @"Thứ Hai"; break;
        case 3 : weekday = @"Thứ Ba"; break;
        case 4 : weekday = @"Thứ Tư"; break;
        case 5 : weekday = @"Thứ Năm"; break;
        case 6 : weekday = @"Thứ Sáu"; break;
        case 7 : weekday = @"Thứ Bảy"; break;
            
        default: weekday = @"Chủ Nhật"; break;
    }
    
    // Hiển thị kết quả
    [self.lblResult setText:[NSString stringWithFormat:@"%@ Ngày %@ - Tuần Thứ %li", weekday, [formatter stringFromDate:result], (long)[components weekOfYear]]];
    
}


// Hàm thực hiện phát âm 1 số Integer
- (NSString *) pronunciation:(int) num
{
    
    char digit [21][10] = { "", "one", "two", "three", "four", "five", "six", "seven",
        "eight", "nine", "ten", "eleven", "twelve", "thirteen",
        "fourteen", "fifteen", "sixteen", "seventeen", "eighteen",
        "nineteen"};
    char tens [11][10] = { "", "", "twenty", "thirty", "forty", "fifty", "sixty",
        "seventy", "eighty", "ninety"};
    char str[1000] = {0};
    int prev=0, div=1000;
    strcpy(str, "");
    
    while(div) {
        
        if ((num / div) % 10 > 0 || (div == 10 && (num%100) > 0)) {
            
            if (prev) {
                strcat(str, " and");
                prev = 0;
            }
            
            switch(div) {
                case 1000:
                    if (strlen(str) > 0 && str[strlen(str) - 1] != ' ')
                        strcat(str, " ");
                    strcat(str, digit[(num / div) % 10]);
                    
                    if (((num / div) % 10) > 1)
                        strcat(str, " thousands");
                    else
                        strcat(str, " thousand");
                    prev = 1;
                    break;
                case 100:
                    if (strlen(str) > 0 && str[strlen(str) - 1] != ' ')
                        strcat(str, " ");
                    
                    strcat(str, digit[(num / div) % 10]);
                    
                    if (((num / div) % 10) > 1)
                        strcat(str, " hundreds");
                    else
                        strcat(str, " hundred");

                    prev = 1;
                    break;
                case 10:
                    if ( (num%100) >= 10 && (num%100) <= 19)
                    {
                        if (strlen(str) > 0 && str[strlen(str) - 1] != ' ')
                            strcat(str, " ");
                        
                        strcat(str, digit[num%100]);
                    }
                    else {
                        if (strlen(str) > 0 && str[strlen(str) - 1] != ' ')
                            strcat(str, " ");
                        strcat(str, tens[(num%100)/10]);
                        
                        if (strlen(str) > 0 && str[strlen(str) - 1] != ' ')
                            strcat(str, " ");
                        
                        strcat(str, digit[num%10]);
                    }
                    break;
            }
        }
        
        div /= 10;
    }
    
    return [NSString stringWithUTF8String:str];
    
}
@end
