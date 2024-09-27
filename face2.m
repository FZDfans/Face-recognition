%%%完整代码
clear all;

rgb = imread('16.png');
I = rgb2gray(rgb);
[n1,n2] = size(I);
%灰度图
figure,imshow(I),title('灰度图')
tic
h = ones(9)/81;
I = uint8(conv2(I,h));
figure,imshow(I),title('线性均值滤波')
BW = imbinarize(I);
figure,imshow(BW),title('二值化')
B = ones(21);%结构元素
BW = -imerode(BW,B) + BW;
figure,imshow(BW),title('形态学边界提取')
BW = bwmorph(BW,'thicken');
figure,imshow(BW),title('加粗边界')
BW = not(bwareaopen(not(BW), 300));
figure,imshow(BW),title('填补空洞')
% 进行形态学运算
B = strel('line',50,90);
BW = imdilate(BW,B);
BW = imerode(BW,B);
figure,imshow(BW),title('再闭操作之后')
B = strel('line',10,0);
BW = imerode(BW,B);
figure,imshow(BW),title('闭操作之后再腐蚀')
%%BW = gpuArray(BW);%%将数据载入gpu可以加速，电脑不一定支持的
 
%最小化背景
%细分
div = 10;
r = floor(n1/div);%分成10块 行
c = floor(n2/div);%分成10块 列
x1 = 1;x2 = r;%对应行初始化
s = r*c;%块面积
%判断人脸是否处于图片四周，如果不是就全部弄黑
%figure
for i=1:div
    y1 = 1;y2 = c;%对应列初始化
    for j=1:div
        loc = find(BW(x1:x2,y1:y2)==0);%统计这一块黑色像素的位置
        num = length(loc);
        rate = num*100/s;%统计黑色像素占比
        if (y2<=0.2*div*c||y2>=0.8*div*c)||(x1<=r||x2>=r*div)
            if rate <=100
                BW(x1:x2,y1:y2) = 0;
            end
            %imshow(BW)
        else
            if rate <=25
                BW(x1:x2,y1:y2) = 1;
            end
            %imshow(BW)
        end%下一列
        y1 = y1 + c;
        y2 = y2 + c;
    end%下一行
    x1 = x1 + r;
    x2 = x2 + r;
end
 
figure
subplot(1,2,1)
imshow(BW)
title('最终处理')
L = bwlabel(BW,8);%利用belabel函数对8连通域区间进行标号
BB = regionprops(L,'BoundingBox');%得到矩形框，框柱每一个连通域
BB = cell2mat(struct2cell(BB));
[s1,s2] = size(BB);
BB = reshape(BB,4,s1*s2/4)';
pickshape = BB(:,3)./BB(:,4);%
shapeind = BB(0.3<pickshape&pickshape<3,:);%筛选掉尺寸比例不合格
[~,arealind] = max(shapeind(:,3).*shapeind(:,4));
subplot(1,2,2)
imshow(rgb)
hold on
rectangle('Position',[shapeind(arealind,1),shapeind(arealind,2),shapeind(arealind,3),shapeind(arealind,3)],...
    'EdgeColor','g','Linewidth',2)
title('人脸检测')
toc
%%注明：32行~63行代码借鉴了GitHub的人脸识别算法