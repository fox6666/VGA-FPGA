# VGA-FPGA

## 存储器与显示控制器 

## 实验内容

* [**实验内容**]  
    控制画笔在1024x768分辨率的显示器上随意涂画，画笔的颜色12位(红r绿g蓝b各4位)，绘画区域位于屏幕正中部，大小为256x256
    * 画笔位置(x, y): x = y = 0 ~ 255, 复位时 (128, 128)
    * 移动画笔(dir): 上/下/左/右按钮
    * 画笔颜色(rgb): 12位开关设置
    * 绘画状态(draw): 1-是, 0-否；处于绘画状态时，移动画笔同时绘制颜色，否则仅移动画笔
* [**VRAM**]  
    视频存储器，存储256x256个像素的颜色信息，采用简单双端口存储器实现.  
    * paddr, pdata, we: 地址、数据、写使能，用于绘画的同步写端口
    * vaddr, vdata: 地址、数据，用于显示的异步读端口 
* [**PCU**]  
    Paint Control Unit，绘画控制单元，修改VRAM中像素信息.
    * 通过12个拨动开关设置像素颜色 (rgb)
    * 通过上/下/左/右(dir)按钮开关，移动画笔位置(x, y)
        * 直角移动：单一按钮按下一次，x或y增加或减小1
        * 对角移动：两按钮同时按下一次，x和y同时加或减1
        * 连续移动：按钮按下超过t秒后，等效为s速率的连续点击，直至松开（调试时确定合适的t和s取值）
    * 绘画 (draw=1) 时，依据 rgb 和 (x, y)，通过写端口(paddr, pdata, we) 修改VRAM像素信息
* [**DCU**]  
    Display Control Unit，显示控制单元，显示VRAM中像素信息.
    * 通过读端口(vaddr, vdata)取出VRAM信息并显示
    * vrgb, hs, vs：显示器接口信号
        * 显示模式：分辨率1024x768，刷新频率70Hz，像素时钟频率75MHz
        * VRAM中的1个像素对应显示屏上1个像素
    * 在屏幕上显示十字光标，指示画笔当前位置 (x, y)

## 原理图
![原理图](https://github.com/fox6666/VGA-FPGA/blob/master/images/VGA.png "原理图")

<div align=center>
    <img width="430" height="140" src="https://github.com/fox6666/VGA-FPGA/blob/master/images/VGA.png"/>
</div>


## 参考资料
    




