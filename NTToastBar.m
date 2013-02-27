//
//  NTToastBar.m
//  WidgetLib
//
//  Created by demon on 2/26/13.
//  Copyright (c) 2013 demon. All rights reserved.
//

#import "NTToastBar.h"

@interface NTToastBar (Private)

#define CRT_TOAST_TAG   10086
#define NTTOAST_DISMISS_EVENT @"NTTOAST_DISMISS_EVENT"

@end

@implementation NTToastBar

- (void)dealloc
{
    [_str_words release];
    [super dealloc];
}

-(void)showFadeInAnimation:(CGFloat)duration
{
    [self setNeedsDisplay];
    [UIView animateWithDuration:duration
                     animations:^()
     {
         self.alpha =0.6;
     }completion:^(BOOL finished)
     {
         [self showFadeOutAnimation:duration];
     }];
}

-(void)showFadeOutAnimation:(CGFloat)duration
{
    [UIView animateWithDuration:duration
                     animations:^()
     {
         self.alpha = 0;
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

-(void)showRemoveAnimation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NTTOAST_DISMISS_EVENT
                                                        object:nil];
    [self showFadeOutAnimation:0.1];
}

-(id)initWithText:(NSString*)text
{
    _str_words = text;
    [_str_words retain];
    CGSize size = [self getWordsSize];
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           size.width+4,
                                           size.height+4)];
    if (self)
    {
        // Initialization code
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds= YES;
        self.alpha = 0;
    }
    return self;
}

-(CGSize)getWordsSize
{
    CGSize size =[_str_words sizeWithFont:DEFAULT_FONT
                        constrainedToSize:CGSizeMake(MAX_WIDTH,
                                                     300)];//最大支持300高度的toast
    return size;
}

+(void)showToast:(NSString*)text
      inDuration:(CGFloat)duration
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    NTToastBar * toastBar = [[NTToastBar alloc] initWithText:text];
    [window addSubview:toastBar];
    [toastBar release];
    toastBar.center = CGPointMake(window.frame.size.width/2,
                                  window.frame.size.height-toastBar.frame.size.height/2-20);
    [toastBar showFadeInAnimation:duration];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.7);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);

    CGSize size = [self getWordsSize];
    [_str_words drawInRect:CGRectMake(2,
                                      2,
                                      size.width, size.height)
                  withFont:DEFAULT_FONT];
}


@end

@implementation NTToastBarManager

static NTToastBarManager * _instance;

+(NTToastBarManager*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NTToastBarManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissEvent:)
                                                     name:NTTOAST_DISMISS_EVENT
                                                   object:nil];
    });
    return _instance;
}

-(void)showToast:(NSString*)text
      inDuration:(CGFloat)duration
{
    if(animating)
    {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        NTToastBar * toastView= (NTToastBar*)[window viewWithTag:CRT_TOAST_TAG];
        [toastView showRemoveAnimation];
    }
    animating = YES;
    [NTToastBar showToast:text
               inDuration:duration];
}

-(void)dismissEvent:(id)sender
{
    animating = NO;
}

+(void)showToast:(NSString*)text
      inDuration:(CGFloat)duration
{
    NTToastBarManager *manager = [NTToastBarManager shareInstance];

    [manager showToast:text
            inDuration:duration];
}

@end
