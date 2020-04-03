//
//  BeautyFace.m
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/21.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//

#import "BeautyFace.h"
#import "GPUImage.h"
#import "GPUImageToonFilter.h"
//#import "GPUImageSmoothToonFilter.h"
#import "GPUImageBilateralFilter.h"                 //双边模糊
@interface BeautyFace ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
UIImagePickerController * _imagePickerController;//系统照片选择控制器
    UIImage *image;//讀取到的圖片
}



@property (weak, nonatomic) IBOutlet UIImageView *imageview;
- (IBAction)checkalbum:(id)sender;
- (IBAction)savephoto:(id)sender;
- (IBAction)beautyface:(id)sender;
@end

@implementation BeautyFace
- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePickerController=[[UIImagePickerController alloc]init];
    _imagePickerController.delegate =self;//初始化圖片選擇器

}



- (IBAction)checkalbum:(id)sender {
     [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 图片选择器选择图片代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    //取得选择图片
    image=[info objectForKey:UIImagePickerControllerOriginalImage];
    _imageview.image=image;
    //初始化CIImage源图像
/*    _image=[CIImage imageWithCGImage:selectedImage.CGImage];
    [_colorControlsFilter setValue:_image forKey:@"inputImage"];//设置滤镜的输入图片
 */
}




- (IBAction)savephoto:(id)sender {
}

- (IBAction)beautyface:(id)sender {
    GPUImageToonFilter *passthroughFilter = [[GPUImageToonFilter alloc] init];
       
       //设置要渲染的区域
       [passthroughFilter forceProcessingAtSize:image.size];
       
       [passthroughFilter useNextFrameForImageCapture];
       
       //获取数据源
       GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
       //加上滤镜
       [stillImageSource addTarget:passthroughFilter];
       //开始渲染
       
       [stillImageSource processImage];
       //获取渲染后的图片
       UIImage *newImage = [passthroughFilter imageFromCurrentFramebuffer];
    
       _imageview.image = newImage;
}
@end
