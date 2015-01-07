//
//  CAIPopInteractive.m
//  navigationAnimation
//
//  Created by liyufeng on 15/1/6.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "CAIPopInteractive.h"

#define CONTROLLERVIEW_SHADLERADIUS 7.0

@interface CAIPopInteractive ()

@property (nonatomic, weak)id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak)UIViewController * fromViewController;
@property (nonatomic, weak)UIViewController * toViewController;
@property (nonatomic, assign)float persent;

@end

@implementation CAIPopInteractive

- (void)updateInteractiveTransition:(CGFloat)percentComplete{
    self.persent = percentComplete;
    self.fromViewController.view.transform = CGAffineTransformMakeTranslation(self.fromViewController.view.bounds.size.width*percentComplete, 0);
    self.toViewController.view.transform = CGAffineTransformMakeScale(0.8+(0.2*percentComplete), 0.8+(0.2*percentComplete));
    [self.transitionContext updateInteractiveTransition:percentComplete];
}
- (void)cancelInteractiveTransition{
    [self end:YES];
}
- (void)finishInteractiveTransition{
    [self end:NO];
}

- (void)end:(BOOL)cancelled{
    if (cancelled) {
        [UIView animateWithDuration:0.3*(1-self.persent)
                         animations:^{
                             self.fromViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                             self.toViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                         } completion:^(BOOL finished) {
                             self.toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                             [self.transitionContext completeTransition:NO];
                             [self.transitionContext finishInteractiveTransition];
                         }];
    } else {
        [UIView animateWithDuration:0.3*(1-self.persent)
                         animations:^{
                             self.fromViewController.view.transform = CGAffineTransformMakeTranslation(self.fromViewController.view.bounds.size.width, 0);
                             self.toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self.transitionContext finishInteractiveTransition];
                             [self.transitionContext completeTransition:YES];
                         }];
    }
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    
    UIView *containerView = [transitionContext containerView];
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toViewController.view.frame = [transitionContext finalFrameForViewController:self.toViewController];
    [containerView insertSubview:self.toViewController.view belowSubview:self.fromViewController.view];
    
    [self addShadow];
    
    self.toViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
}
- (CGFloat)completionSpeed{
    return 1;
}
- (UIViewAnimationCurve)completionCurve{
    return UIViewAnimationCurveLinear;
}

#pragma mark - privateFounctions

- (void)addShadow{
    //添加阴影
    self.fromViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fromViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.fromViewController.view.layer.shadowOpacity = 0.9;
    self.fromViewController.view.layer.shadowRadius = CONTROLLERVIEW_SHADLERADIUS;
    
    self.toViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.toViewController.view.layer.shadowOpacity = 0.9;
    self.toViewController.view.layer.shadowRadius = CONTROLLERVIEW_SHADLERADIUS;
}

@end
