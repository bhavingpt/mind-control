//
//  OpenCVWrapper.mm
//  theia
//
//  Created by Bhavin Gupta on 6/26/17.
//  Copyright © 2017 bhavingpt. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/highgui/highgui.hpp>

#import <dlib/image_processing.h>
#import <dlib/image_processing/frontal_face_detector.h>
#import <dlib/image_processing/shape_predictor.h>
#import <dlib/array2d/array2d_generic_image.h>
#import <dlib/image_processing/generic_image.h>
#import <dlib/opencv/cv_image.h>

#import "OpenCVWrapper.h"

using namespace std;
using namespace cv;

/// Converts an NSImage to Mat.
static void NSImageToMat(NSImage *image, cv::Mat &mat) {

    @autoreleasepool {
        // Create a pixel buffer. This is the problem.
        NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        
        // get a couple of properties
        NSInteger width = [bitmapImageRep pixelsWide];
        NSInteger height = [bitmapImageRep pixelsHigh];
        
        CGImageRef imageRef = [bitmapImageRep CGImage];
        cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
        CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
        
        CGContextRelease(contextRef);
        CGColorSpaceRelease(colorSpace);
        
        // Draw all pixels to the buffer.
        cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
        cv::cvtColor(mat8uc4, mat8uc3, CV_RGBA2BGR);
        
        mat = mat8uc3;
    }
    
}

