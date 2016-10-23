//
//  AppDelegate.h
//  Gogo
//
//  Created by Thuong on 8/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReloadNotificationViewController <NSObject>

-(void) refreshViewController;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) id <ReloadNotificationViewController> delegate;

@end

