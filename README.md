好玩的Runtime:  一行代码解决懒加载 
### 解决问题:
1. 更方便的懒加载
``` objc
- (Animal *)animal {
if (_animal) {
_animal = [Animal new];
}
return _layerView;
}
```
2. 部分数据的容错
``` objc
self.nameLabel.text = [NSString stringWithFormat:@"动物名称:%@", self.animal.name];
```
### 使用方法:
``` objc
[Animal ry_setLazyPropertyArr:@[@"name",@"foots",@"attribute",]];
[ViewController ry_setLazyPropertyArr:@[@"animal"]];
```
该方法仅支持 `Objective-C` 对象
### 在调用通过 `ry_setLazyPropertyArr` 设置的实例变量的时候, 如果该实例变量为 nil, 如果这个实例变量被重写了`set`方法会调用重写后的 `set` 方法, 否则会通过`[[Class alloc] init]`生成一个对象(不会影响`KVO`).
