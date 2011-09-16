//
//  BootCamp_iOSAppDelegate.m
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BootCamp_iOSAppDelegate.h"
#import "TwitterViewController.h"

@implementation BootCamp_iOSAppDelegate


@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set root view to navigation controller
    self.window.rootViewController = self.navigationController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
