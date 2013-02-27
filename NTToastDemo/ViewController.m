//
//  ViewController.m
//  NTToastDemo
//
//  Created by demon on 2/27/13.
//  Copyright (c) 2013 NicoFun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeToast:(id)sender
{
    NSString * words =@"hello,world你好世界";
    
    int repeatCount = arc4random()%3;
    while (repeatCount>0)
    {
        words = [words stringByAppendingString:words];
        repeatCount--;
    }

    [NTToastBarManager showToast:words
                      inDuration:1.0];
}
@end
