//
//  UIImage+QR.h
//  QRCode
//
//  Created by lt on 5/12/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QR)

+ (UIImage *)qrImageFromString:(NSString *)qrString wSize:(CGSize)size;

+ (UIImage *)qrImageFromString:(NSString *)qrString wSize:(CGSize)size wColor:(UIColor *)color;

+ (CIImage *)qrCIimageFromString:(NSString *)qrString ;

@end
