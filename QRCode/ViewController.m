//
//  ViewController.m
//  QRCode
//
//  Created by lt on 5/12/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+QR.h"
#import "QRCodeScan.h"
#import "QRCodeDecode.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivQRCode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *src = [UIImage qrImageFromString:@"https://www.baidu.com" wSize:CGSizeMake(CGRectGetWidth(self.ivQRCode.frame), CGRectGetHeight(self.ivQRCode.frame)) wColor:[UIColor colorWithRed:0.4 green:0.5 blue:0.6 alpha:1.0]];
    self.ivQRCode.image = src;
    
    
//    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(on_change) userInfo:nil repeats:YES];
    
    
//    QRCodeScan *scan = [[QRCodeScan alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
//    [scan setCompleteBlock:^(id rslt) {
//        NSLog(@"%@",rslt);
//        self.ivQRCode.image = rslt;
//    }];
//    [self.view addSubview:scan];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [scan start];
//    });
    
    QRCodeDecode *decode = [[QRCodeDecode alloc] init];
    NSLog(@"%@",[decode decodeFromImage:src]) ;
}

- (void)on_change {
    NSTimeInterval be = CACurrentMediaTime();
    float r = rand() % 255;
    float g = rand() % 255;
    float b = rand() % 255;
    UIImage *src = [UIImage qrImageFromString:@"https://www.baidu.com" wSize:CGSizeMake(CGRectGetWidth(self.ivQRCode.frame), CGRectGetHeight(self.ivQRCode.frame)) wColor:[UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0]];
    self.ivQRCode.image = src;
    NSLog(@"durationTime:%f",CACurrentMediaTime() - be);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
