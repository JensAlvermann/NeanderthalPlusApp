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

#import "ScanditSDK.h"
#import "ScanditSDKRotatingBarcodePicker.h"
#import "ScanditSDKSearchBar.h"
#import "SBSLegacySettingsParamParser.h"
#import "SBSLegacyUIParamParser.h"
#import "SBSUIParamParser.h"
#import "SBSPhonegapParamParser.h"
#import "SBSLocalScanSession.h"

#import <ScanditBarcodeScanner/ScanditBarcodeScanner.h>


@interface SBSLicense ()
+ (void)setFrameworkIdentifier:(NSString *)frameworkIdentifier;
@end

@interface ScanditSDK () <SBSScanDelegate, SBSOverlayControllerDidCancelDelegate, ScanditSDKSearchBarDelegate>
@property (nonatomic, copy) NSString *callbackId;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic, assign) BOOL continuousMode;
@property (nonatomic, assign) BOOL modallyPresented;
@property (nonatomic, assign) BOOL startAnimationDone;
@property (nonatomic, strong) SBSLocalScanSession *bufferedResult;
@property (nonatomic, strong) ScanditSDKRotatingBarcodePicker *scanditBarcodePicker;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) BOOL legacyMode;
@end


@implementation ScanditSDK
@synthesize hasPendingOperation;

- (dispatch_queue_t)queue {
    if (!_queue) {
        self.queue = dispatch_queue_create("scandit_barcode_scanner_plugin", NULL);
        dispatch_queue_t high = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL);
        dispatch_set_target_queue(_queue, high);
    }
    return _queue;
}

- (void)initLicense:(CDVInvokedUrlCommand *)command {
    NSUInteger argc = [command.arguments count];
    if (argc < 1) {
        NSLog(@"The initLicense call received too few arguments and has to return without starting.");
        return;
    }
    NSString *appKey = [command.arguments objectAtIndex:0];
    [SBSLicense setFrameworkIdentifier:@"phonegap"];
    [SBSLicense setAppKey:appKey];
}

- (void)show:(CDVInvokedUrlCommand *)command {
    if (self.hasPendingOperation) {
        return;
    }
    self.hasPendingOperation = YES;
    
    NSUInteger argc = [command.arguments count];
    if (argc < 2) {
        NSLog(@"The show call received too few arguments and has to return without starting.");
        return;
    }
    self.callbackId = command.callbackId;
    
    NSDictionary *settings = [command.arguments objectAtIndex:0];
    NSDictionary *options = [self lowerCaseOptionsFromOptions:[command.arguments objectAtIndex:1]];
    NSDictionary *overlayOptions = [self lowerCaseOptionsFromOptions:[command.arguments objectAtIndex:2]];
    
    self.legacyMode = NO;
    [self showPickerWithSettings:settings options:options overlayOptions:overlayOptions];
}

- (void)scan:(CDVInvokedUrlCommand *)command {
    if (self.hasPendingOperation) {
        return;
    }
    self.hasPendingOperation = YES;
    
    NSUInteger argc = [command.arguments count];
    if (argc < 2) {
        NSLog(@"The scan call received too few arguments and has to return without starting.");
        return;
    }
    self.callbackId = command.callbackId;
    
    NSString *appKey = [command.arguments objectAtIndex:0];
    [SBSLicense setFrameworkIdentifier:@"phonegap"];
    [SBSLicense setAppKey:appKey];
    
    NSDictionary *options = [self lowerCaseOptionsFromOptions:[command.arguments objectAtIndex:1]];
    
    self.legacyMode = YES;
    [self showPickerWithSettings:nil options:options overlayOptions:nil];
}

