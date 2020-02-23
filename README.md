# QuantLibEx-SWIG

一些用于扩展 QuantLib-SWIG 的实验性接口文件。

---

目前的实现仅支持从固息债交易数据中估计期限结构模型的参数。

相较于官方的 QuantLib-SWIG，主要改进是增加了创建 `FittingMethod` 子类对象的自由度，即用户可以添加 `OptimizationMethod` 对象指定优化引擎，并添加 `Array` 对象作为参数的 $L^2$ 正则化条件。
