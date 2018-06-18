//
//  SBSLegacySettingsParamParser.h
//  Hello World
//
//  Created by Moritz Hartmeier on 02/12/15.
//
//

#import <Foundation/Foundation.h>

#import <ScanditBarcodeScanner/ScanditBarcodeScanner.h>


/**
 * Settings parameter parser for the pre-4.11 api, replaced by creating the settings directly from
 * json.
 */
@interface SBSLegacySettingsParamParser : NSObject

+ (SBSScanSettings *)settingsForOptions:(NSDictionary *)options;

@end
