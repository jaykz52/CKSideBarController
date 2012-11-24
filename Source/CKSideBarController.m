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

#import <QuartzCore/QuartzCore.h>
#import "CKSideBarController.h"

#define CKSideBarWidth 80
#define CKCornerRadius 6
#define CKSideBarButtonHeight 80

@interface CKSideBarController ()

@property(nonatomic) UIView *containerView;
@property(nonatomic, strong) UIView *sideBarView;
@property(nonatomic) NSMutableArray *sideMenuButtons;


@end

@implementation CKSideBarController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rough_diagonal.png"]];

        self.sideBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CKSideBarWidth + CKCornerRadius, self.view.bounds.size.height)];
        self.sideBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:self.sideBarView];

        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(CKSideBarWidth, 0, self.view.bounds.size.width - CKSideBarWidth, self.view.bounds.size.height)];
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.containerView];
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    self.selectedViewController.view.frame = self.containerView.bounds;
}

#pragma mark - Autorotation
// iOS 6+
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers != _viewControllers) {
        for (UIViewController *controller in _viewControllers) {
            [controller removeFromParentViewController];
            [controller.view removeFromSuperview];
        }

        _viewControllers = viewControllers;

        for (UIViewController *controller in _viewControllers) {
            [self addChildViewController:controller];

            controller.view.layer.cornerRadius = CKCornerRadius;
            controller.view.clipsToBounds = YES;
        }

        [self createSideMenu];

        if (_viewControllers.count > 0) self.selectedViewController = _viewControllers[0];
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    BOOL delegateRespondsToSelector = [self.delegate respondsToSelector:@selector(sideBarController:shouldSelectViewController:)];
    BOOL shouldSelectController = delegateRespondsToSelector ? [self.delegate sideBarController:self shouldSelectViewController:selectedViewController] : YES;
    if (shouldSelectController && _selectedViewController != selectedViewController) {
        UIViewController *oldController = _selectedViewController;
        _selectedViewController = selectedViewController;

        [self.containerView addSubview:_selectedViewController.view];
        [oldController.view removeFromSuperview];

        for (UIButton *button in self.sideMenuButtons) {
            button.enabled = !(button.tag == [self.viewControllers indexOfObject:_selectedViewController]);
        }

        [self.view setNeedsLayout];

        if ([self.delegate respondsToSelector:@selector(sideBarController:didSelectViewController:)]) {
            [self.delegate sideBarController:self didSelectViewController:_selectedViewController];
        }
    }
}

- (void)createSideMenu {
    for (UIButton *sideButton in self.sideMenuButtons) {
        [sideButton removeFromSuperview];
    }
    self.sideMenuButtons = [[NSMutableArray alloc] init];

    int i = 0;
    for (UIViewController* viewController in self.viewControllers) {
        UIButton *button = [self sideButtonWithTitle:viewController.tabBarItem.title image:viewController.tabBarItem.image];
        button.frame = CGRectMake(0, i * CKSideBarButtonHeight, self.sideBarView.bounds.size.width - CKCornerRadius, CKSideBarButtonHeight);
        button.tag = i;

        [self.sideBarView addSubview:button];
        [self.sideMenuButtons addObject:button];
        i++;
    }
}

- (UIButton *)sideButtonWithTitle:(NSString *)title image:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    if (image) {
        UIImage *plainImage = [self tabBarImage:image size:image.size backgroundImage:nil];
        [button setImage:plainImage forState:UIControlStateNormal];
        [button setImage:plainImage forState:UIControlStateHighlighted];
        [button setImage:[self tabBarImage:image size:image.size backgroundImage:[UIImage imageNamed:@"selected-image-background.png"]] forState:UIControlStateDisabled];

        // the space between the image and text
        CGFloat spacing = 10.0;
        float   textMargin = 6;

        // get the size of the elements here for readability
        CGSize  imageSize   = image.size;
        CGSize  titleSize   = button.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);      // get the height they will take up as a unit

        // lower the text and push it left to center it
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width +textMargin, - (totalHeight - titleSize.height), +textMargin );   // top, left, bottom, right

        // the text width might have changed (in case it was shortened before due to
        // lack of space and isn't anymore now), so we get the frame size again
        titleSize = button.titleLabel.bounds.size;

        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
    }
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClicked:(id)sender {
    NSInteger buttonIndex = ((UIButton *) sender).tag;
    self.selectedViewController = self.viewControllers[buttonIndex];
}

-(UIImage*)tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource {
    UIImage* backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];

    // Convert the passed in image to a white backround image with a black fill
    UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];

    // Create an image mask
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
            CGImageGetHeight(bwImage.CGImage),
            CGImageGetBitsPerComponent(bwImage.CGImage),
            CGImageGetBitsPerPixel(bwImage.CGImage),
            CGImageGetBytesPerRow(bwImage.CGImage),
            CGImageGetDataProvider(bwImage.CGImage), NULL, YES);

    // Using the mask create a new image
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);

    UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];

    // Cleanup
    CGImageRelease(imageMask);
    CGImageRelease(tabBarImageRef);

    // Create a new context with the right size
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);

    // Draw the new tab bar image at the center
    [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];

    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

// Convert the image's fill color to black and background to white
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage {
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));

    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);

    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);

    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color to black: R:0 G:0 B:0 alpha:1
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    // Fill with black
    CGContextFillRect(context, imageRect);

    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];

    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);

    return newImage;
}

- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage {
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backgroundImage) {
        // Draw the background image centered
        [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2, CGImageGetWidth(backgroundImage.CGImage), CGImageGetHeight(backgroundImage.CGImage))];
    } else {
        [[UIColor lightGrayColor] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }

    UIImage *finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return finalBackgroundImage;
}

@end