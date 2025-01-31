//
//  PDMovableWindow.m
//  
//
//  Created by Tran Binh An on 31/1/25.
//

#import "PDMovableWindow.h"

#define PDScreenWidth  [UIScreen mainScreen].bounds.size.width
#define PDScreenHeight  [UIScreen mainScreen].bounds.size.height
#define PDMaximizeSize CGSizeMake(PDScreenWidth, 280)
#define PDMinimumSize  CGSizeMake(48, 48)
#define PDTop 64
#define PDBottom 200
#define PDAnimationDuration 0.15

@interface PDMovableWindow ()
@property(nonatomic, strong) UIView *displayView;
@property(nonatomic, strong, nullable)UIView *minimizedView;  // default nil
@property(nonatomic, strong, nullable)UIViewController *maximizedViewController;  // default nil
@end

@implementation PDMovableWindow {
    UIPanGestureRecognizer *_panGesture;
}

#pragma mark - init

- (instancetype)initWithMaximizedViewController:(UIViewController *)vc minimizedViewImageColor:(UIColor *)minimizedViewImageColor {
    self = [super initWithFrame:CGRectMake(PDScreenWidth, 0, 0, 0)];
    if (self) {
        self.maximizedViewController = vc;
        self.minimizedView = [self getDefaultMinimizedViewWithImageColor:minimizedViewImageColor];
        self.translatesAutoresizingMaskIntoConstraints = true;
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 3;
        _minimized = true;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _panGesture = panGesture;
        [self addGestureRecognizer:panGesture];
        
        // tapGesture should add to minimizedView. or will deplay maximizedViewController touch.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.minimizedView addGestureRecognizer:tapGesture];
        
        [self addObserver:self forKeyPath:@"displayView.frame" options:NSKeyValueObservingOptionNew context:nil];
        [self reload];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithMaximizedViewController:nil minimizedViewImageColor:nil];
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"displayView.frame"];
    } @catch (NSException *exception) { }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"displayView.frame"] && _panGesture.state != UIGestureRecognizerStateChanged) {
//        NSLog(@"kvo:%@",self.displayView);
        [self rePosition:false];
    }
}

#pragma mark - touch move
- (void)pan:(UIPanGestureRecognizer *)ges {
    CGPoint origin = self.frame.origin;
    CGPoint translation = [ges translationInView:self];
    [ges setTranslation:CGPointZero inView:self];
    origin = CGPointMake(origin.x + translation.x, origin.y + translation.y);
    self.frame = (CGRect){origin, self.displayView.frame.size};
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        [self rePosition:true];
    }
}

- (void)rePosition:(BOOL)aniamted {
    CGPoint origin = self.frame.origin;
    CGSize size = self.displayView.frame.size;
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    origin.x = (origin.x + size.width / 2.0) > (screenSize.width / 2.0) ? screenSize.width - size.width : 0;
    origin.y = MIN(screenSize.height - PDBottom, MAX(origin.y, PDTop));
    CGRect newRect = (CGRect){origin, size};
    if (!CGRectEqualToRect(newRect, self.frame)) {
        if (aniamted) {
            [UIView animateWithDuration:PDAnimationDuration animations:^{
                self.frame = newRect;
            }];
        } else {
            self.frame = newRect;
        }
    }
}

#pragma mark - minimize
- (void)tap:(UITapGestureRecognizer *)ges {
    self.minimized = false;
}

- (void)setMinimized:(BOOL)minimized {
    if (_minimized != minimized) {
        _minimized = minimized;
        [self reload];
    }
}

- (UIView *)getDefaultMinimizedViewWithImageColor:(UIColor *)imageColor {
    return ({
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, PDMinimumSize}];
        view.layer.cornerRadius = PDMinimumSize.height / 2.0;
        view.layer.masksToBounds = true;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [view addSubview:blurView];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [blurView.topAnchor constraintEqualToAnchor:view.topAnchor],
            [blurView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
            [blurView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
            [blurView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor]
        ]];

        UIImage *image = [UIImage systemImageNamed:@"eye"];
        image = [image imageWithTintColor:imageColor ?: UIColor.yellowColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = true;
        [view addSubview:imageView];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [imageView.centerXAnchor constraintEqualToAnchor:blurView.contentView.centerXAnchor],
            [imageView.centerYAnchor constraintEqualToAnchor:blurView.contentView.centerYAnchor],
            [imageView.widthAnchor constraintEqualToConstant:24],
            [imageView.heightAnchor constraintEqualToConstant:24]
        ]];

        view;
    });
}

- (void)reload {
    [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (self.minimized) {
            self.rootViewController = nil;
            self.displayView = self.minimizedView;
            [self addSubview:self.minimizedView];
        } else {
            [self.minimizedView removeFromSuperview];
            self.displayView = self.maximizedViewController.view;
            self.rootViewController = self.maximizedViewController;
        }
    } completion:nil];
}


@end