- (void)showPickerWithSettings:(NSDictionary *)settings
                       options:(NSDictionary *)options
                overlayOptions:(NSDictionary *)overlayOptions {
    dispatch_async(self.queue, ^{
        // Continuous mode support.
        self.continuousMode = NO;
        NSObject *continuousMode = [options objectForKey:[SBSPhonegapParamParser paramContinuousMode]];
        if (continuousMode && [continuousMode isKindOfClass:[NSNumber class]]) {
            self.continuousMode = [((NSNumber *)continuousMode) boolValue];
        }
        
        dispatch_main_sync_safe(^{
            // Create the picker.
            SBSScanSettings *scanSettings;
            if (!settings) {
                scanSettings = [SBSLegacySettingsParamParser settingsForOptions:options];
            } else {
                NSError *error;
                scanSettings = [SBSScanSettings settingsWithDictionary:settings error:&error];
                if (error) {
                    NSLog(@"Error when creating settings: %@", [error localizedDescription]);
                }
            }
            self.scanditBarcodePicker = [[ScanditSDKRotatingBarcodePicker alloc]
                                         initWithSettings:scanSettings];
            
            // Show the toolbar if we start modally. Need to do this here already such that other
            // toolbar options can be set afterwards.
            if (![options objectForKey:[SBSPhonegapParamParser paramPortraitMargins]]
                    && ![options objectForKey:[SBSPhonegapParamParser paramLandscapeMargins]]) {
                [self.scanditBarcodePicker.overlayController showToolBar:YES];
            }
            
            // Set all the UI options.
            [SBSPhonegapParamParser updatePicker:self.scanditBarcodePicker
                                     fromOptions:options
                              withSearchDelegate:self];
            
            if (self.legacyMode) {
                [SBSLegacyUIParamParser updatePickerUI:self.scanditBarcodePicker fromOptions:options];
            } else {
                [SBSUIParamParser updatePickerUI:self.scanditBarcodePicker fromOptions:overlayOptions];
                [SBSPhonegapParamParser updatePicker:self.scanditBarcodePicker
                                         fromOptions:overlayOptions
                                  withSearchDelegate:self];
            }
            
            // Set this class as the delegate for the overlay controller. It will now receive events when
            // a barcode was successfully scanned, manually entered or the cancel button was pressed.
            self.scanditBarcodePicker.scanDelegate = self;
            self.scanditBarcodePicker.overlayController.cancelDelegate = self;
        
            if ([options objectForKey:[SBSPhonegapParamParser paramPortraitMargins]]
                || [options objectForKey:[SBSPhonegapParamParser paramLandscapeMargins]]) {
                self.modallyPresented = NO;
                [self.viewController addChildViewController:self.scanditBarcodePicker];
                [self.viewController.view addSubview:self.scanditBarcodePicker.view];
                [self.scanditBarcodePicker didMoveToParentViewController:self.viewController];
                
                [SBSPhonegapParamParser updateLayoutOfPicker:self.scanditBarcodePicker withOptions:options];
                
            } else {
                self.modallyPresented = YES;
                
                self.startAnimationDone = NO;
                self.bufferedResult = nil;
                
                // Present the barcode picker modally and start scanning.
                [self.viewController presentViewController:self.scanditBarcodePicker animated:YES completion:^{
                    self.startAnimationDone = YES;
                    if (self.bufferedResult != nil) {
                        [self performSelector:@selector(returnBuffer) withObject:nil afterDelay:0.01];
                    }
                }];
            }
            
            // Only already start in legacy mode.
            if (self.legacyMode) {
                if ([SBSPhonegapParamParser isPausedSpecifiedInOptions:options]) {
                    [self.scanditBarcodePicker performSelector:@selector(startScanningInPausedState:)
                                                    withObject:[NSNumber numberWithBool:YES] afterDelay:0.1];
                } else {
                    [self.scanditBarcodePicker performSelector:@selector(startScanning) withObject:nil afterDelay:0.1];
                }
            }
        });
    });
}

- (void)returnBuffer {
    if (self.bufferedResult != nil) {
        [self scannedSession:self.bufferedResult];
        
        self.bufferedResult = nil;
    }
}

- (void)applySettings:(CDVInvokedUrlCommand *)command {
    NSUInteger argc = [command.arguments count];
    if (argc < 1) {
        NSLog(@"The applySettings call received too few arguments and has to return without starting.");
        return;
    }
    
    dispatch_async(self.queue, ^{
        if (self.scanditBarcodePicker) {
            NSDictionary *settings = [command.arguments objectAtIndex:0];
            NSError *error;
            SBSScanSettings *scanSettings = [SBSScanSettings settingsWithDictionary:settings error:&error];
            if (error) {
                NSLog(@"Error when creating settings: %@", [error localizedDescription]);
            } else {
                [self.scanditBarcodePicker applyScanSettings:scanSettings completionHandler:nil];
            }
        }
    });
}

- (void)cancel:(CDVInvokedUrlCommand *)command {
    dispatch_async(self.queue, ^{
        if (self.scanditBarcodePicker) {
            [self overlayController:self.scanditBarcodePicker.overlayController didCancelWithStatus:nil];
        }
    });
}

- (void)pause:(CDVInvokedUrlCommand *)command {
    dispatch_async(self.queue, ^{
        [self.scanditBarcodePicker pauseScanning];
    });
}

- (void)resume:(CDVInvokedUrlCommand *)command {
    dispatch_async(self.queue, ^{
        [self.scanditBarcodePicker resumeScanning];
    });
}

- (void)start:(CDVInvokedUrlCommand *)command {
    dispatch_async(self.queue, ^{
        NSUInteger argc = [command.arguments count];
        NSDictionary *options = [NSDictionary dictionary];
        if (argc >= 1) {
            options = [self lowerCaseOptionsFromOptions:[command.arguments objectAtIndex:0]];
        }
        [self.scanditBarcodePicker startScanningInPausedState:[SBSPhonegapParamParser
                                                               isPausedSpecifiedInOptions:options]];
    });
}

- (void)stop:(CDVInvokedUrlCommand *)command {
    NSLog(@"stopScanning");
    dispatch_async(self.queue, ^{
        NSLog(@"stopScanning execute");
        [self.scanditBarcodePicker stopScanning];
    });
}

