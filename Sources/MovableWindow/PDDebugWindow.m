//
//  PDDebugWindow.m
//  
//
//  Created by Tran Binh An on 31/1/25.
//

#import "PDDebugWindow.h"
//#import "PDAnalyticsListVC.h"
//#import "PDAnalyticsVC.h"
#import <UIKit/UIKit.h>

NSString * const DebugWindowOpenKey = @"DebugWindowOpenKey";

@implementation PDDebugWindow
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PDDebugWindow *window = nil;
    dispatch_once(&onceToken, ^{
        window = [[self alloc] initWithMaximizedViewController:UIViewController.new minimizedViewImageColor:UIColor.yellowColor];
    });
    return window;
}


- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [NSUserDefaults.standardUserDefaults setBool:!hidden forKey:DebugWindowOpenKey];
}
@end

