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

#import "SBSLocalScanSession.h"


@interface SBSLocalScanSession ()
@property (nonnull, nonatomic, copy) NSArray *localNewlyRecognizedCodes;
@property (nonnull, nonatomic, copy) NSArray *localNewlyLocalizedCodes;
@property (nonnull, nonatomic, copy) NSArray *localAllRecognizedCodes;
@property (nonnull, nonatomic, strong) SBSBarcodePicker *picker;
@end


@implementation SBSLocalScanSession

- (instancetype)initWithScanSession:(SBSScanSession *)session andPicker:(SBSBarcodePicker *)picker {
    self = [super init];
    if (self) {
        self.localNewlyRecognizedCodes = session.newlyRecognizedCodes;
        self.localNewlyLocalizedCodes = session.newlyLocalizedCodes;
        self.localAllRecognizedCodes = session.allRecognizedCodes;
    }
    return self;
}

- (NSArray *)newlyRecognizedCodes {
    return self.localNewlyRecognizedCodes;
}

- (NSArray*)allRecognizedCodes {
    return self.localAllRecognizedCodes;
}

- (NSArray*)newlyLocalizedCodes {
    return self.localNewlyLocalizedCodes;
}

- (void)pauseScanning {
    [self.picker pauseScanning];
}

- (void)stopScanning {
    [self.picker stopScanning];
}

@end
