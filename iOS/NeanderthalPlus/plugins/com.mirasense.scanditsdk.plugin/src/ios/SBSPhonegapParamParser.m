//
//  SBSPhonegapParamParser.m
//  Hello World
//
//  Created by Moritz Hartmeier on 02/12/15.
//
//

#import "SBSPhonegapParamParser.h"

#import "SBSLegacyUIParamParser.h"
#import "SBSUIParamParser.h"


@implementation SBSPhonegapParamParser

+ (NSString *)paramContinuousMode { return [@"continuousMode" lowercaseString]; }
+ (NSString *)paramPortraitMargins { return [@"portraitMargins" lowercaseString]; }
+ (NSString *)paramLandscapeMargins { return [@"landscapeMargins" lowercaseString]; }
+ (NSString *)paramAnimationDuration { return [@"animationDuration" lowercaseString]; }

+ (NSString *)paramPaused { return [@"paused" lowercaseString]; }

+ (NSString *)paramOrientations { return [@"orientations" lowercaseString]; }
+ (NSString *)paramOrientationsPortrait { return [@"portrait" lowercaseString]; }
+ (NSString *)paramOrientationsPortraitUpsideDown { return [@"portraitUpsideDown" lowercaseString]; }
+ (NSString *)paramOrientationsLandscapeLeft { return [@"landscapeLeft" lowercaseString]; }
+ (NSString *)paramOrientationsLandscapeRight { return [@"landscapeRight" lowercaseString]; }

+ (NSString *)paramSearchBar { return [@"searchBar" lowercaseString]; }
+ (NSString *)paramSearchBarActionButtonCaption { return [@"searchBarActionButtonCaption" lowercaseString]; }
+ (NSString *)paramSearchBarCancelButtonCaption { return [@"searchBarCancelButtonCaption" lowercaseString]; }
+ (NSString *)paramSearchBarPlaceholderText { return [@"searchBarPlaceholderText" lowercaseString]; }
+ (NSString *)paramMinSearchBarBarcodeLength { return [@"minSearchBarBarcodeLength" lowercaseString]; }
+ (NSString *)paramMaxSearchBarBarcodeLength { return [@"maxSearchBarBarcodeLength" lowercaseString]; }


+ (void)updatePicker:(ScanditSDKRotatingBarcodePicker *)picker
         fromOptions:(NSDictionary *)options
  withSearchDelegate:(id<ScanditSDKSearchBarDelegate>)searchDelegate {
    
    NSObject *orientationsObj = [options objectForKey:[self paramOrientations]];
    if (orientationsObj) {
        NSUInteger allowed = 0;
        if ([orientationsObj isKindOfClass:[NSString class]]) {
            NSString *orientationsString = (NSString *)orientationsObj;
            if ([orientationsString rangeOfString:[self paramOrientationsPortrait]].location != NSNotFound) {
                allowed = allowed | (1 << UIInterfaceOrientationPortrait);
            }
            if ([orientationsString rangeOfString:[self paramOrientationsPortraitUpsideDown]].location != NSNotFound) {
                allowed = allowed | (1 << UIInterfaceOrientationPortraitUpsideDown);
            }
            if ([orientationsString rangeOfString:[self paramOrientationsLandscapeLeft]].location != NSNotFound) {
                allowed = allowed | (1 << UIInterfaceOrientationLandscapeLeft);
            }
            if ([orientationsString rangeOfString:[self paramOrientationsLandscapeRight]].location != NSNotFound) {
                allowed = allowed | (1 << UIInterfaceOrientationLandscapeRight);
            }
          
        } else if ([orientationsObj isKindOfClass:[NSArray class]]) {
            NSArray *orientationsArray = (NSArray *)orientationsObj;
            for (NSObject *obj in orientationsArray) {
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *orientationsString = (NSString *)obj;
                    if ([orientationsString isEqualToString:[self paramOrientationsPortrait]]) {
                        allowed = allowed | (1 << UIInterfaceOrientationPortrait);
                    } else if ([orientationsString isEqualToString:[self paramOrientationsPortraitUpsideDown]]) {
                        allowed = allowed | (1 << UIInterfaceOrientationPortraitUpsideDown);
                    } else if ([orientationsString isEqualToString:[self paramOrientationsLandscapeLeft]]) {
                        allowed = allowed | (1 << UIInterfaceOrientationLandscapeLeft);
                    } else if ([orientationsString isEqualToString:[self paramOrientationsLandscapeRight]]) {
                        allowed = allowed | (1 << UIInterfaceOrientationLandscapeRight);
                    }
                }
            }
        } else {
            NSLog(@"SBS Plugin: failed to parse allowed orientations - wrong type");
        }
        picker.allowedInterfaceOrientations = allowed;
    }
    
    NSObject *searchBar = [options objectForKey:[self paramSearchBar]];
    if (searchBar) {
        if ([searchBar isKindOfClass:[NSNumber class]]) {
            [picker showSearchBar:[((NSNumber *)searchBar) boolValue]];
            picker.searchDelegate = searchDelegate;
        } else {
            NSLog(@"SBS Plugin: failed to parse search bar - wrong type");
        }
    }
    
    NSObject *searchBarActionCaption = [options objectForKey:[self paramSearchBarActionButtonCaption]];
    if (searchBarActionCaption) {
        if ([searchBarActionCaption isKindOfClass:[NSString class]]) {
            picker.manualSearchBar.goButtonCaption = (NSString *) searchBarActionCaption;
        } else {
            NSLog(@"SBS Plugin: failed to parse search bar action button caption - wrong type");
        }
    }
    
    NSObject *searchBarCancelCaption = [options objectForKey:[self paramSearchBarCancelButtonCaption]];
    if (searchBarCancelCaption) {
        if ([searchBarCancelCaption isKindOfClass:[NSString class]]) {
            picker.manualSearchBar.cancelButtonCaption = (NSString *) searchBarCancelCaption;
        } else {
            NSLog(@"SBS Plugin: failed to parse search bar cancel button caption - wrong type");
        }
    }
    
    NSObject *searchBarPlaceholder = [options objectForKey:[self paramSearchBarPlaceholderText]];
    if (searchBarPlaceholder) {
        if ([searchBarPlaceholder isKindOfClass:[NSString class]]) {
            picker.manualSearchBar.placeholder = (NSString *) searchBarPlaceholder;
        } else {
            NSLog(@"SBS Plugin: failed to parse search bar placeholder text - wrong type");
        }
    }
    
    NSObject *minLength = [options objectForKey:[self paramMinSearchBarBarcodeLength]];
    if (minLength) {
        if ([minLength isKindOfClass:[NSNumber class]]) {
            picker.manualSearchBar.minTextLengthForSearch = [((NSNumber *) minLength) integerValue];
        } else {
            NSLog(@"SBS Plugin: failed to parse search bar min length - wrong type");
        }
    }
    
    NSObject *maxLength = [options objectForKey:[self paramMaxSearchBarBarcodeLength]];
    if (maxLength) {
        if ([maxLength isKindOfClass:[NSNumber class]]) {
            picker.manualSearchBar.maxTextLengthForSearch = [((NSNumber *) maxLength) integerValue];
        } else {
            NSLog(@"SBS Plugin: failed to parse search bar max length - wrong type");
        }
    }
}

