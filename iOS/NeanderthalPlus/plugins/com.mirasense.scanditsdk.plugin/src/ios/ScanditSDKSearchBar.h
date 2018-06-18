//
//  SCSearchBar.h
//  ScanditBarcodeScanner
//
//  Created by Moritz Hartmeier on 22/05/15.
//  Copyright (c) 2015 Scandit AG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScanditSDKSearchBar : UISearchBar
@property (nonatomic, strong) NSString *goButtonCaption;
@property (nonatomic, strong) NSString *cancelButtonCaption;
@property (nonatomic, assign) NSInteger minTextLengthForSearch;
@property (nonatomic, assign) NSInteger maxTextLengthForSearch;

/**
 * Restores the default settings.
 */
- (void)restoreDefaults;

- (void)updateCancelButton;

@end
