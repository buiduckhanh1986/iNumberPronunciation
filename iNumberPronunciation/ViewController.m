//
//  ViewController.m
//  iNumberPronunciation
//
//  Created by Bui Duc Khanh on 8/19/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Đây là dữ liệu test
    int numbers[10] = {7, 11, 12, 17, 30, 53, 111, 2012, 1412, 503};
    
    NSMutableArray * tmp = [NSMutableArray new];
    
    for (int i = 0; i < sizeof(numbers)/sizeof(int); i++)
        [tmp addObject:[self pronunciation:numbers[i]]];
    
    // Yêu cầu bài học là chuyển thành NSArray
    NSArray * result = [NSArray arrayWithArray:tmp];
    
    // Hiển thị kết quả
    for (int i = 0; i < result.count; i++)
    {
        printf("%4u : %s\n", numbers[i], [result[i] UTF8String]);
    }
}


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
