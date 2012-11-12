//
//  AppDelegate.h
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDAudioManager.h"


@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

-(void) setUpAudioManager:(NSObject*) data;

@end
