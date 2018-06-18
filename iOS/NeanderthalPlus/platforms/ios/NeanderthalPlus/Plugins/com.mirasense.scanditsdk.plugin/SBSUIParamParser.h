//
//  SBSUIParamParser.h
//  Hello World
//
//  Created by Moritz Hartmeier on 02/12/15.
//
//

#import <Foundation/Foundation.h>

#import <ScanditBarcodeScanner/ScanditBarcodeScanner.h>


/**
 * UI parameter parser for the new API in 4.11 and above. The difference to the legacy parameter
 * parser is that it moves away from strings as much as possible providing a cleaner api.
 */
@interface SBSUIParamParser : NSObject

+ (NSString *)paramBeep;
+ (NSString *)paramVibrate;
+ (NSString *)paramTorch;
+ (NSString *)paramTorchButtonMarginsAndSize;
+ (NSString *)paramCameraSwitchVisibility;
+ (NSString *)paramCameraSwitchButtonMarginsAndSize;
+ (NSString *)paramToolBarButtonCaption;

+ (NSString *)paramViewfinderColor;
+ (NSString *)paramViewfinderDecodedColor;
+ (NSString *)paramZoom;

+ (NSString *)paramGuiStyle;

+ (void)updatePickerUI:(SBSBarcodePicker *)picker fromOptions:(NSDictionary *)options;

+ (BOOL)array:(NSArray *)array onlyContainObjectsOfClass:(Class)aClass;

@end
