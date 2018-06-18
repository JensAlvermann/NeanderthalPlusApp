//
//  SBSLegacyUIParamParser.h
//  Hello World
//
//  Created by Moritz Hartmeier on 02/12/15.
//
//

#import <Foundation/Foundation.h>

#import <ScanditBarcodeScanner/ScanditBarcodeScanner.h>


/**
 * UI parameter parser for the pre-4.11 api. Replaced by a newer parser that moves away from using
 * strings.
 */
@interface SBSLegacyUIParamParser : NSObject

+ (void)updatePickerUI:(SBSBarcodePicker *)picker fromOptions:(NSDictionary *)options;

+ (CGRect)rectFromParameter:(NSObject *)parameter;

@end
