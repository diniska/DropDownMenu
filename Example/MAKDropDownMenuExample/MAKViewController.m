//
//  MAKViewController.m
//  MAKDropDownMenuExample
//
//  Created by Denis Chaschin on 17.07.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import "MAKViewController.h"
#import "MAKDropDownMenu.h"

@interface MAKViewController () <MAKDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectedItem;
@property (weak, nonatomic) MAKDropDownMenu *menu;
@property (nonatomic) NSInteger *selectedItemId;
@end

@implementation MAKViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Menu customization
    MAKDropDownMenu *menu = [[MAKDropDownMenu alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, self.navigationController.view.bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)}];
    menu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    menu.backgroundColor = [UIColor colorWithWhite:.3f alpha:.5f];
    menu.tintColor = [UIColor colorWithWhite:.1f alpha:1.f];
    menu.buttonBackgroundColor = [UIColor whiteColor];
    menu.titles = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6", @"Item 7"];
    menu.separatorHeight = 1 / [UIScreen mainScreen].scale;
    menu.layer.masksToBounds = YES;
    menu.buttonsInsets = UIEdgeInsetsMake(1 / [UIScreen mainScreen].scale, 0, 0, 0);
    menu.delegate = self;
    _selectedItemId = -1;
    
    //adding menu to navigation view
    [self.navigationController.view addSubview:menu];
    self.menu = menu;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.menu removeFromSuperview];
    self.menu = nil;
}

#pragma mark - Buttons events
- (IBAction)menuButtonDidClick:(id)sender {
    if (self.menu.isOpen) {
        [self closeMenu];
    } else {
        [self openMenu];
    }
}

- (void)closeMenu {
    [self.menu closeAnimated:YES];
}

- (void)openMenu {
    [self.menu openAnimated:YES withActiveButtonId:_selectedItemId];
}

#pragma mark - MAKDropDownMenuDelegate
- (void)dropDownMenu:(MAKDropDownMenu *)menu itemDidSelect:(NSUInteger)itemIndex {
    self.selectedItem.text = [NSString stringWithFormat:@"%u", (unsigned int)(itemIndex + 1)];
    _selectedItemId = itemIndex;
    [self closeMenu];
}

- (void)dropDownMenuDidTapOutsideOfItem:(MAKDropDownMenu *)menu {
    [self closeMenu];
}
@end