- (void)resize:(CDVInvokedUrlCommand *)command {
    if (self.scanditBarcodePicker && !self.modallyPresented) {
        NSUInteger argc = [command.arguments count];
        if (argc < 1) {
            NSLog(@"The resize call received too few arguments and has to return without starting.");
            return;
        }
        dispatch_async(self.queue, ^{
            dispatch_main_sync_safe(^{
                NSDictionary *options = [self lowerCaseOptionsFromOptions:[command.arguments objectAtIndex:0]];
                if (self.legacyMode) {
                    [SBSLegacyUIParamParser updatePickerUI:self.scanditBarcodePicker fromOptions:options];
                }
                
                [SBSPhonegapParamParser updateLayoutOfPicker:self.scanditBarcodePicker withOptions:options];
            });
        });
    }
}

- (void)torch:(CDVInvokedUrlCommand *)command {
    NSUInteger argc = [command.arguments count];
    if (argc < 1) {
        NSLog(@"The torch call received too few arguments and has to return without starting.");
        return;
    }
    dispatch_async(self.queue, ^{
        NSNumber *enabled = [command.arguments objectAtIndex:0];
        [self.scanditBarcodePicker switchTorchOn:[enabled boolValue]];
    });
}


#pragma mark - Utilities

- (NSDictionary *)lowerCaseOptionsFromOptions:(NSDictionary *)options {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *key in options) {
        [result setObject:[options objectForKey:key] forKey:[key lowercaseString]];
    }
    return result;
}


#pragma mark - SBSScanDelegate methods

- (void)barcodePicker:(SBSBarcodePicker *)picker didScan:(SBSScanSession *)session {
    if (self.modallyPresented) {
        if (!self.startAnimationDone) {
            // If the initial animation hasn't finished yet we buffer the result and return it as soon
            // as the animation finishes.
            self.bufferedResult = [[SBSLocalScanSession alloc]
                                   initWithScanSession:session andPicker:picker];
            return;
        } else {
            self.bufferedResult = nil;
        }
    }
    
    [self scannedSession:session];
}

- (void)scannedSession:(SBSScanSession *)session {
    CDVPluginResult *pluginResult;
    if (self.legacyMode) {
        SBSCode *newCode = [session.newlyRecognizedCodes objectAtIndex:0];
        NSArray *result = [[NSArray alloc] initWithObjects:[newCode data], [newCode symbologyString], nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                          messageAsArray:result];
        
    } else {
        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [self jsObjectsFromCodeArray:session.newlyRecognizedCodes], @"newlyRecognizedCodes",
                                [self jsObjectsFromCodeArray:session.newlyLocalizedCodes], @"newlyLocalizedCodes",
                                [self jsObjectsFromCodeArray:session.allRecognizedCodes], @"allRecognizedCodes", nil];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                     messageAsDictionary:result];
    }
    
    if (!self.continuousMode) {
        if (session) {
            [session stopScanning];
        } else {
            [self.scanditBarcodePicker stopScanning];
        }
        dispatch_main_sync_safe(^{
            if (self.modallyPresented) {
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.scanditBarcodePicker removeFromParentViewController];
                [self.scanditBarcodePicker.view removeFromSuperview];
                [self.scanditBarcodePicker didMoveToParentViewController:nil];
            }
            self.scanditBarcodePicker = nil;
            self.hasPendingOperation = NO;
        });
    } else {
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    }
	
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (NSArray *)jsObjectsFromCodeArray:(NSArray *)codes {
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    for (SBSCode *code in codes) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [code symbologyName], @"symbology",
                                     [NSNumber numberWithBool:[code isGs1DataCarrier]], @"gs1DataCarrier",
                                     [NSNumber numberWithBool:[code isRecognized]], @"recognized", nil];
        if ([code isRecognized]) {
            [dict setObject:[code data] forKey:@"data"];
        }
        [finalArray addObject:dict];
    }
    return finalArray;
}


#pragma mark - SBSOverlayControllerDidCancelDelegate

- (void)overlayController:(SBSOverlayController *)overlayController
      didCancelWithStatus:(NSDictionary *)status {
    [self.scanditBarcodePicker stopScanning];
    dispatch_main_sync_safe(^{
        if (self.modallyPresented) {
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.scanditBarcodePicker removeFromParentViewController];
            [self.scanditBarcodePicker.view removeFromSuperview];
            [self.scanditBarcodePicker didMoveToParentViewController:nil];
        }
    });
    self.scanditBarcodePicker = nil;
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:@"Canceled"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    self.hasPendingOperation = NO;
}


#pragma mark - ScanditSDKSearchBarDelegate

- (void)searchExecutedWithContent:(NSString *)content {
    CDVPluginResult *pluginResult;
    if (self.legacyMode) {
        NSArray *result = [[NSArray alloc] initWithObjects:content, "UNKNOWN", nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                          messageAsArray:result];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsString:content];
    }

    if (!self.continuousMode) {
        [self.scanditBarcodePicker stopScanning];
        if (self.modallyPresented) {
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.scanditBarcodePicker removeFromParentViewController];
            [self.scanditBarcodePicker.view removeFromSuperview];
            [self.scanditBarcodePicker didMoveToParentViewController:nil];
        }
        self.scanditBarcodePicker = nil;
        self.hasPendingOperation = NO;
    } else {
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.scanditBarcodePicker.overlayController resetUI];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
