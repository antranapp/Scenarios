//
//  PDDebugWindow.m
//  
//
//  Created by Tran Binh An on 31/1/25.
//

#import "ScenariosFloatingWindow.h"
#import <UIKit/UIKit.h>

NSString * const FloatingWindowOpenKey = @"Scenarios.FloatingWindowOpenKey";

@implementation ScenariosFloatingWindow
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ScenariosFloatingWindow *window = nil;
    dispatch_once(&onceToken, ^{
        window = [[self alloc] initWithMaximizedViewController:UIViewController.new minimizedViewImageColor:UIColor.yellowColor];
    });
    return window;
}


- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [NSUserDefaults.standardUserDefaults setBool:!hidden forKey:FloatingWindowOpenKey];
}
@end

