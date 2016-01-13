//
//  DBPrivateHelperController.m
//  DBPrivacyHelperExample
//
//  Created by iBo on 10/11/14.
//  Copyright (c) 2014 iBo. All rights reserved.
//

#import "DBPrivateHelperController.h"
#import "DBPrivacyHelperDataSource.h"
#import "UIImage+ImageEffects.h"
#import "UIViewController+DBPrivacyHelper.h"

@interface DBPrivateHelperController () <UITableViewDelegate> {
    DBPrivacyType _type;
    DBPrivacyHelperDataSource *_dataSource;
    UIImageView *_backgroundImage;
    UITableView *_tableView;
}
@end

@implementation DBPrivateHelperController

#pragma mark - Life cycle

+ (instancetype)helperForType:(DBPrivacyType)type
{
    return [[self.class alloc] initWithPrivacyType:type];
}

- (instancetype)initWithPrivacyType:(DBPrivacyType)type
{
    self = [super init];
    if (self) {
        _type = type;
        _canRotate = NO;
        _showOpenSettings = YES;
        _statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSource = [DBPrivacyHelperDataSource new];
    _dataSource.appIcon = self.appIcon;
    _dataSource.type = _type;
    
    _backgroundImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_backgroundImage];

    if ( IS_IOS_8 ) {
        _backgroundImage.image = self.snapshot;

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = _backgroundImage.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [_backgroundImage addSubview:blurEffectView];

        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        vibrancyEffectView.frame = _backgroundImage.bounds;
        vibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [blurEffectView.contentView addSubview:vibrancyEffectView];
        [_backgroundImage addSubview:blurEffectView];
    } else {
        _backgroundImage.image = [self.snapshot applyDarkEffect];
    }

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 80 }];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.text = _dataSource.cellData[@(_type)][@"header"];
    titleLabel.numberOfLines = 2;

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[DBPrivateHelperCell class] forCellReuseIdentifier:kDBPrivateHelperCellIdentifier];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.tableHeaderView = titleLabel;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _closeButton.backgroundColor = [UIColor clearColor];
    [_closeButton setTitle:[@"Close" dbph_LocalizedString].uppercaseString forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(bdph_dismissHelper:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    if (self.showOpenSettings && [self canOpenAppSettings]) {
        _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
        _settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _settingsButton.backgroundColor = [UIColor clearColor];
        [_settingsButton setTitle:[@"Settings" dbph_LocalizedString].uppercaseString forState:UIControlStateNormal];
        [_settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settingsButton addTarget:self action:@selector(bdph_showSettings:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_settingsButton];
    }
    UIButton * leftButton = _closeButton;
    UIButton * rightButton = _settingsButton;
    NSMutableDictionary *views = [NSDictionaryOfVariableBindings(_tableView) mutableCopy];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
    BOOL verticalConstantAdded = NO;
    if (leftButton) {
        [views addEntriesFromDictionary:NSDictionaryOfVariableBindings(leftButton)];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[leftButton]" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[leftButton(30)]-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
        verticalConstantAdded = YES;
    }
    if (rightButton) {
        [views addEntriesFromDictionary:NSDictionaryOfVariableBindings(rightButton)];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightButton]-20-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[rightButton(30)]-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
        verticalConstantAdded = YES;
    }
    
    if (!verticalConstantAdded) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_tableView]-0-|" options:0 metrics:nil views:views]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.snapshot = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private methods

- (void)bdph_dismissHelper:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:self.didDismissViewController];
}

- (void)bdph_showSettings:(UIButton *)button
{
    [self openAppSettings];
    [self bdph_dismissHelper:button];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}


#pragma mark - ViewController Rotation

- (BOOL)shouldAutorotate
{
    return self.canRotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


@end