/// Converts a Mat to NSImage.
static NSImage *MatToNSImage(cv::Mat &mat) {
    
    @autoreleasepool {
        
        NSImage *image = [[NSImage alloc]init];

        // Create a pixel buffer.
        assert(mat.elemSize() == 1 || mat.elemSize() == 3);
        cv::Mat matrgb;
        if (mat.elemSize() == 1) {
            cv::cvtColor(mat, matrgb, CV_GRAY2RGB);
        } else if (mat.elemSize() == 3) {
            cv::cvtColor(mat, matrgb, CV_BGR2RGB);
        }
        
        // Change a image format.
        NSData *data = [NSData dataWithBytes:matrgb.data length:(matrgb.elemSize() * matrgb.total())];
        CGColorSpaceRef colorSpace;
        if (matrgb.elemSize() == 1) {
            colorSpace = CGColorSpaceCreateDeviceGray();
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB();
        }
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
        CGImageRef imageRef = CGImageCreate(matrgb.cols, matrgb.rows, 8, 8 * matrgb.elemSize(), matrgb.step.p[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
        NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
        [image addRepresentation:bitmapImageRep];
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpace);
        
        return image;
    }
    
    
}

static void draw_polyline(cv::Mat &img, const dlib::full_object_detection& d, const int start, const int end, bool isClosed = false)
{
    std::vector <cv::Point> points;
    for (int i = start; i <= end; ++i)
    {
        points.push_back(cv::Point(d.part(i).x(), d.part(i).y()));
    }
    cv::polylines(img, points, isClosed, cv::Scalar(255,0,0), 2, 16);
    
}

static float dist(dlib::point& p, dlib::point& q) {
    float x = p.x() - q.x();
    float y = p.y() - q.y();
    return cv::sqrt(x*x + y*y);
}

static void render_face (cv::Mat &img, const dlib::full_object_detection& d)
{
    DLIB_CASSERT
    (
     d.num_parts() == 68,
     "\n\t Invalid inputs were given to this function. "
     << "\n\t d.num_parts():  " << d.num_parts()
     );
    
    draw_polyline(img, d, 0, 16);           // Jaw line
    draw_polyline(img, d, 17, 21);          // Left eyebrow
    draw_polyline(img, d, 22, 26);          // Right eyebrow
    draw_polyline(img, d, 27, 30);          // Nose bridge
    draw_polyline(img, d, 30, 35, true);    // Lower nose
    draw_polyline(img, d, 36, 41, true);    // Left eye
    draw_polyline(img, d, 42, 47, true);    // Right Eye
    draw_polyline(img, d, 48, 59, true);    // Outer lip
    draw_polyline(img, d, 60, 67, true);    // Inner lip
    
}


@implementation OpenCVWrapper {
    int _counter;
    float _resize;
    std::vector<dlib::rectangle> _test;
    dlib::shape_predictor sp;
    dlib::frontal_face_detector detector;
    dlib::full_object_detection face;
    
    // MARK: right eye detections
    
    float right_eye_threshold;
    int right_eye_history;
    bool _right_eye_blinked;
    
    float chin_location;
    int chins;
    int _currentKey;
    int _displacement;
    int _detection;
    
    int up_thresh;
    int down_thresh;
    bool averaging;
    
    Mat input_color;
    Mat input_gray;
    Mat input;
    
}

- (id) init {
    self = [super init];
    try {
        NSString *modelFileName = [[NSBundle mainBundle] pathForResource:@"shape_predictor_68_face_landmarks" ofType:@"dat"];
        std::string modelFileNameCString = [modelFileName UTF8String];
        
        dlib::deserialize(modelFileNameCString) >> self->sp;
    } catch (...) {
        std::cout << "nope";
    }
    
    self->detector = dlib::get_frontal_face_detector();
    self->_resize = 4.0;
    
    self->right_eye_threshold = 0.25;
    self->right_eye_history = 0;
    
    self->chins = 0;
    self->_currentKey = 0;
    self->_displacement = 0;
    self->_detection = 0;
    
    self->up_thresh = 15;
    self->down_thresh = 10;
    self->averaging = true;
    
    //self->result = [[NSImage alloc]init];
    
    return self;
}

- (NSImage*) detect:(NSImage*) pic {
    
    _currentKey = 0;
    averaging = true;
    _detection = 0;
    
    NSImageToMat(pic, input_color);
    cvtColor(input_color, input_gray, CV_BGR2GRAY);
    cv::resize(input_gray, input, cv::Size(), 1.0/_resize, 1.0/_resize);
    
    dlib::cv_image<uchar> dlibimg(input);
    dlib::cv_image<uchar> dlibimage(input_gray);
    
    if (_counter % 15 == 0) {
        _test = detector(dlibimg);
        _detection = -1;

        if (_test.size() == 0) {
            _counter = -1;
            self->chins = 0;
            self->averaging = true;
            std::cout << "lost tracking. chin location unknown" << endl;
        }
    } else if (_counter % 15 == 14) {
        _detection = 1; // we are about to detect. May be a problem w autoscroll up -> autoscroll down
    }
    
    _counter += 1;
    
    for (int j = 0; j < _test.size(); ++j) {
        dlib::rectangle r(
                          (long)(_test[j].left() * _resize),
                          (long)(_test[j].top() * _resize),
                          (long)(_test[j].right() * _resize),
                          (long)(_test[j].bottom() * _resize)
                          );
        
        face = sp(dlibimage, r);
        
        render_face(input_gray, face);
    }
    
    if (_counter != 0) {
        // check the chin location
        
        long curr_location = face.part(8).y();
        
        if (chins > 15 && curr_location < (chin_location - up_thresh)) {
            // we need to move up
            _currentKey = 2;
            averaging = false;
            
            if (chin_location - curr_location < up_thresh * 1.5) {
                _displacement = 1;
            } else if (chin_location - curr_location < up_thresh * 2) {
                _displacement = 2;
            } else if (chin_location - curr_location < up_thresh * 2.5) {
                _displacement = 3;
            } else {
                _displacement = 5;
            }
            
            //std::cout << "detected above. we're at: " << curr_location << " average: " << chin_location << endl;

        } else if (chins > 15 && curr_location > (chin_location + down_thresh)) {
            // we need to move down
            _currentKey = 1;
            averaging = false;
            //std::cout << "detected below. we're at: " << curr_location << " average: " << chin_location << endl;
            
            if (curr_location - chin_location < down_thresh * 1.5) {
                _displacement = 1;
            } else  if (curr_location - chin_location < down_thresh * 2) {
                _displacement = 2;
            } else  if (curr_location - chin_location < down_thresh * 2.5) {
                _displacement = 3;
            } else {
                _displacement = 5;
            }
        } else {
            _detection = -1;
        }
        
        if (averaging) {
            chins += 1;
            if (chins == 1) {
                chin_location = curr_location;
                //std::cout << "located chin at: " << curr_location << endl;
            } else {
                chin_location = (chin_location * (chins-1) + curr_location) / chins;
            }
        }
    }
    
    
    /*if (_counter != 0) {
     // check the threshold on the right eye
     
     if (right_eye_history == 0) {
     _right_eye_blinked = false;
     }
     
     float a = dist(face.part(37), face.part(41));
     float b = dist(face.part(38), face.part(40));
     float c = dist(face.part(36), face.part(39));
     
     float received_value = (a + b) / (2 * c);
     std::cout << received_value << endl;
     
     if (received_value < right_eye_threshold) {
     right_eye_history += 1;
     } else {
     right_eye_history = 0;
     }
     
     if (right_eye_history == 3) {
     right_eye_history = 0;
     _right_eye_blinked = true;
     }
     }*/
    
    @autoreleasepool {
        NSImage *result = MatToNSImage(input_gray);
        return result;
    }
    
}

@end
