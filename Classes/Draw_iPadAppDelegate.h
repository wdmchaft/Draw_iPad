//
//  Draw_iPadAppDelegate.h
//  Draw_iPad
//
//  Created by Dennis Hübner on 30.11.10.
//  Copyright 2010 huebys inventions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Draw_iPadViewController;

@interface Draw_iPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Draw_iPadViewController *viewController;
	IBOutlet UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Draw_iPadViewController *viewController;

@end

