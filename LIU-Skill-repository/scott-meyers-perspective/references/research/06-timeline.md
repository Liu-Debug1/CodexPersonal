# Scott Meyers 完整时间线

> 编译自多源公开信息。时间线按时间顺序组织，标注关键转折点。

---

## 一、早年与教育背景（1959–1993）

### 1959 — 出生
- **日期**：1959 年 4 月 9 日
- **全名**：Scott Douglas Meyers
- **国籍**：美国
- **可信度**：高 — Wikipedia、DBpedia 等多源一致确认
- **来源**：[Wikipedia](https://en.wikipedia.org/wiki/Scott_Meyers) | [DBpedia](http://fragments.dbpedia.org/2015/en?subject=http%3A%2F%2Fdbpedia.org%2Fresource%2FScott_Meyers)

### 1971 — 开始编程
- 11–12 岁开始写程序
- **可信度**：中高 — DConf 2017 官方 bio 提及
- **来源**：[DConf 2017 - Things That Matter](https://dconf.org/2017/talks/meyers.html)

### 1972 — 开始教授编程
- 仅 13 岁就开始教别人编程
- **可信度**：中 — 同上来源
- **来源**：[DConf 2017 - Things That Matter](https://dconf.org/2017/talks/meyers.html)

### 1983 — 斯坦福大学（Stanford University）学士与硕士
- 获 **B.S. in Computer Science**（具体年份推测为 1983）
- 获 **M.S. in Computer Science**（同一年份）
- **可信度**：高 — Brown University 博士论文扉页确认
- **来源**：[Brown CS Tech Report CS-93-12](https://cs.brown.edu/research/pubs/techreports/reports/CS-93-12.html)

### 1987 — 布朗大学 Sc.M.（硕士级学位）
- 获 **Sc.M.** (Master of Science) from Brown University
- **可信度**：高 — 博士论文扉页
- **来源**：[Scott Meyers PhD Dissertation PDF](https://cs.brown.edu/media/filer_public/a9/b6/a9b63871-6637-4610-9535-484ded4816b7/meyers.pdf)

### 1986 — 开始学习 C++
- 据 Meyers 自述，可能在 1986 年或 1988 年开始学习 C++（他本人不确定）
- 记录倾向于 1988 年
- **可信度**：中 — Meyers 本人原话"记忆不可靠"
- **来源**：[CSDN 转载 Scott Meyers 文章](https://blog.csdn.net/hejishan/article/details/2238777)

### 1993 — 布朗大学（Brown University）计算机科学博士
- **论文题目**："Representing Software Systems in Multiple-View Development Environments"（多视图开发环境中软件系统的表示）
- **导师**：Steven P. Reiss
- **核心贡献**：提出 Semantic Program Graphs (SPGs) 新图结构
- **可信度**：高 — Brown University 官方技术报告存档
- **来源**：[Brown CS Tech Report CS-93-12](https://cs.brown.edu/research/pubs/techreports/reports/CS-93-12.html)

---

## 二、学术与早期 C++ 工作（1990–1995）

### 1990 — 首篇 C++ 学术论文发表
- 按他 2015 年退休文中的说法："25 years after publication of my first academic papers involving C++"
- **可信度**：中 — 退休文自述
- **来源**：[} // good to go](http://scottmeyers.blogspot.com/2015/12/good-to-go.html)

### 1990–1992 — C++ Report 杂志专栏作者
- 定期为 C++ Report 撰写文章
- 为 Effective C++ 系列积累了素材
- **可信度**：中高 — 多家资料提及
- **来源**：[HandWiki - C++ Report](https://handwiki.org/wiki/C%2B%2B_Report)

### 1991–1992 — Effective C++ 第一版出版（里程碑）
- 1991 年执笔，1992 年正式出版
- **书名**：*Effective C++: 50 Specific Ways to Improve Your Programs and Designs*
- **ISBN**：0-201-56364-9
- 开创了"具体做法（Items）"范式
- 首次提出 prescriptive（规范性）而非 descriptive（描述性）的 C++ 写作风格
- **可信度**：高 — 多方确认
- **来源**：[aristeia.com/books.html](https://www.aristeia.com/books.html) | [Wikipedia](https://en.wikipedia.org/wiki/Scott_Meyers)

### 1995–1996 — More Effective C++ 出版
- **书名**：*More Effective C++: 35 New Ways to Improve Your Programs and Designs*
- **ISBN**：0-201-63371-X
- 涵盖引用计数、智能指针、代理类、双重分派、异常处理等
- **可信度**：高
- **来源**：[aristeia.com/books.html](https://www.aristeia.com/books.html)

---

## 三、成名与系列巩固（1997–2005）

### 1997–1998 — Effective C++ 第二版
- 50 个 Items，其中 48 个保持原题
- 对 C++ 语言的演进做了更新
- **可信度**：高
- **来源**：[aristeia.com/books.html](https://www.aristeia.com/books.html)

### 1999 — Effective C++ CD-ROM
- **书名**：*Effective C++ CD: 85 Specific Ways to Improve Your Programs and Designs*
- 结合第二版（50 items）+ More Effective C++（35 items）
- HTML 交互式格式，含全文搜索、跨链接、书签功能
- 售价 $29.95
- Dr. Dobb's / Slashdot 均给出极高评价
- **可信度**：高
- **来源**：[Dr. Dobb's Review](https://drdobbs.com:443/review-of-scott-meyers-effective-c-compa/184403643) | [InformIT](https://www.informit.com/store/effective-c-plus-plus-cd-85-specific-ways-to-improve-9780201310153)

### 1999 年 8 月 — GCC 引入 `-Weffc++` 警告标志
- GCC 2.95.1 首次加入该选项
- 基于 Effective C++ 第一版的规范检查
- 后更新至第二版
- 这是 Meyers 影响力的标志性事件：编译器专门为作者的书加警告
- **可信度**：高 — GCC 邮件列表存档
- **来源**：[GCC 1999 mailing list](https://gcc.gnu.org/legacy-ml/gcc/1999-08n/msg00996.html) | [GCC Documentation](https://gcc.gnu.org/onlinedocs/gcc-6.4.0/gcc.pdf)

### 2001 — Effective STL 出版
- **书名**：*Effective STL: 50 Specific Ways to Improve Your Use of the Standard Template Library*
- **ISBN**：0-201-74962-9
- 专注 STL 的性能、资源泄漏、可移植性
- **可信度**：高
- **来源**：[aristeia.com/books.html](https://www.aristeia.com/books.html)

### 2001–2002 — 创办 The C++ Seminar（里程碑）
- Meyers 构思并联合组织的小型封闭式会议
- **联合组织者**：Herb Sutter、Andrei Alexandrescu、Dan Saks、Steve Dewhurst
- 共举办 3 次
- **可信度**：中高 — Wikipedia 记录
- **来源**：[Wikipedia](https://en.wikipedia.org/wiki/Scott_Meyers)

### 2002 年 3 月 — 宣布担任 Addison-Wesley 咨询编辑
- 负责 **Effective Software Development Series**
- 为该系列物色作者、审阅手稿
- 延续至今的系列（包括后来的 Effective Modern C++ 也在此系列中）
- **可信度**：高 — 原始博客公告
- **来源**：[scottmeyers.blogspot.com/2002/03](http://scottmeyers.blogspot.com/2002/03/effective-software-development-series.html)

### 2004 — "Double-Checked Locking" 文章
- 与 Andrei Alexandrescu 合著 "C++ and the Perils of Double-Checked Locking"
- Dr. Dobb's Journal 分两期刊登（2004 年 7 月 / 8 月）
- **可信度**：高
- **来源**：[aristeia.com/publications.html](https://www.aristeia.com/publications.html)

### 2005 — Effective C++ 第三版（里程碑）
- 从 50 个 Items 扩展至 55 个
- 大幅重写，新增资源管理、模板、异常安全、RAII、TR1 等
- 反映从 C/Java 背景转到 C++ 的读者群体变化
- **这是 Effective C++ 的最终版本，未出第四版**
- **可信度**：高
- **来源**：[aristeia.com/books.html](https://www.aristeia.com/books.html)

---

## 四、博客活跃期与社区影响（2004–2014）

### 2004–2015 — "The View from Aristeia" 博客
- 托管于 `scottmeyers.blogspot.com`
- 最初标题："Scott Meyers' Professional Activities and Interests"
- 覆盖内容：C++ 技术深度分析、演讲公告、行业评论
- 2006–2007 年最活跃的系列："Five Lists of Five"
  - 五本最重要的 C++ 书
  - 五篇最重要的非书出版物
  - 五个最重要的 C++ 软件
  - 五位最重要的 C++ 人物
  - 五个 C++ "Aha!" 瞬间
- 博客后期活跃度下降，2014 年后基本只发公告类内容
- **可信度**：高 — 博客本身存档
- **来源**：[scottmeyers.blogspot.com](http://scottmeyers.blogspot.com)

### 2006 — 反对白板面试
- 在 Artima.com 采访中公开反对当场编程/设计面试
- 名言："I think it's fundamentally an unfair thing to request of a candidate."
- 比业界广泛反思白板面试早了近十年
- **可信度**：中高 — Wikipedia 及多处转载引用
- **来源**：[Wikipedia](https://en.wikipedia.org/wiki/Scott_Meyers)

### 2009 年 3 月 — Dr. Dobb's Excellence in Programming 奖（里程碑）
- Dr. Dobb's Journal 颁发的编程卓越奖
- 该奖项的最后一位获奖者（1995–2009 年）
- $1,000 奖金捐给指定慈善机构
- **可信度**：高
- **来源**：[Dr. Dobb's 2009](https://drdobbs.com/cpp/dr-dobbs-2009-excellence-in-programming/215900307) | [Wikipedia](https://en.wikipedia.org/wiki/Dr._Dobb%27s_Excellence_in_Programming_Award)

### 2010 — 两套培训材料出版
- *Overview of The New C++ (C++11)* — ~400 页
- *Effective C++ in an Embedded Environment* — ~340 页
- Artima Press 出版，PDF 格式（幻灯片 + 演讲者注释）
- 无 ISBN，均为注解式培训材料
- **可信度**：高
- **来源**：[Wikipedia](https://en.wikipedia.org/wiki/Scott_Meyers) | [Artima forums](https://www.artima.com/forums/flat.jsp?forum=269&thread=290534)

### ~2010 — 创造「Universal References」术语
- 首次在 NWCPP（华盛顿州 Redmond）演讲中提出
- 最初用 "forwarding reference" 后来改称 "universal reference"
- C++17 标准委员会最终正式采用 "forwarding reference"
- 但社区中 "universal reference" 仍广泛使用
- **可信度**：高 — WG21 论文 N4164 记录了这一历史
- **来源**：[N4164: Forwarding References](https://wg21.link/n4164) | [Eric Niebler blog](http://ericniebler.com/2013/08/07/universal-references-and-the-copy-constructo/)

### 2010–2014 — 创办 C++ and Beyond 大会（里程碑）
- 联合组织者：Herb Sutter、Andrei Alexandrescu（"Three Amigos"）
- 每年一次，限 60 人
- 3 天高强度活动（早 8 点到晚 9:30）
- 早期在西雅图附近，2014 年在德国斯图加特也举办
- **可信度**：高 — 多方确认
- **来源**：[Herb Sutter blog](https://herbsutter.com/2010/01/11/c-and-beyond-summer-2010-vote-the-date/) | [isocpp.org](https://isocpp.org/blog/2014/09/cnb-stuttgart)

### 2014 — Effective Modern C++ 出版（里程碑）
- **书名**：*Effective Modern C++: 42 Specific Ways to Improve Your Use of C++11 and C++14*
- **ISBN**：1-491-90399-6
- 他作为 C++ 作家的收官之作
- 专门面向 C++11/14 新特性的 42 条指南
- 涵盖智能指针、移动语义、lambda、并发 API
- **可信度**：高
- **来源**：[aristeia.com/books.html](https://www.aristeia.com/books.html)

### 关键事实：Meyers 从未加入 C++ 标准委员会
- 他多次自述是 C++ 的"外部观察者"
- 从未参加标准化会议
- 也从未用 C++ 开发过商业软件（仅用于实验和教学）
- **可信度**：高 — 他本人在采访中明确说明
- **来源**：[CSDN 转载自 Scott Meyers](https://blog.csdn.net/hejishan/article/details/2238777)

---

## 五、退休分水岭（2015）

### 2015 年 3 月 — Yandex 采访
- 与 Yandex（俄罗斯）进行了深度访谈
- 讨论 C++ 现状、Effective Modern C++、职业建议
- **可信度**：中高
- **来源**：[isocpp.org](https://isocpp.org/blog/2015/03/interview-with-scott-meyers-at-yandex-coder-cpp)

### 2015 年 9 月 — CppCast 采访
- CppCast 第 26 期 "Effective C++ with Scott Meyers"
- 主持人：Rob Irving & Jason Turner
- 讨论了他对 C++、书籍写作、技术的广泛看法
- 趣事：他曾在夜总会舞台上（平常演肚皮舞的地方）讲 C++ 课
- **可信度**：高
- **来源**：[CppCast Episode 26](https://isocpp.org/blog/2015/09/cppcast-episode-26-effective-cpp-with-scott-meyers)

### 2015 年 12 月 31 日 — 正式退休（重大转折点）
- **博客标题**：`} // good to go`
- 宣布从 C++ 活跃参与中退休
- 原文："I'm retiring from active involvement with the language."
- 认为 C++ 生态已经成熟——更多会议、博客、视频、播客
- "My voice is dropping out, but a great chorus will continue."
- **保留的事务**：
  - 继续处理书籍勘误
  - 保留 Effective Software Development Series 咨询编辑身份
  - 可能再做一次演讲
- **退休后的打算**："25 years of deferred activities"（25 年来积压的活动清单）
- **可信度**：高 — 博客原文
- **来源**：[} // good to go](http://scottmeyers.blogspot.com/2015/12/good-to-go.html) | [isocpp.org 转载](https://isocpp.org/blog/2015/12/good-to-go-by-scott-meyers) | [Slashdot 讨论](https://developers.slashdot.org/story/16/01/01/148259/scott-meyers-retires-from-involvement-with-c)

---

## 六、退休后期（2016–2018）

### 2016 年 4 月 — 首尔 Nexon 开发者大会
- 退休后首次公开演讲
- 地点：韩国首尔 Nexon Developers Conference
- **可信度**：中高 — 博客公告
- **来源**：[scottmeyers.blogspot.com/2016/04](http://scottmeyers.blogspot.com/2016/04/presentation-at-nexon-developers.html)

### 2016 年 11 月 — 测试帖
- 标题："Test Post -- Please Ignore"
- 无明显实质内容
- **可信度**：高 — 博客可见
- **来源**：[scottmeyers.blogspot.com/2016/11](http://scottmeyers.blogspot.com/2016/11/test-post-please-ignore.html)

### 2017 年 3 月 — DConf 2017 柏林主题演讲
- **演讲题目**："Things That Matter"
- 非 C++ 主题：45 年编程生涯中对软件开发真正重要的东西
- **可信度**：高 — 博客公告 + DConf 官网
- **来源**：[scottmeyers.blogspot.com/2017/03](http://scottmeyers.blogspot.com/2017/03/keynote-at-dconf-in-berlin-on-may-5.html) | [DConf 2017](https://dconf.org/2017/talks/meyers.html)

### 2017 年 9 月 — CppCon 2017 最后一次公开亮相
- 参加 "Trainers Panel I" 讨论（技术培训专题）
- 同期签名售书
- 这是他最后一次以 C++ 相关身份公开亮相
- 30 年培训经验：「Together, we've probably indoctrinated many thousands of developers」
- **可信度**：高
- **来源**：[Brief Appearance at CppCon](http://scottmeyers.blogspot.com/2017/09/brief-appearance-at-cppcon.html) | [CppCon 2017 Schedule](https://cppcon2017.sched.com/2017-09-25/overview/event/BgtK/unicode-strings-why-the-implementation-matters)

### 2018 年 6 月 16 日 — 博客最后一次更新
- **标题**："Minor Change to Blog Charter"
- 将博客描述从 "Scott Meyers' Professional Activities and Interests" 改为 "Scott Meyers' Activities and Interests"
- 移除 "Professional" 一词，理论上允许更广泛的写作
- 实际内容：承认 no plans to blog about anything dramatic（没计划写任何大事）
- **这是博客的最后一篇帖子**
- **可信度**：高
- **来源**：[Minor Change to Blog Charter](http://scottmeyers.blogspot.com/2018/06/minor-change-to-blog-charter.html)

---

## 七、近期动态（2019–2026）

### 2019–2026：完全从公共视野隐退
- 经多轮搜索，**未发现 2019 年至今**的任何公开活动：
  - 无新博客文章
  - 无会议演讲
  - 无采访
  - 无社交媒体更新
  - 无 StackOverflow 账号活动
  - 无 GitHub 代码贡献
- 他的个人网站 [aristeia.com](http://www.aristeia.com) 仍然在线，但内容未更新
- 博客访问仍然可用，但无新内容

### 书籍状态
- 所有书籍（Effective C++、More Effective C++、Effective STL、Effective Modern C++）仍在印刷
- 中文版由侯捷等译者翻译，持续销售
- 无新版本计划信息
- `-Weffc++` GCC 标志仍存在于 GCC 中，但已被标记为 legacy

### 2020+ 搜索结论
- **无证据**显示他 2020 年后以任何身份公开活动
- 搜索尝试过：WebSearch 多轮、不同关键词组合、中英文搜索
- 他似乎彻底完成了从 C++ 世界的退出

---

## 八、关键里程碑总览

```
1959   出生
1971   开始编程
1972   开始教编程
1983   Stanford BS/MS
1987   Brown Sc.M.
1986/88 开始学习 C++
1990   首篇 C++ 学术论文
1993   Brown 计算机科学 PhD
       ────
1992   Effective C++ 第 1 版
1995   More Effective C++
1998   Effective C++ 第 2 版
1999   Effective C++ CD
1999   GCC -Weffc++ 标志引入
2001   Effective STL
2001-02  The C++ Seminar 创办
2002   Addison-Wesley ESDS 咨询编辑
2004   博客 "The View from Aristeia" 开始活跃
2005   Effective C++ 第 3 版（最终版）
2006   反对白板面试
2009   Dr. Dobb's Excellence in Programming 奖
2010   C++11 培训材料 + 嵌入式培训材料
2010   提出 "Universal References" 术语
2010-14 C++ and Beyond 大会
2014   Effective Modern C++（最后一本书）
       ──── 退休分水岭 ────
2015/12/31 正式退休 ("} // good to go")
2016/04  首尔 Nexon 演讲
2017/05  DConf 柏林主题演讲
2017/09  CppCon 2017 最后一次公开亮相
2018/06  博客最后一次更新
2019-26  完全隐退，无公开活动
```

---

## 九、来源汇总

| 来源 | URL | 主要用途 |
|------|-----|---------|
| Wikipedia | https://en.wikipedia.org/wiki/Scott_Meyers | 基本生平、出版物、退休 |
| Brown University PhD | https://cs.brown.edu/research/pubs/techreports/reports/CS-93-12.html | 博士论文信息 |
| Scott Meyers 网站 | https://www.aristeia.com/ | 出版物、演讲列表 |
| Scott Meyers 博客 | http://scottmeyers.blogspot.com/ | 退休文、活动公告、博客存档 |
| isocpp.org | https://isocpp.org/blog/2015/12/good-to-go-by-scott-meyers | 退休文镜像 |
| Dr. Dobb's 2009 奖 | https://drdobbs.com/cpp/dr-dobbs-2009-excellence-in-programming/215900307 | 获奖详情 |
| GCC -Weffc++ 历史 | https://gcc.gnu.org/legacy-ml/gcc/1999-08n/msg00996.html | 编译器标志起源 |
| DConf 2017 | https://dconf.org/2017/talks/meyers.html | 退休后演讲信息 |
| CppCon 2017 | https://cppcon2017.sched.com/ | 最后公开亮相 |
| N4164 论文 | https://wg21.link/n4164 | Universal References 术语起源 |
| Eric Niebler | http://ericniebler.com/2013/08/07/universal-references-and-the-copy-constructo/ | 术语背景 |
| CppCast | https://isocpp.org/blog/2015/09/cppcast-episode-26-effective-cpp-with-scott-meyers | 2015 采访 |
| O'Reilly | https://www.oreilly.com/pub/au/6152 | 作者简介 |
| Artima | https://www.artima.com/ | 培训材料、采访 |
| Effective Software Dev Series | http://scottmeyers.blogspot.com/2002/03/effective-software-development-series.html | 2002 年系列创立 |

### 可信度评级说明
- **高**：原始来源（博客原文、论文、官方会议网站、存档资料），多源交叉验证
- **中高**：可靠转载，或原始来源但时间久远
- **中**：单一来源、自述回忆、或二手转载
- **低**：未采用

---

## 十、附注

1. **Meyers 最重要的自我定位**：他是 C++ 的"教育者"和"解释者"，而非语言设计者或商业软件开发者。这一定位贯穿其整个职业生涯。
2. **退休具有彻底性**：与很多技术名人"退休后又回来"不同，Meyers 的退休执行得很彻底——2018 年后零公开活动。
3. **持续影响力**：虽然不再活跃，Effective C++ 系列仍被广泛使用，`-Weffc++` 仍在 GCC 中存在，术语 "universal references" 仍被社区沿用。
4. **唯一一次"复出"**：2017 年 CppCon 的 panel 讨论是他退休后唯一的 C++ 社区正式亮相，但他明确表示这只是一次性安排。
