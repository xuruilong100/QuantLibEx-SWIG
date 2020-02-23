# QuantLibEx-SWIG

[toc]

一些用于扩展 QuantLib-SWIG 的实验性接口文件。

## 介绍

要生成 Python 包，请执行下列命令：

```
swig -c++ -python -outdir QuantLibEx -o QuantLibEx/qlx_wrap.cpp quantlibex.i

python3 setup.py build

sudo python3 setup.py install
```

目前的实现仅支持从固息债交易数据中估计期限结构模型的参数。

相较于官方的 QuantLib-SWIG，主要改进是增加了创建 `FittingMethod` 子类对象的自由度，即用户可以添加 `OptimizationMethod` 对象指定优化引擎，并添加 `Array` 对象作为参数的 $L^2$ 正则化条件。

## 注意

代码仅在如下环境中测试过：
* Ubuntu 18.04.4 LTS
* GCC 7.4.0
* Python 3.6.9
* QuantLib 1.15（来自 [Dirk Eddelbuettel](http://dirk.eddelbuettel.com/) 的 [PPA](https://launchpad.net/~edd/+archive/ubuntu/misc)）

## 延伸阅读

* [《QuantLib 金融计算——自己动手封装 Python 接口（2）》](https://www.cnblogs.com/xuruilong100/p/12350548.html)
* [《QuantLib 金融计算——收益率曲线之构建曲线（5）》](https://www.cnblogs.com/xuruilong100/p/11892545.html)
