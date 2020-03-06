//
//  ViewController.m
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/5.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewController.h"

@interface ViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
UIImagePickerController * _imagePickerController;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 680, 100, 50)];//(x,y,长,宽)
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(gotoPhoto) forControlEvents:UIControlEventTouchUpInside];//button触发任意事件,可以是自己写的,也可以是拉取控件系统生成的,这里触发的是gotophoto,
    [self.view addSubview:btn];

    // Do any additional setup after loading the view.
}
-(void)gotoPhoto
{
NSLog(@"photo");
self.imageView.backgroundColor = [UIColor greenColor];
[self setupImagePickerController];//触发这个函数
}
//创建对象

-(void)setupImagePickerController
{
//第一步:判断摄像头是否打开
if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
{
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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//获取选中资源的类型
NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//只能拍照(还有摄像或者二者都可以有的)
NSString *requiredMediaType = (NSString *)kUTTypeImage;
if([mediaType isEqualToString:requiredMediaType])
{
UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
self.imageView.image = image;
}
[picker dismissViewControllerAnimated:YES completion:nil];
}
//
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
[picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}


@end
