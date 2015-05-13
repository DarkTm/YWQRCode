//
//  QRCodeDecode.h
//  QRCode
//
//  Created by lt on 5/13/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_CLASS_AVAILABLE_IOS(8_0) @interface QRCodeDecode : NSObject

- (id)decodeFromImage:(UIImage *)sImg;

@end
