//
//  CKAppDelegate.h
//  CKSideBarController
//
//  Created by Jason Kozemczak on 11/23/12.
//  Copyright (c) 2012 Jason Kozemczak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKSideBarController;

@interface CKAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;

- (void)updateViewControllers;

@end