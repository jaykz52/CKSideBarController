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

#define CKSideBarWidth 84
#define CKCornerRadius 6
#define CKSideBarButtonHeight 84
#define CKSideBarImageEdgeLength 28


@interface CKSideBarCell : UITableViewCell

@property (nonatomic) UIImageView *iconView;
@property (nonatomic) UIImage *image;
@property (nonatomic) UILabel *titleLabel;

- (void)setIsActive:(BOOL)isActive;

@end

@implementation CKSideBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.iconView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = 6.0;
    CGFloat width = self.contentView.frame.size.width - CKCornerRadius;
    self.iconView.frame = CGRectMake((width / 2) - (CKSideBarImageEdgeLength / 2), (self.bounds.size.height / 2) - (CKSideBarImageEdgeLength / 2), CKSideBarImageEdgeLength, CKSideBarImageEdgeLength);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconView.frame) + spacing, width, 11);
}

- (void)setIsActive:(BOOL)isActive {
    self.titleLabel.textColor = isActive ? [UIColor whiteColor] : [UIColor lightGrayColor];
    UIImage *plainImage = [self tabBarImage:self.image size:self.image.size backgroundImage:nil];
    UIImage *activeImage = [self tabBarImage:self.image size:self.image.size backgroundImage:[UIImage imageNamed:@"selected-image-background.png"]];
    self.iconView.image = isActive ? activeImage : plainImage;
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

@interface CKSideBarController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) UIView *containerView;
@property(nonatomic, strong) UITableView *sideBarView;

@end

@implementation CKSideBarController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rough_diagonal.png"]];

        self.sideBarView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CKSideBarWidth + CKCornerRadius, self.view.bounds.size.height) style:UITableViewStylePlain];
        self.sideBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        self.sideBarView.backgroundColor = [UIColor clearColor];
        self.sideBarView.scrollEnabled = NO;
        self.sideBarView.dataSource = self;
        self.sideBarView.delegate = self;
        self.sideBarView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sideBarView.rowHeight = CKSideBarButtonHeight;
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
        BOOL isSelectedControllerPresent = [viewControllers containsObject:_selectedViewController];
        NSUInteger previousSelectedIndex = self.selectedIndex;

        for (UIViewController *controller in _viewControllers) {
            if (controller != _selectedViewController || !isSelectedControllerPresent) {
                [controller.view removeFromSuperview];
                [controller removeFromParentViewController];
            }
        }

        _viewControllers = viewControllers;

        for (UIViewController *controller in _viewControllers) {
            [self addChildViewController:controller];

            controller.view.layer.cornerRadius = CKCornerRadius;
            controller.view.clipsToBounds = YES;
        }

        if (_selectedViewController && [_viewControllers containsObject:self.selectedViewController]) {
            // we cool
        } else {
            self.selectedViewController = _viewControllers[previousSelectedIndex];
        }

        [self.sideBarView reloadData];
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

        [self.sideBarView reloadData];

        [self.view setNeedsLayout];

        if ([self.delegate respondsToSelector:@selector(sideBarController:didSelectViewController:)]) {
            [self.delegate sideBarController:self didSelectViewController:_selectedViewController];
        }
    }
}

- (NSUInteger)selectedIndex {
    if (self.selectedViewController) {
        return [self.viewControllers indexOfObject:self.selectedViewController];
    } else {
        return 0;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.selectedViewController = self.viewControllers[selectedIndex];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKSideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideBar"];
    if (!cell) {
        cell = [[CKSideBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sideBar"];
    }

    UIViewController *viewController = self.viewControllers[indexPath.row];
    NSString *title = viewController.tabBarItem.title ? viewController.tabBarItem.title : viewController.title;
    UIImage *image = viewController.tabBarItem.image ? viewController.tabBarItem.image : [UIImage imageNamed:@"default-tabbar-icon.png"];
    cell.titleLabel.text = title;
    [cell setImage:image];
    [cell setIsActive:(viewController == self.selectedViewController)];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedViewController = self.viewControllers[indexPath.row];
    [self.sideBarView reloadData];
}

@end