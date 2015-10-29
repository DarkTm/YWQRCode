//
//  QRCodeScan.m
//  QRCode
//
//  Created by lt on 5/12/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "QRCodeScan.h"
#import "QRCodeDecode.h"
#import "UIImage+QR.h"

@import AVFoundation;

@interface QRCodeScan ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice            *device;
@property (nonatomic, strong) AVCaptureDeviceInput       *input;
@property (nonatomic, strong) AVCaptureMetadataOutput    *output;
@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) AVCaptureVideoDataOutput   *dataOutput;

@property (nonatomic, assign) BOOL isLight;
@end

@implementation QRCodeScan

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setScanRect:(CGRect)scanRect {
    _scanRect = scanRect;
    _output.rectOfInterest = CGRectMake(scanRect.origin.y/APP.window.h, scanRect.origin.x/APP.window.w, scanRect.size.height/APP.window.h,scanRect.size.width/APP.window.w);
}

- (void)start {
    [self.session startRunning];
}

- (void)setup {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [ _output setRectOfInterest : CGRectMake (( 124 )/ self.bounds.size.width ,(( self.bounds.size.width - 220 )/ 2 )/ self.bounds.size.width , 220 / self.bounds.size.width , 220 / self.bounds.size.width )];
    
//    _output.rectOfInterest = self.scanRect;
    _dataOutput = [[AVCaptureVideoDataOutput alloc]init];

    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [_dataOutput setSampleBufferDelegate:self queue:queue];
    _dataOutput.videoSettings = [NSDictionary dictionaryWithObject:
                                 [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                            forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPreset640x480];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    if ([_session canAddOutput:self.dataOutput]) {
        [_session addOutput:self.dataOutput];
    }
    
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.bounds;
    [self.layer insertSublayer:self.preview atIndex:0];
    
    NSError *error;
    [_device lockForConfiguration:&error];
    if (!error) {
        if (_device.activeFormat.videoSupportedFrameRateRanges) {
            [_device setActiveVideoMaxFrameDuration:CMTimeMake(1, 15)];
        }
        else {
            
        }
    }
    else {
        
    }
    [_device unlockForConfiguration];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
// 自己保存最后一张图片 lastImage
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.imageBlock) {
            self.imageBlock(image);
        }
    });
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection; {
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if (self.rsltBlock) {
            self.rsltBlock(stringValue);
        }
    }
    [_session stopRunning];
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void) turnTorchOn: (bool) on {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                self.isLight = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                self.isLight = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)dealloc {
    if (self.isLight) {
        [self turnTorchOn:NO];
    }
}

@end
