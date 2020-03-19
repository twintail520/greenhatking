//
//  filterViewController.m
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/14.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "filterViewController.h"
#import<CoreImage/CoreImage.h>
@interface filterViewController ()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
UIImagePickerController *_imagePickerController;//系统照片选择控制器
//UIImageView *_imageView;//图片显示控件
CIContext *_context;//Core Image上下文
CIImage *_image;//我们要编辑的图像
CIImage *_outputImage;//处理后的图像
CIFilter *_colorControlsFilter;//色彩滤镜
}
- (IBAction)choosephoto:(UIButton *)sender;

- (IBAction)saturationchange:(UISlider *)sender;
- (IBAction)brightnesschange:(UISlider *)sender;
- (IBAction)contrastchange:(UISlider*)sender;
- (IBAction)savephoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation filterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化图片选择器
    _imagePickerController=[[UIImagePickerController alloc]init];
    _imagePickerController.delegate =self;

    //初始化CIContext
    //创建基于CPU的图像上下文
    //    NSNumber *number=[NSNumber numberWithBool:YES];
    //    NSDictionary *option=[NSDictionary dictionaryWithObject:number forKey:kCIContextUseSoftwareRenderer];
    //    _context=[CIContext contextWithOptions:option];
    _context=[CIContext contextWithOptions:nil];//context是全局变量,要在函数内部赋值.使用GPU渲染，推荐,但注意GPU的CIContext无法跨应用访问，例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，所以推荐现在完成方法中保存图像，然后在主程序中调用
    //    EAGLContext *eaglContext=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
    //    _context=[CIContext contextWithEAGLContext:eaglContext];//OpenGL优化过的图像上下文

    //取得滤镜
    _colorControlsFilter=[CIFilter filterWithName:@"CIColorControls"];

}


- (IBAction)choosephoto:(UIButton *)sender {
 [self presentViewController:_imagePickerController animated:YES completion:nil];

}
#pragma mark 图片选择器选择图片代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    //取得选择图片
    UIImage *selectedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    _imageview.image=selectedImage;
    //初始化CIImage源图像
    _image=[CIImage imageWithCGImage:selectedImage.CGImage];
    [_colorControlsFilter setValue:_image forKey:@"inputImage"];//设置滤镜的输入图片
}
#pragma mark 将输出图片设置到UIImageView
-(void)setImage{
    CIImage *outputImage= [_colorControlsFilter outputImage];//取得输出图像
    CGImageRef temp=[_context createCGImage:outputImage fromRect:[outputImage extent]];
    _imageview.image=[UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    
    CGImageRelease(temp);//释放CGImage对象
}



- (IBAction)saturationchange:(UISlider *)sender {
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:sender.value] forKey:@"inputSaturation"];//设置滤镜参数
    [self setImage];
}

- (IBAction)brightnesschange:(UISlider *)sender {
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:sender.value] forKey:@"inputBrightness"];
    [self setImage];
}

- (IBAction)contrastchange:(UISlider *)sender {
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:sender.value] forKey:@"inputContrast"];
    [self setImage];
}

- (IBAction)savephoto:(id)sender {
UIImageWriteToSavedPhotosAlbum(_imageview.image, nil, nil, nil);
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sytem Info" message:@"Save Success!" preferredStyle:  UIAlertControllerStyleAlert];
[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //点击按钮的响应事件；
     }]];
     //弹出提示框；
[self presentViewController:alert animated:true completion:nil];

}
@end
