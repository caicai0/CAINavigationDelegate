//
//  CAIPopInteractive.h
//  navigationAnimation
//
//  Created by liyufeng on 15/1/6.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAIPopInteractive : NSObject <UIViewControllerInteractiveTransitioning>

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end
