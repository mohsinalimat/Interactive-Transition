//
//  PresentAnimationController.h
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PresentAnimationDelegate <NSObject>

- (void)prepareUIContentBeforePresenting;
- (void)animateUIContentWhilePresenting;
- (void)presentingWasCancelled;

@optional
- (void)animateUIContentWhilePresentingFirstHalf;
- (void)animateUIContentWhilePresentingSecondHalf;

@end

@interface PresentAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@end
