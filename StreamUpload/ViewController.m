//
//  ViewController.m
//  StreamUpload
//
//  Created by Haripal on 12/8/15.
//  Copyright © 2015 Haripal Wagh. All rights reserved.
//

#import "ViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AttachmentsProgressBar.h"
#import "File.h"

#import "AFHTTPRequestOperation.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
     AttachmentsProgressBar *Uploader;
    
    File *file;
}
@end

@implementation ViewController

@synthesize imgView, btnUploadImage;

# pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    file = [[File alloc] init];
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"BrowseGallery.png"];
    imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAttachmentTapped:)];
    imageTapRecognizer.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:imageTapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Privated Methods

- (void)uploadImage
{
    Uploader = [AttachmentsProgressBar instance];
    
    [Uploader showUploaderInView:self.view WithTotalUpload:1 AndStatus:@"Uploading..."];
    
    // Setting images to uploader
    [Uploader setImage:[UIImage imageWithData:file.Data] AtIndex:1];
    
    [self uploadAttachment];
}

- (void)uploadAttachment
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.50.11:8990/UploadFileService.svc/UploadFile"]]];
    
    [request setHTTPMethod:@"POST"];
    
    /*
     
     http://192.168.50.11/WCFUploadService/UploadFileService.svc/UploadFile
     
     [request setValue:[NSString stringWithFormat:@"application/PNG"]    forHTTPHeaderField:@"ContentType"];
     [request setValue:[NSString stringWithFormat:@".png"]               forHTTPHeaderField:@"FileExtension"];
     
     NSLog(@"Header Fileds %@", [request allHTTPHeaderFields]);
     */
    
    NSInputStream *inputStream = [[NSInputStream alloc] initWithData:file.Data];
    [request setHTTPBodyStream:inputStream];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    float totalStreamSize = (float)file.Data.length;
    
    NSLog(@"totalStreamSize %@",[NSByteCountFormatter stringFromByteCount:file.Data.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %0.0f bytes", totalBytesWritten, totalStreamSize);
        
        double percentDone = (double)totalBytesWritten / (double)totalStreamSize;
        //Upload Progress bar here
        NSLog(@"progress updated(percentDone) : %0.2f%%", percentDone * 100);
        
        [Uploader setUploadProgress:percentDone
                           WithSize:[NSString stringWithFormat:@"%@/%@",
                                     [NSByteCountFormatter stringFromByteCount:totalBytesWritten countStyle:NSByteCountFormatterCountStyleFile],
                                     [NSByteCountFormatter stringFromByteCount:totalStreamSize countStyle:NSByteCountFormatterCountStyleFile]]
                            AtIndex:1];
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         
         NSLog(@"Result String %@", resultStr);
         
         if([resultStr isEqualToString:@"true"])
         {
             NSLog(@"SUCCESS");
             [Uploader setUploadAsDoneAtIndex:1];
             [Uploader dismiss];
             
             NSLog(@"Upload done..");
         }
         else
         {
             NSLog(@"NOT SUCCESS");
             [Uploader setUploadAsFailedAtIndex:1];
             [Uploader dismiss];
             
             NSLog(@"Upload failed..");
             
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"FAILURE");
         
         [Uploader setUploadAsFailedAtIndex:1];
         [Uploader dismiss];
     }
     ];
    
    [operation start];
}

# pragma mark - Photo Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //IMAGE
    
    UIImage *selectedImageFromPhotoPicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    file.Data = UIImageJPEGRepresentation(selectedImageFromPhotoPicker, 0.5);
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = selectedImageFromPhotoPicker;
    
}

# pragma mark - Actions

- (IBAction)btnUploadImageTapped:(id)sender
{
    if (file.Data != nil)
    {
        [self uploadImage];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Can't upload!"
                                                                        message:@"Please select image to upload"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)addAttachmentTapped:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
