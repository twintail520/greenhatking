//
//  ViewController.m
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/5.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewController.h"
#import "faceDetectViewController.h"
#import "filterViewController.h"
@interface ViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
UIImagePickerController * _imagePickerController;//系统照片选择控制器


}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
- (IBAction)imagedispose:(id)sender;
- (IBAction)takephoto:(id)sender forEvent:(UIEvent *)event;
- (IBAction)checkAllbum:(id)sender;
- (IBAction)savephoto:(id)sender;
- (IBAction)facedetect:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 /*   UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 680, 100, 50)];//(x,y,长,宽)
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(gotoPhoto) forControlEvents:UIControlEventTouchUpInside];//button触发任意事件,可以是自己写的,也可以是拉取控件系统生成的,这里触发的是gotophoto,*/
//    [self.view addSubview:btn];


    // Do any additional setup after loading the view.
}
/*-(void)gotoPhoto
{
NSLog(@"photo");

self.imageView.backgroundColor = [UIColor whiteColor];
[self setupImagePickerController];//触发这个函数
}*/
//创建对象

-(void)setupImagePickerController{
//第一步:判断摄像头是否打开
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//第二步:实例化UIImagePickerController对象
        _imagePickerController = [[UIImagePickerController alloc] init];
//第三步:告诉picker对象是获取相机资源
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//第四步:设置代理
        _imagePickerController.delegate = self;
//第五步:设置picker可以编辑
        _imagePickerController.allowsEditing = YES;
//第六步:设置进去的模态方式
        _imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//第七步:跳转
        [self presentViewController:_imagePickerController animated:YES completion:nil];
}
}
//pragma mark --代理方法UIImagePickerControllerDelegate--


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//获取选中资源的类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//只能拍照(还有摄像或者二者都可以有的)
    NSString *requiredMediaType = (NSString *)kUTTypeImage;
    if([mediaType isEqualToString:requiredMediaType]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);//将照片存到媒体库

        self.imageView.image = image;
        [self saveImage:image];//照片存到沙盒

    //这里应该就是把图片显示到UIimageview上
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}//取消拍照

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}

/*
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//获取沙盒目录
NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName]; // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
*/


#pragma mark - 保存图片
- (void) saveImage:(UIImage *)currentImage {
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSLog(@"%@",NSHomeDirectory());
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentImage.png"];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
    [self.imageView1 setImage:[UIImage imageWithContentsOfFile:filePath]];
}
#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}



- (IBAction)imagedispose:(id)sender {
      
}


    
- (IBAction)takephoto:(id)sender forEvent:(UIEvent *)event {
    NSLog(@"photo");

    self.imageView.backgroundColor = [UIColor whiteColor];
 [self setupImagePickerController];//触发这个函数
}

#pragma mark - 从相册获取图片
- (IBAction)checkAllbum:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //获得相机模式下支持的媒体类型
        //        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                pickerImage.delegate = self;
                //设置允许编辑
                pickerImage.allowsEditing = YES;
                
                [self presentViewController:pickerImage animated:YES completion:^{
                }];
            }
   // [self showAllFilters];查看滤镜内容
    
    
}

- (IBAction)savephoto:(id)sender {
}

- (IBAction)facedetect:(UIButton *)sender {
    [self jumpToFunction];
}
-(void)jumpToFunction{//模态视图跳转
    faceDetectViewController * faceDetectController = [[faceDetectViewController alloc] init];
    faceDetectController.modalPresentationStyle = UIModalPresentationFullScreen;
    [ self presentViewController:faceDetectController animated: YES completion:nil];
}
/*#pragma mark 查看所有内置滤镜
-(void)showAllFilters{
    NSArray *filterNames=[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    for (NSString *filterName in filterNames) {
        CIFilter *filter=[CIFilter filterWithName:filterName];
        NSLog(@"\rfilter:%@\rattributes:%@",filterName,[filter attributes]);
    }
}
*/
@end
