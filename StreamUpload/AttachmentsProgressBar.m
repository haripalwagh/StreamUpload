//
//  AttachmentsProgressBar.m
//  StreamUpload
//
//  Created by Haripal on 12/8/15.
//  Copyright © 2015 Haripal Wagh. All rights reserved.
//

#import "AttachmentsProgressBar.h"

#define DEVICE_SIZE [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size

@implementation AttachmentsProgressBar

@synthesize background, progressParentView, label, semiParentView;

static AttachmentsProgressBar *uploader = nil;

+ (AttachmentsProgressBar *)instance
{
    @synchronized(self)
    {
        if (uploader == nil)
        {
            uploader = [AttachmentsProgressBar new];
        }
    }
    return uploader;
}

- (void)dismiss
{
    [semiParentView removeFromSuperview]; semiParentView = nil;
    
    [progressParentView removeFromSuperview]; progressParentView = nil;     
    
}

- (void)showUploaderInView:(UIView *)parentView WithTotalUpload:(int)totalUploads AndStatus:(NSString *)status
{
    [self makeUploaderInView:parentView WithTotalUpload:totalUploads AndStatus:status];
}

- (void)makeUploaderInView:(UIView *)parentView WithTotalUpload:(int)totalUploads AndStatus:(NSString *)status
{
    background = parentView.window;
    
    semiParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    semiParentView.center = background.center;
    semiParentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];;
    
    int heightOfProgressParentView = 50 * (totalUploads + 1);
    
    progressParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, heightOfProgressParentView)];
    progressParentView.center = background.center;
    progressParentView.backgroundColor = [UIColor blackColor];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.center = CGPointMake(25, 25);
    activityIndicatorView.color = [UIColor whiteColor];
    activityIndicatorView.hidesWhenStopped = YES;
    [progressParentView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    label.text = status;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [progressParentView addSubview:label];
    
    [semiParentView addSubview:progressParentView];
    
    [background addSubview:semiParentView];
    
    for (int tag = 100; tag <= totalUploads * 100; tag = tag + 100)
    {
        [self addProgressViewWithTag:tag AndButton:NO];
    }
    
    [background bringSubviewToFront:progressParentView];
}

- (void)addProgressViewWithTag:(int)tag AndButton:(BOOL)showButton
{
    UIView *progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + (50 * tag / 100), 320, 49)];
    progressBackView.backgroundColor = [UIColor whiteColor];
    progressBackView.tag = tag + 1;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    imageView.tag = tag + 2;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [progressBackView addSubview:imageView];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.tag = tag;
    
    if (showButton)
    {
        [progressView setFrame:CGRectMake(56.0, 32.0, 225.0, 11.0)];
    }
    else
    {
        [progressView setFrame:CGRectMake(56.0, 32.0, 250.0, 11.0)];
    }
    
    [progressView setProgress:0.0 animated:NO];
    [progressView setProgressTintColor:[UIColor colorWithRed:0.431 green:0.753 blue:0.949 alpha:1.0]];
    [progressView setTrackTintColor:[UIColor darkGrayColor]];
    
    [progressBackView addSubview:progressView];
    
    if (showButton)
    {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.tag = tag + 3;
        cancelButton.frame = CGRectMake(278.0, 5.0, 44.0, 44.0);
        [cancelButton setImage:[UIImage imageNamed:@"WDUploadProgressView.bundle/upload_cancel_button.png"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelUpload:) forControlEvents:UIControlEventTouchUpInside];
        
        [progressBackView addSubview:cancelButton];
    }
    
    UILabel *progressSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(56.0, 10, 125.0, 20.0)];
    progressSizeLabel.textAlignment = NSTextAlignmentLeft;
    progressSizeLabel.textColor = [UIColor blackColor];
    progressSizeLabel.text = @"";
    progressSizeLabel.font = [UIFont systemFontOfSize:14];
    progressSizeLabel.tag = tag + 4;
    [progressBackView addSubview:progressSizeLabel];
    
    UILabel *progressPercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressSizeLabel.frame.origin.x + progressSizeLabel.frame.size.width + 2, 10, 120, 20)];
    progressPercentageLabel.textAlignment = NSTextAlignmentRight;
    progressPercentageLabel.textColor = [UIColor blackColor];
    progressPercentageLabel.text = @"";
    progressPercentageLabel.font = [UIFont systemFontOfSize:14];
    progressPercentageLabel.tag = tag + 5;
    [progressBackView addSubview:progressPercentageLabel];
    
    [progressParentView addSubview:progressBackView];
}

- (void)setImage:(UIImage *)image AtIndex:(int)index
{
    UIView *progressBackView = (UIView *)[progressParentView viewWithTag:(index * 100) + 1];
    
    UIImageView *imgView = (UIImageView *)[progressBackView viewWithTag:(index * 100) + 2];
    imgView.image = image;
}

- (void)setUploadProgress:(float)progress WithSize:(NSString *)strSizeProgress AtIndex:(int)index
{
    UIView *progressBackView = (UIView *)[progressParentView viewWithTag:(index * 100) + 1];
    
    UILabel *progressSizeLabel = (UILabel *)[progressBackView viewWithTag:(index * 100) + 4];
    progressSizeLabel.text = strSizeProgress;
    
    UILabel *progressPercentageLabel = (UILabel *)[progressBackView viewWithTag:(index * 100) + 5];
    progressPercentageLabel.text = [NSString stringWithFormat:@"%0.0f%%", progress * 100];
    
    UIProgressView *progressView = (UIProgressView *)[progressBackView viewWithTag:(index * 100)];
    progressView.progress = progress;
}

- (void)setUploadAsDoneAtIndex:(int)index
{
    UIView *progressBackView = (UIView *)[progressParentView viewWithTag:(index * 100) + 1];
    
    UILabel *progressPercentageLabel = (UILabel *)[progressBackView viewWithTag:(index * 100) + 5];
    progressPercentageLabel.text = @"Uploaded";
}

- (void)setUploadAsFailedAtIndex:(int)index
{
    UIView *progressBackView = (UIView *)[progressParentView viewWithTag:(index * 100) + 1];
    
    UILabel *progressPercentageLabel = (UILabel *)[progressBackView viewWithTag:(index * 100) + 5];
    progressPercentageLabel.text = @"Failed";
    progressPercentageLabel.textColor = [UIColor redColor];
    
    UIProgressView *progressView = (UIProgressView *)[progressBackView viewWithTag:(index * 100)];
    [progressView setProgressTintColor:[UIColor redColor]];
}

- (IBAction)cancelUpload:(id)sender
{
    UIView *progressBackView = (UIView *)[progressParentView viewWithTag:[sender tag] - 2];
    progressBackView.backgroundColor = [UIColor lightGrayColor];
    
    UIProgressView *progressView = (UIProgressView *)[progressBackView viewWithTag:[sender tag] - 3];
    progressView.progress = 0.0;
}

@end
