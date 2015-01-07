//
//  CAINavigationDelegate.m
//  navigationAnimation
//
//  Created by liyufeng on 15/1/6.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "CAINavigationDelegate.h"
#import "CAIPopAnimation.h"
#import "CAIPushAnimation.h"
#import "CAIPopInteractive.h"

@interface CAINavigationDelegate ()
@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;

@property (nonatomic, strong)CAIPopAnimation * popAnimation;
@property (nonatomic, strong)CAIPushAnimation * pushAnimation;
@property (nonatomic, strong)CAIPopInteractive * popInteractive;

@end

@implementation CAINavigationDelegate

- (void)awakeFromNib{
    self.popAnimation = [[CAIPopAnimation alloc]init];
    self.pushAnimation = [[CAIPushAnimation alloc]init];
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer];
    self.navigationController.view .backgroundColor = [UIColor whiteColor];
}
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)pan{
    [self pan:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    UIView* view = self.navigationController.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [pan locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
            self.popInteractive = [[CAIPopInteractive alloc]init];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.popInteractive updateInteractiveTransition:d];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        if ([pan velocityInView:view].x > 0) {
            [self.popInteractive finishInteractiveTransition];
        } else {
            [self.popInteractive cancelInteractiveTransition];
        }
        self.popInteractive = nil;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    return self.popInteractive;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return self.popAnimation;
    }else if(operation == UINavigationControllerOperationPush){
        return self.pushAnimation;
    }
    return nil;
}

@end
