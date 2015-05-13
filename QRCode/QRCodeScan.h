//
//  QRCodeScan.h
//  QRCode
//
//  Created by lt on 5/12/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRCodeScanBlock)(id rslt);

@interface QRCodeScan : UIView

- (void)start;

- (void)setCompleteBlock:(QRCodeScanBlock )block;

@end
