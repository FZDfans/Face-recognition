clear,clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            不使用教科书上的传统方法进行人脸检测，转而使用vision类的预训练模型进行人脸识别     %               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 读取输入图像
inputImage = imread('14.png'); 
figure;imshow(inputImage);title("原图")
pause(1);

%转化为灰度图像
inputImage = rgb2gray(inputImage);
figure;imshow(inputImage);title("灰度图像")
pause(1);

% 增强对比度
inputImage = imadjust(inputImage);
figure;imshow(inputImage);title("增强对比度")
pause(1);

% 去噪声处理
inputImage = medfilt2(inputImage, [3 3]);
figure;imshow(inputImage);title("降噪")
pause(1);

% 创建人脸检测器
faceDetector = vision.CascadeObjectDetector();
faceDetector.MinSize = [30 30]; % 调整最小检测尺寸
faceDetector.ScaleFactor = 1.1; % 调整检测尺度因子

% 检测图像中的人脸
bbox = step(faceDetector, inputImage);

% 绘制检测到的人脸区域
IFaces = insertObjectAnnotation(inputImage, 'rectangle', bbox, 'face');
figure;
imshow(IFaces);
title('成功识别的人脸');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            现在在图中截取一个人脸，使用传统方法进行人脸识别               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 读取大图和模板图像
% 读取图像
largeImage = imread('合照.jpg'); % 替换为实际大图路径
templateImage = imread('正脸.jpg'); % 替换为实际模板图像路径

% 创建一个新的图形窗口
figure;

% 显示原图
subplot(1, 3, [1,2]); % 创建 1 行 2 列的子图，选择第 1 个子图
imshow(largeImage); % 显示大图
title('原图');

% 显示模板图像
subplot(1, 3, 3); % 选择第 2 个子图
imshow(templateImage); % 显示模板图像
title('模板图像');

set(gcf, 'Position', [100, 100, 800, 400]); % 设置图形窗口的大小
pause(1);

% 转换为灰度图像
largeImageGray = rgb2gray(largeImage);
templateImageGray = rgb2gray(templateImage);

% 创建一个新的图形窗口
figure;

% 显示原图
subplot(1, 3, [1,2]); % 创建 1 行 2 列的子图，选择第 1 个子图
imshow(largeImageGray); % 显示大图
title('原图');

% 显示模板图像
subplot(1, 3, 3); % 选择第 2 个子图
imshow(templateImageGray); % 显示模板图像
title('模板图像');

set(gcf, 'Position', [100, 100, 800, 400]); % 设置图形窗口的大小
pause(1);

% 增强对比度
largeImageGray = imadjust(largeImageGray);
templateImageGray = imadjust(templateImageGray);
% 创建一个新的图形窗口
figure;

% 显示原图
subplot(1, 3, [1,2]); % 创建 1 行 2 列的子图，选择第 1 个子图
imshow(largeImageGray); % 显示大图
title('原图');

% 显示模板图像
subplot(1, 3, 3); % 选择第 2 个子图
imshow(templateImageGray); % 显示模板图像
title('模板图像');

set(gcf, 'Position', [100, 100, 800, 400]); % 设置图形窗口的大小
pause(1);

% 去噪声处理
largeImageGray = medfilt2(largeImageGray, [3 3]);
templateImageGray = medfilt2(templateImageGray, [3 3]);
% 创建一个新的图形窗口
figure;

% 显示原图
subplot(1, 3, [1,2]); % 创建 1 行 2 列的子图，选择第 1 个子图
imshow(largeImageGray); % 显示大图
title('原图');

% 显示模板图像
subplot(1, 3, 3); % 选择第 2 个子图
imshow(templateImageGray); % 显示模板图像
title('模板图像');

set(gcf, 'Position', [100, 100, 800, 400]); % 设置图形窗口的大小
pause(1);

% 使用模板匹配进行匹配
correlationMap = normxcorr2(templateImageGray, largeImageGray);

% 找到匹配位置
[maxCorr, maxIdx] = max(abs(correlationMap(:)));
[y, x] = ind2sub(size(correlationMap), maxIdx);

% 获取匹配位置的坐标
yOffset = y - size(templateImageGray, 1);
xOffset = x - size(templateImageGray, 2);

% 在大图中标记匹配位置
outputImage = largeImage;
outputImage = insertShape(outputImage, 'Rectangle', [xOffset, yOffset, size(templateImageGray, 2), size(templateImageGray, 1)], 'Color', 'red', 'LineWidth', 2);

% 显示结果
% 创建一个新的图形窗口
figure;

% 显示原图
subplot(1, 3, [1,2]); % 创建 1 行 2 列的子图，选择第 1 个子图
imshow(outputImage); % 显示大图
title('找到了目标人物的位置');

% 显示模板图像
subplot(1, 3, 3); % 选择第 2 个子图
imshow(imread('正脸.jpg')); % 显示模板图像
title('目标图像');

set(gcf, 'Position', [100, 100, 800, 400]); % 设置图形窗口的大小
