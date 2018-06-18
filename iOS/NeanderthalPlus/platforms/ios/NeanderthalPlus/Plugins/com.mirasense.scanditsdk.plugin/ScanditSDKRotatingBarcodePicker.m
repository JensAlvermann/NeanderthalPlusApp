//
//  Copyright 2010 Mirasense AG
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  ScanditSDKRotatingBarcodePicker is a utility class in the demo that shows how to make the
//  ScanditSDKBarcodePicker properly change its orientation when the device is rotated by the
//  user. This class is not required when the Scandit SDK is used in portrait mode only.
//

#import "ScanditSDKRotatingBarcodePicker.h"

#import "ScanditSDK.h"


@interface SBSBarcodePicker (extended)
- (id)initWithSettings:(SBSScanSettings *)settings
    runningOnFramework:(NSString *)usedFramework;
@end

@interface ScanditSDKRotatingBarcodePicker() <UISearchBarDelegate>
@property (nonatomic, strong) ScanditSDKSearchBar *manualSearchBar;
@property (nonatomic, strong) UIView *statusBarBackground;
@property (nonatomic, assign) BOOL didSetSize;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@end


@implementation ScanditSDKRotatingBarcodePicker

- (instancetype)initWithSettings:(SBSScanSettings *)settings{
    if (self = [super initWithSettings:settings]) {
        [self setPortraitMargins:CGRectMake(0, 0, 0, 0)];
        [self setLandscapeMargins:CGRectMake(0, 0, 0, 0)];
    }
    
    return self;
}


#pragma mark - Orientation Changes & Margin Adjustment

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self adjustSize:0];
}

- (void)adjustSize:(CGFloat)animationDuration {
    if (self.parentViewController && self.view.superview) {

        [UIView animateWithDuration:animationDuration animations:^{
            CGRect margins = self.portraitMargins;
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                margins = self.landscapeMargins;
            }
            
            [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            if (!self.leftConstraint) {
                self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:margins.origin.x];
                [self.view.superview addConstraint:self.leftConstraint];
            } else {
                self.leftConstraint.constant = margins.origin.x;
            }
            
            if (!self.topConstraint) {
                self.topConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view.superview
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:margins.origin.y];
                [self.view.superview addConstraint:self.topConstraint];
            } else {
                self.topConstraint.constant = margins.origin.y;
            }
            
            if (!self.rightConstraint) {
                self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view.superview
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:-margins.size.width];
                [self.view.superview addConstraint:self.rightConstraint];
            } else {
                self.rightConstraint.constant = -margins.size.width;
            }
            
            if (!self.bottomConstraint) {
                self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view.superview
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-margins.size.height];
                [self.view.superview addConstraint:self.bottomConstraint];
            } else {
                self.bottomConstraint.constant = -margins.size.height;
            }
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Search Bar

- (void)showSearchBar:(BOOL)show {
    dispatch_main_sync_safe(^{
        if (!show && self.manualSearchBar) {
            [self.manualSearchBar removeFromSuperview];
            self.manualSearchBar = nil;
            if (self.statusBarBackground) {
                [self.statusBarBackground removeFromSuperview];
                self.statusBarBackground = nil;
            }
            
            [self.overlayController setTorchButtonLeftMargin:15 topMargin:15 width:40 height:40];
            [self.overlayController setCameraSwitchButtonRightMargin:15 topMargin:15 width:40 height:40];
            
        } else if (show && !self.manualSearchBar) {
            [self createManualSearchBar];
            
            [self.overlayController setTorchButtonLeftMargin:15 topMargin:15 + 44 width:40 height:40];
            [self.overlayController setCameraSwitchButtonRightMargin:15 topMargin:15 + 44 width:40 height:40];
        }
    });
}

- (void)createManualSearchBar {
    self.manualSearchBar = [[ScanditSDKSearchBar alloc] init];
    [self.manualSearchBar setDelegate:self];
    [self.manualSearchBar setTranslucent:YES];
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        self.statusBarBackground = [[UIView alloc] init];
        self.statusBarBackground.backgroundColor = [UIColor whiteColor];
    }
    
    [self.view addSubview:self.manualSearchBar];
    
    [self setConstraintsForView:self.manualSearchBar toHorizontallyMatch:self.view];
    [self.view addConstraint:[self topGuideConstraintForView:self.manualSearchBar
                                                     toMatch:self
                                                withConstant:[self navigationBarOffset]]];
    
    if (self.statusBarBackground) {
        [self.view addSubview:self.statusBarBackground];
        [self setConstraintsForView:self.statusBarBackground toHorizontallyMatch:self.view];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.statusBarBackground
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.statusBarBackground
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.manualSearchBar
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:0.0]];
    }
}

- (CGFloat)navigationBarOffset {
    if ((self.navigationController && !self.navigationController.navigationBar.hidden)
        && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1
        && NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return 32;
        } else {
            return 44;
        }
    } else {
        return 0.0;
    }
}

- (NSLayoutConstraint *)topGuideConstraintForView:(UIView *)view
                                          toMatch:(UIViewController *)controller
                                     withConstant:(CGFloat)constant {
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        return [NSLayoutConstraint constraintWithItem:view
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:controller.topLayoutGuide
                                            attribute:NSLayoutAttributeBottom
                                           multiplier:1.0
                                             constant:constant];
    } else {
        return [NSLayoutConstraint constraintWithItem:view
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:controller.view
                                            attribute:NSLayoutAttributeTop
                                           multiplier:1.0
                                             constant:constant];
    }
}

- (void)setConstraintsForView:(UIView *)view
          toHorizontallyMatch:(UIView *)refView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:view
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:refView
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0
                                               constant:0];
    [refView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:view
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:refView
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0
                                               constant:0];
    [refView addConstraint:constraint];
}


#pragma mark - UISearchBarDelegate methods

/*
 * The search bar feature has been deprecated and is now only available when using the "old"
 * ScanditSDK interface. That's why these methods are defined here rather than in the base
 * class.
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchbar {
    [searchbar setShowsCancelButton:YES animated:YES];
    [((ScanditSDKSearchBar *)self.manualSearchBar) updateCancelButton];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc]
                          initWithTarget:self
                          action:@selector(cancelSearch)];
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchbar {
    [searchbar setShowsCancelButton:NO animated:YES];
    [searchbar resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapRecognizer];
    self.tapRecognizer = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchbar {
    [searchbar resignFirstResponder];
    searchbar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchbar textDidChange:(NSString *)searchText {
    [((ScanditSDKSearchBar *)self.manualSearchBar) updateCancelButton];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar {
    [searchbar resignFirstResponder];
    [searchbar setShowsCancelButton:NO animated:YES];
    [self.searchDelegate searchExecutedWithContent:searchbar.text];
}

- (void)cancelSearch {
    [self.manualSearchBar resignFirstResponder];
}

@end
