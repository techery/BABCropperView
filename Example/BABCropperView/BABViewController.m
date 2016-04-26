//
//  BABViewController.m
//  BABCropperView
//
//  Created by Bryn Bodayle on 04/17/2015.
//  Copyright (c) 2014 Bryn Bodayle. All rights reserved.
//

#import "BABViewController.h"
#import "BABCropperView.h"

@interface BABViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet BABCropperView *cropperView;
@property (weak, nonatomic) IBOutlet UIImageView *croppedImageView;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;

@end

@implementation BABViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.cropperView.cropSize = CGSizeMake(1024.0f, 720.0f);
    self.cropperView.cropsImageToCircle = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
	
    if(!self.cropperView.image) {
        
        [self showImagePicker];
    }
}

- (void)showImagePicker {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    [self.cropButton setTitle:@"Crop Image" forState:UIControlStateNormal];
}

#pragma mark - Button Targets

- (IBAction)cropButtonPressed:(id)sender {
    
    if(self.cropperView.hidden) {
        
        self.cropperView.hidden = NO;
        self.croppedImageView.hidden = YES;
        [self showImagePicker];
    }
    else {
        
        __weak typeof(self)weakSelf = self;
        
        [self.cropperView renderCroppedImage:^(UIImage *croppedImage, NSError *error){
            
            [weakSelf displayCroppedImage:croppedImage];
        }];
    }
}

- (void)displayCroppedImage:(UIImage *)croppedImage {
    
    self.cropperView.hidden = YES;
    self.croppedImageView.hidden = NO;
    self.croppedImageView.image = croppedImage;
    [self.cropButton setTitle:@"Select New Image" forState:UIControlStateNormal];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.cropperView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
