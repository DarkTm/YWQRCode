//
//  QRCodeScan.h
//  QRCode
//
//  Created by lt on 5/12/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRCodeScanImageBlock)(id rslt);
typedef void(^QRCodeScanRsltBlock)(id rslt);
@interface QRCodeScan : UIView

@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, copy) QRCodeScanImageBlock imageBlock;
@property (nonatomic, copy) QRCodeScanRsltBlock rsltBlock;

- (void)start;
- (void) turnTorchOn: (bool) on;
@end
