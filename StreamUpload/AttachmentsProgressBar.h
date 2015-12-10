//
//  AttachmentsProgressBar.h
//  StreamUpload
//
//  Created by Haripal on 12/8/15.
//  Copyright © 2015 Haripal Wagh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
#define HUD_STATUS_COLOR		[UIColor whiteColor]

#define HUD_SPINNER_COLOR		[UIColor whiteColor]//[UIColor colorWithRed:185.0/255.0 green:220.0/255.0 blue:47.0/255.0 alpha:1.0]
#define HUD_BACKGROUND_COLOR	[UIColor blackColor]
#define HUD_WINDOW_COLOR		[UIColor clearColor]//[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0]

#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"progresshudSuccess.png"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"progresshudError.png"]

@interface AttachmentsProgressBar : UIView

+ (instancetype)instance;

- (void)dismiss;
- (void)showUploaderInView:(UIView *)parentView WithTotalUpload:(int)totalUploads AndStatus:(NSString *)status;
- (void)setImage:(UIImage *)image AtIndex:(int)index;
- (void)setUploadProgress:(float)progress WithSize:(NSString *)strSizeProgress AtIndex:(int)index; 
- (void)setUploadAsFailedAtIndex:(int)index;
- (void)setUploadAsDoneAtIndex:(int)index;

@property (nonatomic, retain) UIWindow *background;
@property (nonatomic, retain) UIView *semiParentView;
@property (nonatomic, retain) UIView *progressParentView;
@property (nonatomic, retain) UILabel *label;

@end
