//
//  BootCamp_iOSAppDelegate.h
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterViewController;

@interface BootCamp_iOSAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) TwitterViewController *twitterViewController;

@end
