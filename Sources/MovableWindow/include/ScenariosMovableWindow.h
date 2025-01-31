//
//  PDMovableWindow.h
//  
//
//  Created by Tran Binh An on 31/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ScenariosMovableWindow : UIWindow
@property(nonatomic, assign) BOOL minimized;
@property(nonatomic, readonly) UIView *displayView;

- (instancetype)initWithMaximizedViewController:(nullable UIViewController *)vc minimizedViewImageColor:(UIColor *)minimizedViewImageColor;

- (void)reload;


@end

NS_ASSUME_NONNULL_END

