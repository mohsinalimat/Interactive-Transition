//
//  DismissAnimationController.m
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DismissAnimationController.h"

@implementation DismissAnimationController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController<DismissAnimationDelegate> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
   
    UIView *fromSnapshot = [fromVC.view snapshotViewAfterScreenUpdates:YES];

    [containerView addSubview:toVC.view];
    [containerView addSubview:fromSnapshot];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    
    if ([toVC conformsToProtocol:@protocol(DismissAnimationDelegate)])
    {
        [toVC prepareUIContentBeforeDismissing];
    }
    
    void (^AnimationsBlock)(void) = ^void (void)
    {
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:duration
                                      animations:^
         {
             fromSnapshot.transform = CGAffineTransformMakeTranslation(0, -fromSnapshot.frame.size.height);
             [toVC animateUIContentWhileDismissing];
         }];
        
        if ([toVC conformsToProtocol:@protocol(DismissAnimationDelegate)] &&
            [toVC respondsToSelector:@selector(animateUIContentWhileDismissingFirstHalf)])
        {
            [UIView addKeyframeWithRelativeStartTime:0.0
                                    relativeDuration:duration / 2.0
                                          animations:^
             {
                 [toVC animateUIContentWhileDismissingFirstHalf];
             }];
        }
        
        if ([toVC conformsToProtocol:@protocol(DismissAnimationDelegate)] &&
            [toVC respondsToSelector:@selector(animateUIContentWhileDismissingSecondHalf)])
        {
            [UIView addKeyframeWithRelativeStartTime:duration / 2.0
                                    relativeDuration:duration / 2.0
                                          animations:^
             {
                 [toVC animateUIContentWhileDismissingSecondHalf];
             }];
        }
    };
    
    void (^CompletionBlock)(BOOL finished) = ^void (BOOL finished)
    {
        BOOL success = ![transitionContext transitionWasCancelled];
        
        if (!success)
        {
            [toVC dismissingWasCancelled];
            [toVC.view removeFromSuperview];
        }
        
        [fromSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:success];
    };
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced
                              animations:AnimationsBlock
                              completion:CompletionBlock];
}

@end