+ (void)updateLayoutOfPicker:(ScanditSDKRotatingBarcodePicker *)picker
                 withOptions:(NSDictionary *)options {
    
    CGFloat animationDuration = 0;
    NSObject *animation = [options objectForKey:[self paramAnimationDuration]];
    if (animation) {
        if ([animation isKindOfClass:[NSNumber class]]) {
            animationDuration = [((NSNumber *)animation) floatValue];
        } else {
            NSLog(@"SBS Plugin: failed to parse animation duration - wrong type");
        }
    }
    
    NSObject *portraitMargins = [options objectForKey:[self paramPortraitMargins]];
    NSObject *landscapeMargins = [options objectForKey:[self paramLandscapeMargins]];
    if (portraitMargins || landscapeMargins) {
        picker.portraitMargins = CGRectMake(0, 0, 0, 0);
        picker.landscapeMargins = CGRectMake(0, 0, 0, 0);
    }
    
    if (portraitMargins) {
        if ([portraitMargins isKindOfClass:[NSString class]]) {
            picker.portraitMargins = [SBSLegacyUIParamParser rectFromParameter:portraitMargins];
        } else if ([portraitMargins isKindOfClass:[NSArray class]]) {
            NSArray *marginsArray = (NSArray *) portraitMargins;
            if ([marginsArray count] == 4 && [SBSUIParamParser array:marginsArray
                                           onlyContainObjectsOfClass:[NSNumber class]]) {
                picker.portraitMargins = CGRectMake([marginsArray[0] floatValue],
                                                    [marginsArray[1] floatValue],
                                                    [marginsArray[2] floatValue],
                                                    [marginsArray[3] floatValue]);
            }
        } else {
            NSLog(@"SBS Plugin: failed to parse portrait margins - wrong type");
        }
    }
    
    if (landscapeMargins) {
        if ([landscapeMargins isKindOfClass:[NSString class]]) {
            picker.landscapeMargins = [SBSLegacyUIParamParser rectFromParameter:portraitMargins];
        } else if ([landscapeMargins isKindOfClass:[NSArray class]]) {
            NSArray *marginsArray = (NSArray *) landscapeMargins;
            if ([marginsArray count] == 4 && [SBSUIParamParser array:marginsArray
                                           onlyContainObjectsOfClass:[NSNumber class]]) {
                picker.landscapeMargins = CGRectMake([marginsArray[0] floatValue],
                                                     [marginsArray[1] floatValue],
                                                     [marginsArray[2] floatValue],
                                                     [marginsArray[3] floatValue]);
            }
        } else {
            NSLog(@"SBS Plugin: failed to parse landscape margins - wrong type");
        }
    }
    
    [picker adjustSize:animationDuration];
}

+ (BOOL)isPausedSpecifiedInOptions:(NSDictionary *)options {
    NSObject *paused = [options objectForKey:[self paramPaused]];
    if (paused) {
        if ([paused isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)paused) boolValue];
        } else {
            NSLog(@"SBS Plugin: failed to parse paused - wrong type");
        }
    }
    return NO;
}

@end
