//
//  OpenCVWrapper.h
//  theia
//
//  Created by Bhavin Gupta on 6/26/17.
//  Copyright © 2017 bhavingpt. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface OpenCVWrapper : NSObject

- (NSImage *)process:(NSImage*)inputImage;

@end
