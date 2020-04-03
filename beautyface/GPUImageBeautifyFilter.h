//
//  GPUImageFilterGroup+GPUImageBeautifyFilter.h
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/24.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import "GPUImageFilterGroup.h"
#import <GPUImage/GPUImage.h>
NS_ASSUME_NONNULL_BEGIN

@class GPUImageCombinationFilter;
@interface GPUImageBeautifyFilter : GPUImageFilterGroup //继承于图像滤镜组
 
{
    GPUImageBilateralFilter *bilateralFilter; //双边模糊(磨皮)滤镜--继承于高斯模糊滤镜GPUImageGaussianBlurFilter
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;//Canny边缘检测算法滤镜--继承于图像滤镜组GPUImageFilterGroup
    GPUImageHSBFilter *hsbFilter;//HSB颜色滤镜--继承于颜色矩阵滤镜GPUImageColorMatrixFilter
    GPUImageCombinationFilter *combinationFilter;//滤镜的组合---继承于三输入滤镜GPUImageThreeInputFilter
}
 
@end

NS_ASSUME_NONNULL_END
