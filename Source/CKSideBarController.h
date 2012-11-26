//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "CKSideBarItem.h"

@protocol CKSideBarControllerDelegate;


@interface CKSideBarController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, weak) id<CKSideBarControllerDelegate> delegate;

// TODO: get rid of this method (KVO on sideBarItem on managed viewControllers)
- (void)refresh;

@end


@protocol CKSideBarControllerDelegate <NSObject>

@optional
- (BOOL)sideBarController:(CKSideBarController *)sideBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)sideBarController:(CKSideBarController *)sideBarController didSelectViewController:(UIViewController *)viewController;

@end


@interface UIViewController (CKSideBarController)

@property (nonatomic, readonly, strong) CKSideBarController *sideBarController;     // If the view controller has a side bar controller as its ancestor, return it. Returns nil otherwise.
@property (nonatomic) CKSideBarItem *sideBarItem;

@end
