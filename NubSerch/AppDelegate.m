//
//  AppDelegate.m
//  NubSerch
//
//  Created by Fu_sion on 7/24/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    }
    else
    {
        NSWindow *window = [[NSApplication sharedApplication].windows lastObject];
        [window makeKeyAndOrderFront:self];
        return YES;
    }
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
