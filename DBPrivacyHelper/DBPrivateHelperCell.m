//
//  DBPrivateHelperCell.m
//  DBPrivacyHelperExample
//
//  Created by iBo on 10/11/14.
//  Copyright (c) 2014 iBo. All rights reserved.
//

#import "DBPrivateHelperCell.h"

NSString *const kDBPrivateHelperCellIdentifier = @"kDBPrivateHelperCellIdentifier";


@implementation DBPrivateHelperCell {
    UIImageView *_iconView;
    UILabel *_cellLabel;
    UILabel *_numberLabel;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = self.backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _numberLabel = [[UILabel alloc] init];
        
        _numberLabel.font = [UIFont systemFontOfSize:10.0];
        _numberLabel.textColor = [UIColor colorWithWhite:1.0 alpha:.75];
        _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_numberLabel];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_iconView];
        _cellLabel = [[UILabel alloc] init];
        _cellLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _cellLabel.backgroundColor = [UIColor clearColor];
        _cellLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _cellLabel.textColor = [UIColor whiteColor];
        _cellLabel.textAlignment = NSTextAlignmentLeft;
        _cellLabel.numberOfLines = 0;
        _cellLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_cellLabel];
        UILabel * textLabel = _numberLabel;
        NSDictionary *views = NSDictionaryOfVariableBindings(_iconView, _cellLabel, textLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_iconView(30)]-20-[_cellLabel]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_cellLabel
                                                                     attribute:NSLayoutAttributeLeft multiplier:1.f
                                                                      constant:-3]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_cellLabel
                                                                     attribute:NSLayoutAttributeCenterY multiplier:1.f
                                                                      constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_iconView(30)]"
                                                                                 options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_cellLabel]-0-|"
                                                                                 options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    return self;
}

- (void) setIcon:(NSString *)icon text:(NSString *)text row:(NSInteger)row {
    _iconView.image = [UIImage imageNamed:icon inBundle:[NSBundle bundleForClass:[DBPrivateHelperCell class]] compatibleWithTraitCollection:nil];
    _cellLabel.text = text;
    _numberLabel.text = [NSString stringWithFormat:@"%li.", (long)row];
}

@end
