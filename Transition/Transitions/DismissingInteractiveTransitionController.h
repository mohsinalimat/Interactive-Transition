//
//  DismissingInteractiveTransitionController.h
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissingInteractiveTransitionDelegate <NSObject>

- (void)dismissViewController;

@end

@interface DismissingInteractiveTransitionController : UIPercentDrivenInteractiveTransition

@property(nonatomic, assign, readonly, getter=isInteractionInProgress) BOOL interactionInProgress;

- (void)wireToViewController:(UIViewController<DismissingInteractiveTransitionDelegate>*)viewController;

@end
