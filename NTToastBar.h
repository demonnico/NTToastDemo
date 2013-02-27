//
//  NTToastBar.h
//  WidgetLib
//
//  Created by demon on 2/26/13.
//  Copyright (c) 2013 demon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define MAX_WIDTH 200
#define DEFAULT_FONT [UIFont systemFontOfSize:11]
#define CRT_TOAST_TAG   10086
#define NTTOAST_DISMISS_EVENT @"NTTOAST_DISMISS_EVENT"

@interface NTToastBar : UIView
{
    NSString * _str_words;
}
+(void)showToast:(NSString*)text
      inDuration:(CGFloat)duration;
-(void)showRemoveAnimation;

@end

@interface NTToastBarManager : NSObject
{
    BOOL animating;
}
+(NTToastBarManager*)shareInstance;

/**
 *	@brief	呈现Toast视图
 *
 *	@param 	text 	toast文字
 *	@param 	duration 	动画时间
 */
+(void)showToast:(NSString*)text
      inDuration:(CGFloat)duration;


@end
