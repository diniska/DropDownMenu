//
//  MAK
//  Scout
//
//  Created by Denis Chaschin on 17.07.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import "MAKDropDownMenu.h"

static const int kTagPadding = 12;
static const CGFloat kButtonHeight = 44;
static const NSTimeInterval kAnimationDuration = .3;

@implementation MAKDropDownMenu {
    NSArray *_buttons;
    UIColor *_privateBackgroundColor;
}
@synthesize isOpen = _isOpen;

#pragma mark - Setters

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.userInteractionEnabled = NO;
    [self updateBackgroundColor];
    self.tintColor = [UIColor blackColor];
    _buttonBackgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    [self addGestureRecognizer:recognizer];
    _isOpen = NO;
}

- (void)setTitles:(NSArray *)titles {
    for (UIView *button in _buttons) {
        [button removeFromSuperview];
    }
    NSMutableArray *newButtons = [NSMutableArray arrayWithCapacity:titles.count];
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){0, -kButtonHeight, self.bounds.size.width, kButtonHeight}];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        button.tag = kTagPadding + idx;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.tintColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.buttonBackgroundColor];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [newButtons addObject:button];
    }];
    _buttons = [newButtons copy];
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
    _buttonBackgroundColor = buttonBackgroundColor;
    dispatch_apply(_buttons.count, dispatch_get_main_queue(), ^(size_t index) {
        UIButton *button = _buttons[index];
        [button setBackgroundColor:buttonBackgroundColor];
    });
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;    
    dispatch_apply(_buttons.count, dispatch_get_main_queue(), ^(size_t index) {
        UIButton *button = _buttons[index];
        [button setTitleColor:self.tintColor forState:UIControlStateNormal];
    });
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _privateBackgroundColor = backgroundColor;
    [self updateBackgroundColor];
}

- (void)updateBackgroundColor {
    if (self.userInteractionEnabled) {
        [super setBackgroundColor:_privateBackgroundColor];
    } else {
        [super setBackgroundColor:[_privateBackgroundColor colorWithAlphaComponent:0]];
    }
}

#pragma mark - Animations

- (void)openAnimated:(BOOL)animated {
    if (self.isOpen) {
        return;
    }
    _isOpen = YES;
    
    CGFloat const y = -kButtonHeight;
    for (UIButton *button in _buttons) {
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.y = y;
        button.frame = buttonFrame;
    }
    
    void (^showblock)(void) = ^{
        CGFloat const rowHeight = kButtonHeight + self.separatorHeight;
        [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            CGRect buttonFrame = button.frame;
            buttonFrame.origin.y = idx * rowHeight + self.buttonsInsets.top;
            button.frame = buttonFrame;
        }];
        self.userInteractionEnabled = YES;
        [self updateBackgroundColor];
    };
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:showblock];
    } else {
        showblock();
    }
}

- (void)closeAnimated:(BOOL)animated {
    if (!_isOpen) {
        return;
    }
    _isOpen = NO;
    
    void (^hideBlock)(void) = ^{
        CGFloat const y = -kButtonHeight;
        for (UIButton *button in _buttons) {
            CGRect buttonFrame = button.frame;
            buttonFrame.origin.y = y;
            button.frame = buttonFrame;
        }
        self.userInteractionEnabled = NO;
        [self updateBackgroundColor];
    };
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:hideBlock];
    } else {
        hideBlock();
    }
}

#pragma mark - Click listener
- (void)buttonDidClick:(UIButton *)button {
    const NSUInteger index = button.tag - kTagPadding;
    [self.delegate dropDownMenu:self itemDidSelect:index];
}

- (void)didTap {
    if ([self.delegate respondsToSelector:@selector(dropDownMenuDidTapOutsideOfItem:)]) {
        [self.delegate dropDownMenuDidTapOutsideOfItem:self];
    }
}
@end
