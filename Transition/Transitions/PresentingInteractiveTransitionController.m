//
//  PresentingInteractiveTransitionController.m
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import "PresentingInteractiveTransitionController.h"

@interface PresentingInteractiveTransitionController()

@property(nonatomic, weak) UIViewController<PresntingInteractiveTransitionDelegate> *viewController;

@property(nonatomic, assign, readwrite, getter=isInteractionInProgress) BOOL interactionInProgress;
@property(nonatomic, assign) BOOL shouldCompleteTransition;

@end

@implementation PresentingInteractiveTransitionController

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

- (void)wireToViewController:(UIViewController<PresntingInteractiveTransitionDelegate>*)viewController
{
    assert([viewController isKindOfClass:[UIViewController class]] &&
           [viewController conformsToProtocol:@protocol(PresntingInteractiveTransitionDelegate)]);
    
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
    CGFloat progress = translation.y / gesture.view.frame.size.height;
   
    NSLog(@"%f", gesture.view.frame.size.height);
    NSLog(@"%f", translation.y);
    NSLog(@"%f", progress);
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            
            self.interactionInProgress = YES;
          
            [self.viewController presentViewController];
            
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
