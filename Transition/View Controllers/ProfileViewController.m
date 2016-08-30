//
//  ProfileViewController.m
//  Transition
//
//  Created by Pablo Romero on 8/25/16.
//  Copyright © 2016 Pablo Romero. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - DismissingInteractiveTransitionDelegate

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - IBActions

- (IBAction)cancelButtonTouched:(id)sender
{
    [self dismissViewController];
}

@end
