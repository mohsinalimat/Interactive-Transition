//
//  MainViewController.m
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import "MainViewController.h"

#import "DismissAnimationController.h"
#import "DismissingInteractiveTransitionController.h"

#import "PresentAnimationController.h"
#import "PresentingInteractiveTransitionController.h"

#import "ProfileViewController.h"

static NSString *const kPresentSegueIdentifier = @"presentProfileScreen";

@interface MainViewController()
<UIViewControllerTransitioningDelegate,
PresntingInteractiveTransitionDelegate,
PresentAnimationDelegate,
DismissAnimationDelegate>

@property(nonatomic, weak) IBOutlet UIButton *snapchatButton;
@property(nonatomic, weak) IBOutlet UIButton *groupsButton;
@property(nonatomic, weak) IBOutlet UIButton *dialogButton;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *snapchatButtonTopConstraint;
@property(nonatomic, assign) CGFloat originalSnapchatButtonTopConstraintConstant;

@property(nonatomic, strong, readonly) PresentingInteractiveTransitionController *presentingInteractiveTransition;
@property(nonatomic, strong, readonly) DismissingInteractiveTransitionController *dismissingInteractiveTransition;

@end

@implementation MainViewController

@synthesize presentingInteractiveTransition = _presentingInteractiveTransition;
@synthesize dismissingInteractiveTransition = _dismissingInteractiveTransition;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.originalSnapchatButtonTopConstraintConstant =
    self.snapchatButtonTopConstraint.constant;
    
    [self.presentingInteractiveTransition wireToViewController:self];
    
    self.dialogButton.layer.cornerRadius = self.dialogButton.frame.size.height / 2.0;
    self.groupsButton.layer.cornerRadius = self.groupsButton.frame.size.height / 2.0;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Buttons

- (void)setButtonsAlphaValue:(CGFloat)value
{
    self.snapchatButton.alpha = value;
    self.dialogButton.alpha = value;
    self.groupsButton.alpha = value;
}

#pragma mark - Interaction controllers

- (PresentingInteractiveTransitionController*)presentingInteractiveTransition
{
    if (_presentingInteractiveTransition == nil)
    {
        _presentingInteractiveTransition =
        [[PresentingInteractiveTransitionController alloc] init];
    }
    
    return _presentingInteractiveTransition;
}

- (DismissingInteractiveTransitionController*)dismissingInteractiveTransition
{
    if (_dismissingInteractiveTransition == nil)
    {
        _dismissingInteractiveTransition =
        [[DismissingInteractiveTransitionController alloc] init];
    }
    
    return _dismissingInteractiveTransition;
}

#pragma mark - IBActions

- (IBAction)snapchatButtonTouched:(id)sender
{
    [self presentProfileScreen];
}

#pragma mark - PresntingInteractiveTransitionDelegate

- (void)presentViewController
{
    [self presentProfileScreen];
}

#pragma mark - PresentAnimationDelegate

- (void)prepareUIContentBeforePresenting
{
    self.snapchatButtonTopConstraint.constant =
    self.view.frame.size.height +
    self.originalSnapchatButtonTopConstraintConstant;
}

- (void)animateUIContentWhilePresenting
{
    [self.snapchatButton layoutIfNeeded];
}

- (void)animateUIContentWhilePresentingFirstHalf
{
    [self setButtonsAlphaValue:0];
}

- (void)presentingWasCancelled
{
    self.snapchatButtonTopConstraint.constant =
    self.originalSnapchatButtonTopConstraintConstant;
    
    [self setButtonsAlphaValue:1];
}

#pragma mark - DismissAnimationDelegate

- (void)prepareUIContentBeforeDismissing
{
    self.snapchatButtonTopConstraint.constant =
    self.originalSnapchatButtonTopConstraintConstant;
}

- (void)animateUIContentWhileDismissing
{
    [self.snapchatButton layoutIfNeeded];
}

- (void)animateUIContentWhileDismissingSecondHalf
{
    [self setButtonsAlphaValue:1];
}

- (void)dismissingWasCancelled
{
    self.snapchatButtonTopConstraint.constant =
    self.view.frame.size.height +
    self.originalSnapchatButtonTopConstraintConstant;
    
    [self setButtonsAlphaValue:0];
}

#pragma mark - Navigation

- (void)presentProfileScreen
{
    [self performSegueWithIdentifier:kPresentSegueIdentifier
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPresentSegueIdentifier])
    {
        ProfileViewController *destinationVC =
        (ProfileViewController*)segue.destinationViewController;
        destinationVC.transitioningDelegate = self;
        [self.dismissingInteractiveTransition wireToViewController:destinationVC];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentAnimationController alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissAnimationController alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (self.dismissingInteractiveTransition.isInteractionInProgress ?
            self.dismissingInteractiveTransition : nil);
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (self.presentingInteractiveTransition.isInteractionInProgress ?
            self.presentingInteractiveTransition : nil);
}

@end
