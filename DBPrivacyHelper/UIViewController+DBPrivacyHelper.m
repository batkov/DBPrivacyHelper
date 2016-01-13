//
//  UIViewController+DBPrivacyHelper.m
//  DBPrivacyHelperExample
//
//  Created by iBo on 10/11/14.
//  Copyright (c) 2014 iBo. All rights reserved.
//

#import "UIViewController+DBPrivacyHelper.h"
#import <objc/runtime.h>

@implementation UIViewController (DBPrivacyHelper)

#pragma mark - Public method

- (void)showPrivacyHelperForType:(DBPrivacyType)type
{
    [self showPrivacyHelperForType:type controller:nil didPresent:nil didDismiss:nil useDefaultSettingPane:YES];
}

- (void)showPrivacyHelperForType:(DBPrivacyType)type
                      controller:(void(^)(DBPrivateHelperController *vc))controllerBlock
                      didPresent:(DBPrivateHelperCompletionBlock)didPresent
                      didDismiss:(DBPrivateHelperCompletionBlock)didDismiss
           useDefaultSettingPane:(BOOL)defaultSettingPane {
    
    if ([self canOpenAppSettings] && defaultSettingPane) {
        [self openAppSettings];
        return;
    }
    
    DBPrivateHelperController *vc = [DBPrivateHelperController helperForType:type];
    vc.appIcon = self.appIcon;
    vc.didDismissViewController = didDismiss;
    vc.snapshot = [self snapshot];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if (controllerBlock) {
        controllerBlock(vc);
    }
    
    [self presentViewController:vc animated:YES completion:didPresent];
}

- (UIImage *)snapshot
{
    id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, NO, appDelegate.window.screen.scale);
    
    [appDelegate.window drawViewHierarchyInRect:appDelegate.window.bounds afterScreenUpdates:NO];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}


#pragma mark - Override getter/setter

- (void)setAppIcon:(NSString *)appIcon
{
    objc_setAssociatedObject(self, @"kAppIcon", appIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)appIcon
{
    return objc_getAssociatedObject(self, @"kAppIcon");
}

#pragma mark - Settings handling

- (BOOL)canOpenAppSettings
{
    static BOOL canOpenSettings = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (IS_IOS_8) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
            if (&UIApplicationOpenSettingsURLString != NULL) {
#pragma clang diagnostic pop
                canOpenSettings = YES;
            }
        }
    });
    return canOpenSettings;
}

- (void)openAppSettings
{
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:appSettings];
}

@end