//
//  DismissAnimationController.h
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DismissAnimationDelegate <NSObject>

- (void)prepareUIContentBeforeDismissing;
- (void)animateUIContentWhileDismissing;
- (void)dismissingWasCancelled;

@optional
- (void)animateUIContentWhileDismissingFirstHalf;
- (void)animateUIContentWhileDismissingSecondHalf;

@end

@interface DismissAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@end
