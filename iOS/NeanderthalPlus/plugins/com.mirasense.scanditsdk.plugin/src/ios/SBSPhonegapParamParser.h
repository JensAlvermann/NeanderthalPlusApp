//
//  SBSPhonegapParamParser.h
//  Hello World
//
//  Created by Moritz Hartmeier on 02/12/15.
//
//

#import <Foundation/Foundation.h>

#import "ScanditSDKRotatingBarcodePicker.h"


/**
 * Parameter parser for parameters that are specific to the phonegap implementation.
 */
@interface SBSPhonegapParamParser : NSObject

+ (NSString *)paramContinuousMode;
+ (NSString *)paramPortraitMargins;
+ (NSString *)paramLandscapeMargins;
+ (NSString *)paramAnimationDuration;

+ (NSString *)paramPaused;


+ (void)updatePicker:(ScanditSDKRotatingBarcodePicker *)picker
         fromOptions:(NSDictionary *)options
  withSearchDelegate:(id<ScanditSDKSearchBarDelegate>)searchDelegate;

+ (void)updateLayoutOfPicker:(ScanditSDKRotatingBarcodePicker *)picker
                 withOptions:(NSDictionary *)options;

+ (BOOL)isPausedSpecifiedInOptions:(NSDictionary *)options;

@end
