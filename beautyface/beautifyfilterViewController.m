//
//  beautifyfilterViewController.m
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/24.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//

//#import <Masonry/Masonry.h>
#import "GPUImageBeautifyFilter.h"
#import "beautifyfilterViewController.h"
#import "GPUImage.h"
@interface beautifyfilterViewController ()
@property (nonatomic, strong) UIButton *backButton;
@property (strong, nonatomic) GPUImageVideoCamera *videoCamera;//视频相机对象
@property (strong, nonatomic) GPUImageView *filterView;//实时预览的view,GPUImageView是响应链的终点，一般用于显示GPUImage的图像。
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera;//前置攝像頭水平鏡像
@property (weak, nonatomic) UIButton *beautifyButton;

@end

@implementation beautifyfilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
       self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
      // self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
      self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
      self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    //前置攝像頭不要景象反轉
       
       //预览层
       self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
       self.filterView.center = self.view.center;
       [self.view addSubview:self.filterView];
       //添加滤镜到相机
       [self.videoCamera addTarget:self.filterView];
       [self.videoCamera startCameraCapture];
       //设置按钮
       UIButton *beautifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       self.beautifyButton = beautifyBtn;
       [self.view addSubview:beautifyBtn];
     //  self.beautifyButton.backgroundColor = [UIColor whiteColor];
   //    [self.beautifyButton setTitle:@"开启" forState:UIControlStateNormal];
   //    [self.beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
    [beautifyBtn setImage:[UIImage imageNamed:@"cameraAround"] forState:UIControlStateNormal];
   //    [self.beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
       beautifyBtn.frame = CGRectMake(100, 40, 60, 40);
    //返回按鈕
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton = backBtn;
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
  //  self.backButton.backgroundColor = [UIColor whiteColor];
  //  [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backBBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(30, 40, 50, 30);
    
}
//返回
- (void)backBBtn:(UIButton *)btn {//模態視圖跳轉回功能選擇界面
    [self dismissViewControllerAnimated:YES completion:nil];
}
//美顏
- (void)beautify {
    if (self.beautifyButton.selected) {//如果已经开启了美颜,则
        self.beautifyButton.selected = NO;
        [self.videoCamera removeAllTargets];//移除原有的
        [self.videoCamera addTarget:self.filterView];//添加普通预览层
    } else {//如果没有开启美颜
        self.beautifyButton.selected = YES;
        [self.videoCamera removeAllTargets];//移除原有的
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        [self.videoCamera addTarget:beautifyFilter];//添加美颜滤镜层
        [beautifyFilter addTarget:self.filterView];//美颜后再输出到预览层
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}/*(1)当应用可用内存过低导致系统发出内存警告的时候,便会触发此方法。
(2)清除不需要的视图,满足以下两个条件:1.视图已经被创建 2.不需要在 window 上显示了
(3)当从写此方法时,需要调用父类。调用super的didReceiveMemoryWarning只是释放controller的resouse，不会释放view。
(4)具体过程:当系统内存不足时，首先UIViewController的didReceiveMemoryWarining 方法会被调用，而didReceiveMemoryWarining 会判断当前ViewController的view是否显示在window上，如果没有显示在window上，则didReceiveMemoryWarining 会自动将viewcontroller 的view以及其所有子view全部销毁，然后调用viewcontroller的viewdidunload方法。如果当前UIViewController的view显示在window上，则不销毁该viewcontroller的view，当然，viewDidunload也不会被调用了。
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
