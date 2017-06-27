//
//  OpenCVWrapper.mm
//  theia
//
//  Created by Bhavin Gupta on 6/26/17.
//  Copyright © 2017 bhavingpt. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
using namespace std;
using namespace cv;

@implementation OpenCVWrapper
- (void) isThisWorking {
    cout << "Hey" << endl;
}

- (NSImage*) processImageWithOpenCV:(NSImage*) inputImage {
    return inputImage;
}
@end
