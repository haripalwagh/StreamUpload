//
//  ViewController.h
//  StreamUpload
//
//  Created by Haripal on 12/8/15.
//  Copyright © 2015 Haripal Wagh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnUploadImage;

- (IBAction)btnUploadImageTapped:(id)sender;
@end

