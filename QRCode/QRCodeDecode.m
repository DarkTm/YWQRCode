 //
//  QRCodeDecode.m
//  QRCode
//
//  Created by lt on 5/13/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "QRCodeDecode.h"
@import AVFoundation;
@interface QRCodeDecode ()

@property (nonatomic, strong) CIContext *ciContext;
@property (nonatomic, strong) CIDetector *qrDetector;

@end

@implementation QRCodeDecode

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.ciContext = [CIContext contextWithOptions:nil];
    self.qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:self.ciContext options:nil];
}

- (id)decodeFromImage:(UIImage *)sImg {
    if (!sImg) {
        return @"error";
    }
    CIImage *image = [CIImage imageWithCGImage:sImg.CGImage];
    NSArray *reatures = [self.qrDetector featuresInImage:image];
    if ( reatures.count ) {
        CIQRCodeFeature *f = [reatures firstObject];
        NSLog(@"%s,rslt:%@",__func__,f.messageString);
        return f.messageString;
    }
    return nil;
}

@end
