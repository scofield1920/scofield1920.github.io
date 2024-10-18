# misc_拼图题


记一misc拼图题

<!--more-->

初始图片

![flag](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/flag.jpg?imageSlim)

先剪裁

```python
from PIL import Image
# 打开完整的拼接图像
full_image = Image.open(r"C:\Users\scofi\Desktop\pintu\flag.jpg")
full_width, full_height = full_image.size

# 定义每个小图像的尺寸和间距
small_width, small_height = 300, 225
padding = 25
border = 25  # 添加白色边框大小
# 计算行列数
num_cols = (full_width - border) // (small_width + padding)
num_rows = (full_height - border) // (small_height + padding)
print(f"总共有 {num_rows} 行和 {num_cols} 列小图像.")
# 分割并保存小图像、
counter = 1
for row in range(num_rows):
    for col in range(num_cols):
        left = border + col * (small_width + padding)
        top = border + row * (small_height + padding)
        right = left + small_width
        bottom = top + small_height
        print(f"正在处理第 {counter} 张小图像：左上角坐标 ({left}, {top}), 右下角坐标 ({right}, {bottom})")
        # Crop the small image
        small_image = full_image.crop((left, top, right, bottom))

        # Convert to RGB mode (if not already in RGB)
        if small_image.mode != 'RGB':
            small_image = small_image.convert('RGB')
        # Save the small image
        small_image.save(r"C:\Users\scofi\Desktop\pintu\{counter}.jpg".format(counter=counter))
        counter += 1
print("所有小图像已保存完成.")
```

裁切后发现，每个小块并不是正方形，不方便拼图

将每一个块保存为新的正方形图片

```python
from PIL import Image
import os

# 输入文件夹路径
input_folder = r"C:\Users\scofi\Desktop\pintu"
# 输出文件夹路径
output_folder = r"C:\Users\scofi\Desktop\pintu\out"
# 指定正方形的边长
square_size = 50  # 默认边长为256

# 确保输出文件夹存在
if not os.path.exists(output_folder):
    os.makedirs(output_folder)


def process_images(input_folder, output_folder, square_size=None):
    for i in range(1, 401):
        input_path = os.path.join(input_folder, f"{i}.jpg")
        output_path = os.path.join(output_folder, f"{i}.jpg")

        # 打开图片
        img = Image.open(input_path)

        # 根据是否指定边长来进行处理
        if square_size:
            new_img = img.resize((square_size, square_size))
        else:
            width, height = img.size
            new_size = min(width, height)
            new_img = img.resize((new_size, new_size))

        # 保存为新的正方形图片
        new_img.save(output_path)


process_images(input_folder, output_folder, square_size)
```

## Montage+gaps拼图

### montage

`montage` 是 ImageMagick套件中的一个工具，它可以用来拼接多个图像文件成一张大图。

安装 ImageMagick：

```
sudo apt-get install imagemagick
```

> 使用 montage：
> 基本命令格式：
>
> ```
> montage [options] image1.jpg [image2.jpg ...] output.jpg
> ```
>
> 其中，image1.jpg、image2.jpg 等是你想要拼接的图像文件，output.jpg 是拼接后的输出文件名。
>
> 拼接参数：
>
> .tile：用于指定拼接的布局，格式为 rowsxcolumns。例如，-tile 2x3 表示将图像分成 2 行 3 列。
> -geometry：用于指定每个图像块的大小和位置。例如，-geometry +0+0 表示没有间隙地拼接图像。
> -gaps：在图像之间添加间隙，例如 -gaps 10x10。

montage 输入文件路径 -tile 长宽数量 -geometry 拼图间隙 输出路径

```
montage *.png -tile 20x20 -geometry +0+0 flag.png
```

使用montage重新拼接得到下图

![image-20241015193606283](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241015193606283.png?imageSlim)

### gaps

```
git clone https://github.com/nemanja-m/gaps.git
cd gaps
pip install -r requirements.txt
sudo apt-get install python-tk
pip install -e .
```

如果没有requirements.txt，可手动安装

```
numpy 
opencv-python
matplotlib
pytest
pillow
```

gaps参数

```
--size：拼图块的像素尺寸。如果不确定，gaps 可以自动检测。
--generations：遗传算法的代数。
--population：种群中的个体数量。
--verbose：每一代训练结束后展示最佳结果。
--save：将拼图解决方案保存为图像。
```

对montage拼合的图案进行自动拼图

```
gaps run flag.png out.png --generations=20 --population=1000 --size=50 --debug
```

![image-20241015204250816](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241015204250816.png?imageSlim)

如果拼图结果不理想，可以尝试调整 `--generations` 和 `--population` 参数，以增加迭代次数和种群大小。

## 小插曲

我的kali起初安装gaps失败，gaps命令仍为白色

执行gaps，kali会提示你：command not found，并询问安装mummer以执行gaps。

但mummer并不是我们需要的工具，若不小心安装了mummer，可以在终端执行以下操作将其删除：

```
sudo apt remove mummer
sudo apt autoclean
sudo apt autoremove
```

安装gaps时的报错信息

![image-20241015195318071](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241015195318071.png?imageSlim)

我们的 path 变量里并没有包含 gaps 的安装路径，需要手动添加：

```
以root状态在终端输入nano /etc/environment
在PATH="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"中加入":/home/kali/.local/bin"
(其中kali为用户名）
#生效方法：系统重启
#有效期限：永久有效
#用户局限：对所有用户
```


