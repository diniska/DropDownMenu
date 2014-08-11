//
//  MAKDropDownMenu.h
//  Scout
//
//  Created by Denis Chaschin on 17.07.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAKDropDownMenu;

@protocol MAKDropDownMenuDelegate <NSObject>
- (void)dropDownMenu:(MAKDropDownMenu *)menu itemDidSelect:(NSUInteger)itemIndex;
@optional
- (void)dropDownMenuDidTapOutsideOfItem:(MAKDropDownMenu *)menu;
@end

@interface MAKDropDownMenu : UIView
@property (strong, nonatomic) NSArray *titles;
@property (weak, nonatomic) id<MAKDropDownMenuDelegate> delegate;
@property (strong, nonatomic) UIColor *buttonBackgroundColor;
@property (strong, nonatomic) UIColor *tintColor;
@property (assign, nonatomic) CGFloat separatorHeight;
@property (assign, nonatomic) UIEdgeInsets buttonsInsets;
@property (assign, nonatomic, readonly) BOOL isOpen;

- (void)openAnimated:(BOOL)animated;
- (void)closeAnimated:(BOOL)animated;
@end
