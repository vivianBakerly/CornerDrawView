# PI_CornerDrawView
Improve Corner Radius by Async Drawing

### 一、现状：
App中一些需要画圆角的图片会触发离屏渲, 同一屏若出现许多圆角时有可能出现掉帧。

###二、原因：
在一个 VSync 时间内，GPU 没有完成内容提交，当前渲染帧被丢弃。而此时，CPU 占用率很低，GPU 占用过高。 当一个tableView中出现大量圆角的CALayer，且快速滑动时，会触发GPU的离屏渲染，导致FPS降低。

因此，触发条件为：

    Any layer with a mask (layer.mask)
    Any layer with layer.masksToBounds being true
    Any layer with layer.allowsGroupOpacity set to YES and layer.opacity is less than 1.0
    Any layer with a drop shadow (layer.shadow*).
    Any layer with layer.shouldRasterize being true
    Any layer with layer.cornerRadius, layer.edgeAntialiasingMask, layer.allowsEdgeAntialiasing
    
###三、解决方案
对比使用了四种可实现圆角的方式：利用MASK，后台绘制圆角图片，光栅化和系统圆角。

###解决方案及原理
#####解决方案一：异步绘制图片
 适用一个SerialDispatchQueue在后台线程绘制好圆角图片后，在主线程设置UIView的背景图。这个解决办法把GPU的代价转移到了CPU上，比较适用的场景应是同一屏幕上tableView需要同时出现多个圆角时，这种情况下能够较明显地避免离屏渲染引起的卡顿。

3.1.1 每一个任务的触发时间 当CornerRadiusView的frame/cornerRadius/borderwidth/bordercolor变化时都会触发一次任务。每个任务带有自己的标示符，后一个任务启动表示前一个任务无效

3.1.2绘制过程之前 & 把图片设置到view上之前，检查是否需要取消当前任务

3.1.3 若任务成功，则会把当前已绘制好的两个UIImage缓存

3.1.4下次任务时检查需要重绘或是直接使用缓存的UIImage，以减少绘制的次数

ps：在使用自定义方法，相同条件的前提下：
在使用缓存UIImage来减少绘制次数后，cpu使用率从39%下降到了24%
放弃了重写drawrect而改用3.的想法后，内存使用率从26%下降到21%
关于2.2 点，尝试过使用setNeedsDisplay & drawRect来控制绘制的次数，而免去比较两次任务的不同 & 保存上次任务信息的过程。但发现会带来更多内存使用的上升。
原因分析大概是因为支持图层会请求画板视图给它一个寄宿图来显示，而图层每次重绘的时候都需要重新抹掉内存然后重新分配。

#####解决方案二：Mask
Mask相当于一个遮罩，来决定图片什么部分显示出来。mask也是CALayer，可以通过在后台线程绘制的方法，也可以设置出圆角图片(无边框)的效果。    

#####解决方案三：光栅化
shouldRasterize为YES时，Layer被渲染成一个bitmap，并缓存起来，对一些添加了shawdow等效果的耗费资源较多的静态内容进行缓存等下次使用时不会重新再渲染一次了。

###四、四种方法性能对比
选用在整屏幕都是圆角的极端情况进行对比。
![Smaller icon](/Users/isahuang/Desktop/11223.jpeg)
###五、结论及原因分析
 5.1 MASK的FPS最差，绘制图片的FPS最优
有关MASK的操作会发生了两次离屏渲染和一次主屏渲染，还要加上下文切换的代价。因此其实使用MASK比系统圆角性能更差。



 5.2 除了绘制图片，其他都有可能触发离屏渲染
      由于MASK, 光栅化本质上都是对CALayer进行操作。会离屏渲染的场景如下，因此这两种方法都满足本文第二点中的条件，因此会引起离屏渲染。

 5.2 光栅化并未在重用Cell的tableView，且大量渲染不同内容的圆角图片时带来优化
      光栅化的Layer的缓存优化，只能用在图像内容不变的前提下的，用于避免多个View嵌套的复杂View的重绘。假如图层发生改变，GPU则要建立新的缓存，因此而对于经常变动的情况，如Cell重用而内容不同的TableView的情况下开启，不会带来好处，反而会造成性能的浪费。

###六、适用场景和使用方法
6.1 绘制图片
在tableView重用cell且大量使用了圆角图片时，快速滑动能够不影响FPS。尝试了一下，重写setFrame可用xib

6.2 光栅化
在连续不断使用的，内容不变的圆角图片, 由于有缓存，会在系统圆角的基础上带来一些性能的提升

6.3 MASK
无法绘制边框且性能差于系统圆角
