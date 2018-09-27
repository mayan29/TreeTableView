# TreeTableView

>
> 2018-09-27 更新日志 
>
> 之前几个月断断续续的优化了部分内容，但是变动不是很大。这几天综合了项目的新需求和 issues 的反馈，整体做了大改动，修改了数据调用方式，优化了部分代码，并且增加了一些新功能：
>
> - 是否显示展开/折叠动画
> - 是否没有子节点就不显示箭头
> - 是否单选时再次点击可以取消选择
> - 是否展开已选择的节点
>


公司项目中有大量的树状列表，每个页面需要的数据和风格样式也不尽相同，新增一个页面就会进行大量的代码复制。在 GitHub 上找了很多树状列表，功能都不太理想，所以干脆自己封装一个树状列表控件，适配所有页面。

调用方法就不详细说明了，看 Demo 中的例子就可以了。代码不优雅之处欢迎在 issues 中提出指正 🤝，喜欢的话给个 Star 吧 ~

功能展示：

- 多级列表
- 展开 / 折叠
- 一键展开 / 折叠 N 级列表
- 单选 / 多选
- 一键勾选 / 取消勾选
- 搜索框查询并展示

![DemoImage](https://github.com/mayan29/TreeTableView/blob/master/DemoImage.gif)

城市列表数据为 3000 多个 item，实测页面丝滑无卡顿（感谢 @modood 提供的城市数据 [https://github.com/modood/Administrative-divisions-of-China](https://github.com/modood/Administrative-divisions-of-China)）

![DemoImage2](https://github.com/mayan29/TreeTableView/blob/master/DemoImage2.gif)

