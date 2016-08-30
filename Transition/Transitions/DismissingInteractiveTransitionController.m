//
//  DismissingInteractiveTransitionController.m
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import "DismissingInteractiveTransitionController.h"

@interface DismissingInteractiveTransitionController()

@property(nonatomic, weak) UIViewController<DismissingInteractiveTransitionDelegate> *viewController;

@property(nonatomic, assign, readwrite, getter=isInteractionInProgress) BOOL interactionInProgress;
@property(nonatomic, assign) BOOL shouldCompleteTransition;

@end

@implementation DismissingInteractiveTransitionController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _interactionInProgress = NO;
        _shouldCompleteTransition = NO;
    }
    return self;
}

- (void)wireToViewController:(UIViewController<DismissingInteractiveTransitionDelegate>*)viewController
{
    assert([viewController isKindOfClass:[UIViewController class]] &&
           [viewController conformsToProtocol:@protocol(DismissingInteractiveTransitionDelegate)]);
    
    _viewController = viewController;
    [self addGestureRecogniserOnView:viewController.view];
}

- (void)addGestureRecogniserOnView:(UIView*)view
{
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleGestureRecognizer:)];
    
    [view addGestureRecognizer:panGesture];
}

- (void)handleGestureRecognizer:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    CGFloat progress = -translation.y / gesture.view.frame.size.height;
   // NSLog(@"%f", progress);
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            
            self.interactionInProgress = YES;
          
            [self.viewController dismissViewController];
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
            self.shouldCompleteTransition = (progress > 0.3);
            [self updateInteractiveTransition:progress];
            
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            
            self.interactionInProgress = NO;
            
            [self cancelInteractiveTransition];
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            self.interactionInProgress = NO;
            
            if (self.shouldCompleteTransition)
            {
                [self finishInteractiveTransition];
            }
            else
            {
                [self cancelInteractiveTransition];
            }
            
            break;
            
        case UIGestureRecognizerStatePossible:
            // Do nothing
            break;
    }
}

@end
