//
//  DBPrivateHelperController.h
//  DBPrivacyHelperExample
//
//  Created by iBo on 10/11/14.
//  Copyright (c) 2014 iBo. All rights reserved.
//

#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? 1 : 0)

@import UIKit;

#import "DBPrivacyHelperDataSource.h"

/**
 *  Dismiss completion block
 */
typedef void (^DBPrivateHelperCompletionBlock)(void);

@interface DBPrivateHelperController : UIViewController

/**
 *  Set the status bar style
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/**
 *  Set if the controller can rotate
 */
@property (nonatomic, assign) BOOL canRotate;

/**
 *  Set if the controller should show button "Settings".
 *  Default is YES.
 *  YES will be ignored if settings cannot be opened.
 */
@property (nonatomic, assign) BOOL showOpenSettings;

/**
 *  The close button
 */
@property (nonatomic, readonly, nonnull) UIButton *closeButton;

/**
 *  The settings button. If 'showOpenSettings' set to NO or
 *  settings cannot be opened will be nil
 */
@property (nonatomic, readonly, nullable) UIButton *settingsButton;

/**
 *  The snapshot of the window
 */
@property (nonatomic, strong, nullable) UIImage *snapshot;

/**
 *  Personal App Icon name for DBPrivacyTypeNotifications
 */
@property (nonatomic, strong, nullable) NSString *appIcon;

/**
 *  The dismiss completion block
 */
@property (nonatomic, copy, nullable) DBPrivateHelperCompletionBlock didDismissViewController;

/**
 *  Create an instance of DBPrivateHelperController
 *
 *  @param type The privacy type
 *
 *  @return An instance of DBPrivateHelperController
 */
+ (instancetype __nonnull)helperForType:(DBPrivacyType)type;
@end
