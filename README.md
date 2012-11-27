# CKSideBarController
CKSideBarController is a UITabBarController-like UIViewController for iPad. It's inspired by Twitter for iPad, as well as my own work. Take a look at the example app included in the source code to see what you can do with CKSideBarController, see the below walkthrough, or dig into the source code!

![Screenshot](http://cloud.github.com/downloads/jaykz52/CKSideBarController/screenshot1.png)

## Dependencies
To use CKSideBarViewController in your project, in addition to `UIKit.framework` and `Foundation.framework` you'll need to link against the following frameworks:
* CoreGraphics.framework
* QuartzCore.framework

## Adding CKSideBarController to your XCode project
CocoaPods outstanding, the easiest way to integrate CKSideBarController into your project is to clone the repo and add all of the items under the `Source` directory. This includes a few image resources used by CKSideBarController.

CKSideBarController uses ARC, so for non-ARC projects, you'll want to add the `f-objc-arc` linker flag for  `CKSideBarController.m` and `CKSideBarItem.m`.

## Using CKSideBarController
CKSideBarController, like UITabBarController and UISplitViewController, works best as the rootViewController of your application:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.barController = [[CKSideBarController alloc] init];
    self.window.rootViewController = self.barController;

    [self.window makeKeyAndVisible];

    return YES;
}
```

In order to provide content for the CKSideBarController, you assign an array of UIViewControllers to the `viewControllers` property of your CKSideBarController instance:

```objective-c
- (void)someMethod {
    self.barController.viewControllers = @[
      [[FirstViewController alloc] init],
      [[SecondViewController alloc] init],
      [[ThirdViewController alloc] init]
    ];
}
```

We can configure how each UIViewController managed by the bar controller is displayed by setting by manipulating each's `sideBarItem`. You'll need to import the `CKSideBarController.h` file in order to see the `sideBarItem` property.

```objective-c
#import "CKSideBarController.m"

// ...

@implementation FirstViewController

- (id)init {
    self = [super init];
    if (self) {
        self.sideBarItem.title = @"First";
        self.sideBarItem.image = [UIImage imageNamed:@"first.png"];
        self.sideBarItem.isGlowing = YES;

        // do something awesome...
    }
    return self;
}

// ...

@end
```

For more fine-grained control over the CKSideBarController's behavior is via the CKSideBarController's delegate. All methods in the `CKSideBarControllerDelegate` are optional, so implement the ones important to you. Be sure to set the `delegate` property of your CKSideBarController to the appropriate object.

```objective-c
#pragma mark - CKSideBarControllerDelegate

// Remember sideBarController.delegate = self !!!

- (BOOL)sideBarController:(CKSideBarController *)sideBarController shouldSelectViewController:(UIViewController *)viewController {
    return NO;  // can't touch this
}

- (void)sideBarController:(CKSideBarController *)sideBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"viewController %@ selected!", viewController);
}
```

Lastly, if you import the `CKSideBarController.h`, you can access the CKSideBarController ancestor of any UIViewController (if one exists) via the `sideBarController property` mixed into the UIViewCOntroller class. This is much like UINavigationController and UITabBarController. If there is no CKSideBarController ancestor, the property will simply be nil.

## Customizing
Currently, the only way to customize the look and feel of CKSideBarController is to alter the source files. The view code is fairly readable, searching on `UIFont`, `UIColor`, and `UIImage` should give you a good starting point.

Currently, Updating a UIViewController's `sideBarItem` does not trigger a UI refresh. As a stop-gap, you can call the `refresh` method on the CKSideBarController to manually trigger a UI refresh.

## Contributing
Automatic UI Refreshing on `sideBarItem` updates does not currently happen. Additionally, it would be nice to provide UI customization points to help match the look-and-feel of the app integrating the controller.

## License (MIT)
Copyright (c) 2012 Jason Kozemczak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.