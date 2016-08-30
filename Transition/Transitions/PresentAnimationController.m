//
//  PresentAnimationController.m
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PresentAnimationController.h"

@implementation PresentAnimationController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
  
    UIViewController<PresentAnimationDelegate> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toSnapshot = [toVC.view snapshotViewAfterScreenUpdates:YES];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:toSnapshot];
    toVC.view.hidden = YES;
    
    CGFloat duration = [self transitionDuration:transitionContext];
    
    toSnapshot.transform = CGAffineTransformMakeTranslation(0, -toSnapshot.frame.size.height);
    
    if ([fromVC conformsToProtocol:@protocol(PresentAnimationDelegate)])
    {
        [fromVC prepareUIContentBeforePresenting];
    }
    
    void (^AnimationsBlock)(void) = ^void (void)
    {
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:duration
                                      animations:^
        {
            toSnapshot.transform = CGAffineTransformIdentity;
            [fromVC animateUIContentWhilePresenting];
        }];
        
        if ([fromVC conformsToProtocol:@protocol(PresentAnimationDelegate)] &&
            [fromVC respondsToSelector:@selector(animateUIContentWhilePresentingFirstHalf)])
        {
            [UIView addKeyframeWithRelativeStartTime:0.0
                                    relativeDuration:duration / 2.0
                                          animations:^
             {
                 [fromVC animateUIContentWhilePresentingFirstHalf];
             }];
        }
        
        if ([fromVC conformsToProtocol:@protocol(PresentAnimationDelegate)] &&
            [fromVC respondsToSelector:@selector(animateUIContentWhilePresentingSecondHalf)])
        {
            [UIView addKeyframeWithRelativeStartTime:duration / 2.0
                                    relativeDuration:duration / 2.0
                                          animations:^
             {
                 [fromVC animateUIContentWhilePresentingSecondHalf];
             }];
        }
    };
    
    void (^CompletionBlock)(BOOL finished) = ^void (BOOL finished)
    {
        BOOL success = ![transitionContext transitionWasCancelled];
        
        if (success)
        {
            toVC.view.hidden = NO;
        }
        else
        {
            [fromVC presentingWasCancelled];
            [toVC.view removeFromSuperview];
        }
        
        [toSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:success];
    };
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced
                              animations:AnimationsBlock
                              completion:CompletionBlock];
}

@end
