# 01 — Scott Meyers: 著作与系统思考调研

> 调研日期：2026-05-24
> 调研目标：全面了解 Scott Meyers 的出版著作、博客/长文、核心论点、自创术语、推荐书单/受影响来源，以及退休公告

---

## 一、出版的书籍

### 1.1 Effective C++ 系列

#### 《Effective C++》（第一版，1992 年）
- **副标题：** 50 Specific Ways to Improve Your Programs and Designs
- **核心论点：** C++ 编程的 50 条实用规则。奠定了 "Item" 式写作体裁——每条约 4-5 页的短篇技术短文，标题用祈使句给出直接建议。
- **版本覆盖：** 面向 C++ 2.0（标准化前），涵盖 C with Classes 到早期模板。
- **来源：** aristeia.com/books.html（一手）
- **可信度：** 一手

#### 《Effective C++》（第二版，1998 年）
- **副标题：** 50 Specific Ways to Improve Your Programs and Designs（不变）
- **主要变化：** 更新以匹配 1998 ANSI/ISO C++ 标准。新增了对 STL、异常安全、RTTI 等标准化特性的覆盖。
- **来源：** aristeia.com/books.html（一手）
- **可信度：** 一手

#### 《Effective C++》（第三版，2005 年）
- **副标题：** 55 Specific Ways to Improve Your Programs and Designs
- **核心变化：** 从 50 条扩展到 55 条。新增 5 条关于 TR1 和 Boost 的内容。引入了章节末的 "Things to Remember" 要点总结（三点式 bullet list）。
- **核心论点：**
  - "View C++ as a federation of languages"（Item 1）——C++ 是四个子语言的联合：C、面向对象 C++、模板 C++ (TMP)、STL
  - "Make interfaces easy to use correctly and hard to use incorrectly"（Item 18）—— 他最著名的设计指南
  - "Treat class design as type design"（Item 19）
  - "Use objects to manage resources"（Item 13）—— RAII 核心原则
  - "Prefer pass-by-reference-to-const to pass-by-value"（Item 20）
  - "Prefer non-member non-friend functions to member functions"（Item 23）—— 封装性论战
- **来源：** aristeia.com/books.html，Pearson 出版社页面（一手）
- **可信度：** 一手

---

#### 《More Effective C++》（1996 年）
- **副标题：** 35 New Ways to Improve Your Programs and Designs
- **核心内容：** Effective C++ 的配套书，涵盖异常处理、效率优化、智能指针、代理类、双重分派等高级主题。
- **关键议题：**
  - 引用计数（reference counting）
  - 智能指针（smart pointers）
  - 代理类（proxy classes）
  - 双重分派（double dispatching）
  - 异常安全（exception safety）
  - 虚拟构造函数（virtual constructors）
- **来源：** aristeia.com/books.html（一手）
- **可信度：** 一手

---

#### 《Effective STL》（2001 年）
- **副标题：** 50 Specific Ways to Improve Your Use of the Standard Template Library
- **核心论点：**
  - 拥抱抽象但要尊重差异——容器设计意图不同，不要写容器无关代码
  - 优先使用 STL 算法而非手写循环（原因：词汇能力、标准化、专家优化）
  - "The different containers are different"——它们不是设计成可互换的
  - 解决方案：用 `typedef` 封装容器选择，用自定义类隐藏容器
- **核心内容领域：** 容器选择、算法 vs 成员函数、迭代器陷阱、函数对象、分配器、可移植性
- **来源：** aristeia.com/books.html（一手）
- **可信度：** 一手

---

#### 《Effective Modern C++》（2014 年）
- **副标题：** 42 Specific Ways to Improve Your Use of C++11 and C++14
- **核心内容：** C++11/14 新特性的 42 条使用指南，包括：
  - 类型推导（template type deduction, auto, decltype, Item 1-4）
  - auto（Item 5-6）
  - 移动语义和完美转发（Item 23-30）
  - 智能指针（unique_ptr, shared_ptr, weak_ptr, Item 18-22）
  - Lambda 表达式（Item 31-34）
  - 并发 API（Item 35-40）
  - 左值/右值/通用引用区分（Item 23-28）
- **核心新论点：**
  - "Prefer `auto` to explicit type declarations"（Item 5）
  - "Prefer `const_iterators` to `iterators`"（Item 13）
  - "Use `std::make_unique` and `std::make_shared`"（Item 21）
  - "Understand `std::move` and `std::forward`"（Item 23）
  - "Consider emplacement instead of insertion"（Item 42）
- **几个矛盾/争议点：**
  - Meyers 在书中称 `auto&&` 推导的 T&& 为 "universal reference"，但 C++ 标准委员会后来正式采用 "forwarding reference" 这个术语，认为 "universal reference" 误导（N4164 提案）。Meyers 本人最初也使用 "forwarding reference" 但后来偏好 "universal reference"。
- **来源：** aristeia.com/books.html，O'Reilly Media（一手）
- **可信度：** 一手

---

### 1.2 参与的其他书籍

- **《Overview of The New C++ (C++11)》**（2010 年）—— 培训教材，类似启蒙读物，不是正式出版的书籍。来源：aristeia.com（一手）
- **《Effective C++ Digital Collection: 140 Ways to Improve Your Programming》**（2012 年）—— 将三本核心书捆绑成的电子版合集，没有新内容。来源：aristeia.com（一手）

### 1.3 系列编辑工作

- **Addison-Wesley Effective Software Development Series（创始人和咨询编辑）**
  - 2002 年宣布担任这一新系列的 Consulting Editor
  - 在此之前已为 Addison-Wesley 审稿超过十年
  - 知名系列图书包括 Andrei Alexandrescu 的 *Modern C++ Design*、Diomidis Spinellis 的 *Code Quality* 等
  - 系列原则：专家建议、可操作、技术坚实、持久价值、300-400 页
  - 来源：aristeia.com/ESDS/ESDS_overview.pdf，scottmeyers.blogspot.com/2002/03（一手）

---

## 二、博客/长文

### 2.1 博客平台

- **"The View from Aristeia"** 最初在 aristeia.com，后迁移至 scottmeyers.blogspot.com
- 内容频率较低，主要为发布更新、勘误、会议通知；但也有少量深度技术博文
- 活跃时段：1999-2015 年
- 来源：scottmeyers.blogspot.com（一手）

### 2.2 关键技术博文

| 日期 | 标题 | 内容 | 来源 |
|------|------|------|------|
| 2004-06 | "New article in the current DDJ" | 宣布 Double-Checked Locking 文章 | scottmeyers.blogspot.com（一手） |
| 2004-08 | "Request for comments on extended..." | 对 "Make interfaces easy to use correctly" 的扩展征集社区意见 | scottmeyers.blogspot.com（一手） |
| 2004-10 | "Double-Checked Locking article now online" | 宣布 PDF 版上线 | scottmeyers.blogspot.com（一手） |
| 2013-01 | "Effective Effective Books" | 他给作者的 12 条写作指南，详细阐述了 Item 标题用词选择策略 | scottmeyers.blogspot.com（一手） |
| 2014-03 | "A Concern about the Rule of Zero" | 对 Rule of Zero 的保留意见——建议用显式 `= default` 而非省略声明 | scottmeyers.blogspot.com（一手） |
| 2014-06 | "Five New Videos" | 宣布 5 个 CppCon 培训视频上线 | scottmeyers.blogspot.com（一手） |
| 2014-06 | "Another New Video" | "Why C++ Sails When the Vasa Sank" 演讲 | scottmeyers.blogspot.com（一手） |
| 2014-12 | "The Evolving Search for Effective C++" | Meeting C++ 2014 主题演讲视频；涵盖 emplacement vs. insertion 指南的演化 + 技术信息传播的思考 | scottmeyers.blogspot.com（一手） |
| 2015-09 | "Interview with me on CppCast" | CppCast 播客第 26 集 | scottmeyers.blogspot.com（一手） |
| 2015-12 | "} // good to go" | **退休公告** | scottmeyers.blogspot.com（一手） |

### 2.3 深度长文/文章

| 年份 | 标题 | 出处 | 说明 |
|------|------|------|------|
| 1996 | "Counting Objects in C++" | C/C++ Users Journal 4月 | 统计对象创建/销毁 |
| 1996 | "Combining C++ and C in the Same Program" | C/C++ Users Journal 10月 | C/C++ 混编指南 |
| 1996 | "Smart Pointers" 系列 | C++ Report 4-11月 | 多篇连载 |
| 1996 | "Refinements to Smart Pointers" | C++ Report 11-12月 | 智能指针进阶 |
| 1999 | "Implementing operator->\* for Smart Pointers" | Dr. Dobb's Journal 10月 | PDF 仍可从 aristeia.com 下载 |
| 2000 | "How Non-Member Functions Improve Encapsulation" | C/C++ Users Journal 2月 | 著名的封装性论战，被广泛引用 |
| 2000 | "Three Guidelines for Effective Iterator Usage" | C/C++ Users Journal 6月 | STL 迭代器指南 |
| 2001 | "STL Algorithms vs. Hand-Written Loops" | C/C++ Users Journal 10月 | 倡导用算法替代手写循环 |
| 2001 | "Distinguishing STL Search Algorithms" | C/C++ Users Journal 12月 | 区分不同搜索算法 |
| 2002 | "Class Template, Member Template — or Both?" | C/C++ Users Journal 11月 | 模板设计选择 |
| 2004 | "The Most Important Design Guideline?" | IEEE Software 7-8月 | "Make interfaces easy to use correctly and hard to use incorrectly" 的正式版本 |
| 2004 | "C++ and the Perils of Double-Checked Locking"（与 Andrei Alexandrescu 合著）| Dr. Dobb's Journal 7-8月 | 两期连载，DCLP 不可移植的关键证据 |
| 2006 | "A Pause to Reflect: Five Lists of Five" 系列（5篇） | artima.com C++ Source | C++ 5x5 系列：最伟大的书、文献、软件、人物、Aha! 时刻 |

来源：aristeia.com/publications.html（一手）

### 2.4 C++ 5x5 系列详细内容

Part I — **The Most Important C++ Books...Ever**（2006-08-09）
1. *The C++ Programming Language* — Bjarne Stroustrup（1985/1986）
2. *Effective C++* — Scott Meyers（1992）
3. *Design Patterns* — GoF（1995）
4. *International Standard for C++* — ISO/IEC（1998/2003）
5. *Modern C++ Design* — Andrei Alexandrescu（2001）

Part II — **The Most Important C++ Non-Book Publications...Ever**（2006-08-16）
1. "Programming in C++, Rules and Recommendations" — Mats Henricson & Erik Nyquist（1992）
2. "Exception Handling: A False Sense of Security" — Tom Cargill（1994）
3. "Curiously Recurring Template Patterns" — Jim Coplien（1995）—— 命名了 CRTP
4. "Using C++ Template Metaprograms" — Todd Veldhuizen（1995）—— 模板元编程首次公开亮相
5. "Exception-Safety in Generic Components" — David Abrahams（1997/1998）—— 异常安全三级保证

Part III — **The Most Important C++ Software...Ever**（2006-08-23）
1. Cfront（AT&T, 1985-1993）—— 第一个 C++ 编译器
2. GCC/g++（GNU, 1987-至今）—— 第一个直接生成本地代码的 C++ 编译器
3. Visual C++（Microsoft, 1992-至今）—— Meyers 点评："既是 C++ 成功的重要原因，也是阻碍其发展的最强大力量之一"（尤指 VC6 长期标准兼容性差）
4. STL（HP, 1993-至今）—— "在我近 30 年的编程生涯中，从未见过像 STL 这样的东西"
5. Boost（1999-至今）—— TR1 中 14 个新功能有 10 个基于 Boost

Part IV — **The Most Important C++ People...Ever**（2006-08-30）
1. Bjarne Stroustrup（1985-至今）
2. Andrew Koenig（1988-至今）
3. Scott Meyers（1991-至今）—— 将自己列入名单
4. Herb Sutter（1997-至今）
5. Andrei Alexandrescu（1998-至今）

Part V — **My Most Important C++ Aha! Moments...Ever**（2006-09-06）
1. 发现 C++ 特殊成员函数可以声明为 `private`（1988）
2. 理解 Barton & Nackman 量纲分析中的非类型模板参数（1995）
3. 理解 Visitor 模式解决的真正问题（1996/1997）
4. 理解为什么 `remove` 并不真正删除元素（1998）
5. 理解 Boost `shared_ptr` 中的 deleter 类型擦除机制（2004）

来源：artima.com（一手）；CSDN 中文翻译（二手）

---

## 三、反复出现的核心论点（"真信念"）

### 3.1 跨书/文章出现 >=3 次的核心论点

| 核心论点 | 出处 | 出现次数 |
|---------|------|---------|
| **"Make interfaces easy to use correctly and hard to use incorrectly"** | Effective C++ Item 18；IEEE Software 2004 文章；DDJ 文章；Boost 邮件列表引用 | >=5 |
| **"Use objects to manage resources" (RAII)** | Effective C++ Item 13；More Effective C++；Effective Modern C++ Item 21 | >=4 |
| **"Prefer non-member non-friend functions to member functions"** | Effective C++ Item 23；2000 年 C/C++ Users Journal 文章；Boost 列表讨论 | >=3 |
| **"View C++ as a federation of languages"** | Effective C++ 3/e Item 1；多次演讲中反复强调 | >=4 |
| **"Prefer pass-by-reference-to-const to pass-by-value"** | Effective C++ Item 20；More Effective C++；在各类演讲中被提及 | >=4 |
| **"Prefer algorithms to hand-written loops"** | Effective STL Item 43；C/C++ Users Journal 2001 文章 | >=3 |
| **Exception safety guarantees (basic/strong/nothrow)** | More Effective C++ Item 9；Effective C++ Item 29；推广了 Abrahams 的分类 | >=3 |
| **"Know what functions C++ silently writes and calls"** | Effective C++ Item 5；大量演讲和培训中出现 | >=3 |
| **"Treat class design as type design"** | Effective C++ Item 19；各类演讲 | >=3 |
| **"Consider emplacement instead of insertion"** | Effective Modern C++ Item 42；2014 Meeting C++ 主题演讲深入讨论 | >=3 |

### 3.2 对 C++ 各版本演进的看法

- **C++98/03：** Meyers 的核心战场。他的前三本书都是针对这个时期。他认为 C++ 标准化使语言走向成熟，但异常安全和模板元编程等关键思想当时刚被社区理解。
- **C++11/14：** 他认为这是 C++ 的复兴（"Why C++ Sails When the Vasa Sank" 演讲的核心论点）。新特性让日常代码更简单，尽管标准本身更厚了。他从 2010 年就开始培训 C++11 内容。
- **C++17 及以后：** Meyers 在 2014 年出版《Effective Modern C++》后没有为 C++17 出版新书。他关注 C++ 标准委员会专注于新特性而非修复已存在的问题（在 "The Last Thing D Needs" 演讲中提到）。
- **他的核心矛盾：** C++ 变得更复杂（标准从 453 页的 ARM 到 ~1370 页的 C++14），但大多数复杂性对大多数用户隐藏了一一"简化是以增加复杂性为代价的"。

来源：多篇演讲和访谈的综合整理（一手为主）

---

## 四、自创术语或推广的术语

### 4.1 "Universal Reference"（通用引用）
- **发明时间：** 2012 年文章 "Universal References in C++11"（Overload 111 期）
- **描述：** `T&&` 在类型推导上下文中的特殊行为——既可以绑定左值也可以绑定右值
- **标准委员会回应：** 官方采用 "forwarding reference"（N4164 提案），认为 "universal" 可能鼓励过度使用
- **来源：** Overload 111 期，Effective Modern C++ Item 24（一手）；N4164（一手）
- **争议：** Meyers 认为 "forwarding reference" 不能涵盖 `auto&&` 场景，仍偏好自己的术语

### 4.2 推广但不一定发明的术语

| 术语 | 与 Meyers 的关系 | 说明 |
|------|-----------------|------|
| **RAII**（Resource Acquisition Is Initialization） | 强力推广者 | 由 Bjarne Stroustrup 和 Andrew Koenig 发明，Meyers 的 Effective C++ 系列使其成为 C++ 最核心的编程范式之一 |
| **Rule of Three**（三法则） | 推广者 | 经典 C++98 规则：如果自定义析构函数、拷贝构造函数、拷贝赋值运算符中的任何一个，就要定义全部三个 |
| **Rule of Five**（五法则） | 关键推广者 | 在 Effective Modern C++ 中详述 C++11 的扩展版本，添加移动构造函数和移动赋值运算符 |
| **Rule of Zero**（零法则） | 批评者 | Meyers 2014 年博文 "A Concern about the Rule of Zero" 主张用显式 `= default` 来表达意图 |
| **copy-and-swap** | 推广者 | 在 Effective C++（Item 11、29）和 More Effective C++ 中详细讲解 |
| **Pimpl Idiom**（Pointer to Implementation） | 推广者 | Effective C++ Item 31 "Minimize compilation dependencies between files" |
| **NVI (Non-Virtual Interface) Idiom** | 推广者 | Effective C++ Item 35 |

### 4.3 他自创的写作术语

- **"Item" 式写作体裁：** 每条约 4-5 页的独立技术短文，标题用祈使句
- **"Things to Remember"：** 章节末尾的三点式要点总结，从 3/e 开始引入
- **"The Stridency Scale"：** Always → Prefer → Consider → Avoid → Never 的劝诫力度谱系
  - 来源：scottmeyers.blogspot.com/2013/01（一手）

---

## 五、他推荐的书单或受影响的来源

### 5.1 直接影响他的人

- **Bjarne Stroustrup** —— C++ 之父，Meyers 的整个职业生涯都在诠释 Stroustrup 设计的语言
- **Andrei Alexandrescu** —— 合著者（Double-Checked Locking 论文），被 Meyers 评价为模板编程的革命者
- **Herb Sutter** —— 标准化委员会主席，与 Meyers 并列为 C++ 社区最著名的两位作者
- **Andrew Koenig** —— 标准化委员会关键成员，"Koenig Lookup" 命名来源
- **David Abrahams** —— 异常安全三级保证的提出者，被 Meyers 推广

### 5.2 直接影响他的出版物

1. **"Exception Handling: A False Sense of Security" — Tom Cargill（1994）** —— 挑战 C++ 社区做出异常安全的 stack 类，激发了 Meyers 关于异常安全的写作
2. **"Curiously Recurring Template Patterns" — Jim Coplien（1995）** —— 命名了 CRTP，Meyers 称其为最重要的模板模式之一
3. **"Using C++ Template Metaprograms" — Todd Veldhuizen（1995）**
4. **"Exception-Safety in Generic Components" — David Abrahams（1997/1998）**
5. **Modern C++ Design — Andrei Alexandrescu（2001）** —— Meyers 将其列为第五大最重要的 C++ 书籍

### 5.3 他受影响的来源（背景）

- **博士研究（Brown University, 1993）：** 方向为多视图开发环境（multiple-view development environments），博士论文《Representing Software Systems in Multiple-View Development Environments》。提出 Semantic Program Graphs (SPGs)。这与 C++ 无关，但塑造了他系统化思考复杂系统的能力。
- **IEEE 论文 "Difficulties in Integrating Multiview Development Systems"（1991）** —— 早于他的 C++ 著作，反映了他对集成复杂系统的方法论思考。
- **他的导师：** Steven P. Reiss（Brown University），合著关于维护面向对象程序的论文（1992）。

来源：aristeia.com（一手）；Brown University CS 论文库（一手）

---

## 六、退休公告（2015 年 12 月 31 日）

### 6.1 公告内容

Scott Meyers 在博文 **"} // good to go"** 中宣布退出 C++ 的积极参与。

### 6.2 25 年职业生涯回顾

- **6 本书**（包括 Effective C++ 系列）
- **超过 4 打**（48+）在线视频
- **约 80 篇**文章、访谈和学术论文
- 无数的博客文章、Usenet 帖子和 StackOverflow 贡献

### 6.3 宣布的后续安排（"mostly retirement"）

- 继续处理书的勘误
- 继续担任 **Effective Software Development Series**（Addison-Wesley）的 Consulting Editor
- 可能再讲一次课

### 6.4 退休理由

> "My job is explaining C++ and how to use it, but the C++ explanation biz is bustling. The conference scene is richer and more accessible than ever before... My voice is dropping out, but a great chorus will continue."

他认为 C++ 生态系统已经足够繁荣和自给自足，不需要他继续做主要的解释者。他也想追求 25 年来被搁置的其他兴趣。

### 6.5 来源

- 原博文：scottmeyers.blogspot.com/2015/12/good-to-go.html（一手，可通过 Wayback Machine 访问）
- 转帖：isocpp.org/blog/2015/12/good-to-go-by-scott-meyers（一手）
- **可信度：** 一手

---

## 七、矛盾记录

以下为搜索中发现的直接矛盾，未做调和：

1. **"Universal reference" vs "Forwarding reference"**
   - Meyers 坚持称 `T&&`（类型推导上下文中）为 "universal reference"
   - C++ 标准委员会（通过 N4164）正式采用 "forwarding reference"，认为 "universal" 误导
   - 矛盾点：Meyers 认为 "forwarding" 不能涵盖 `auto&&`；委员会认为 "universal" 暗示过度适用
   - 来源：Effective Modern C++（一手）vs N4164 提案（一手）

2. **Rule of Zero 的争论**
   - 社区（以 Martinho Fernandes 为代表）主张 Rule of Zero：让 RAII 成员自动管理资源，不声明任何特殊成员函数
   - Meyers 在 2014 年博文中表达担忧，主张显式 `= default` 声明所有五个特殊成员函数
   - 矛盾点：省略 vs 显式，哪个更安全、更可维护
   - 来源：scottmeyers.blogspot.com/2014/03（一手）

3. **Aha! Moment #1 的时间线模糊性**
   - Meyers 在 2006 年称 1988 年发现将拷贝构造/赋值声明为 `private` 可防止拷贝
   - 但他的第一本 Effective C++ 1992 年才出版
   - 这之间 4 年的 gap 没有在资料中说明

4. **C++ 复杂度的评价两极化**
   - 在 "Why C++ Sails When the Vasa Sank" 中，他强调复杂度是可控的、隐藏的，C++ 因灵活性而成功
   - 在 "The Last Thing D Needs"（DConf 2014）中，他用 C++ 的各种不一致性作为反面教材，建议 D 语言避免同样的错误
   - 矛盾点：C++ 的复杂度究竟是"可管理的成熟"还是"设计失误的积累"？Meyers 在两个演讲中立场不同（至少表面上是）

5. **他对自己书的定位**
   - 在 C++ 5x5 Part I 中，他将自己的书排在第二位（仅次于 Stroustrup 的《The C++ Programming Language》）
   - 但他也清醒地承认：需要 55 条/50 条规则的语言本身就有问题（"maybe a language that needs 55 rules is irredeemably broken" 一类的自嘲常在演讲中出现）

---

## 八、来源汇总

### 一手来源（Scott Meyers 自己写的/说的）

| 来源 | URL |
|------|-----|
| 个人网站 | aristeia.com |
| 书籍页面 | aristeia.com/books.html |
| 出版物列表 | aristeia.com/publications.html |
| 演讲历史 | aristeia.com/presentations.html |
| 博客 | scottmeyers.blogspot.com |
| 退休公告 | scottmeyers.blogspot.com/2015/12/good-to-go.html |
| Effective Effective Books | scottmeyers.blogspot.com/2013/01 |
| Rule of Zero 担忧 | scottmeyers.blogspot.com/2014/03 |
| Yandex 访谈纪要 | aristeia.com/TalkNotes/InterviewwithScottMeyersatYandex.pdf |
| Dr. Dobb's 文章 PDF | aristeia.com/Papers/DDJ_Jul_Aug_2004_revised.pdf |
| IEEE 设计指南 | aristeia.com/Papers/IEEE_Software_JulAug_2004_revised.htm |
| C++ 5x5 Part I (Books) | artima.com/articles/the-most-important-c-booksemeverem |
| C++ 5x5 Part II (Non-Book) | artima.com/articles/the-most-important-c-non-book-publicationsemeverem |
| C++ 5x5 Part III (Software) | artima.com/cppsource/top_cpp_software.html |
| C++ 5x5 Part IV (People) | artima.com/articles/the-most-important-c-peopleemeverem |
| C++ 5x5 Part V (Aha!) | artima.com/cppsource/top_cpp_aha_moments.html |
| Ph.D. 论文 | cs.brown.edu（meyers.pdf） |
| CppCast 访谈 | podscripts.co/podcasts/cppcast/effective-c |

### 二手来源（社区、总结、转载）

| 来源 | 说明 |
|------|------|
| isocpp.org/blog | 官方 C++ 基金会转载 |
| CSDN 中文翻译 | C++ 5x5 系列中文翻译（需谨慎，可能有翻译偏差） |
| kunigami.github.io | Effective C++ / Effective Modern C++ 总结笔记 |
| git.io 各类笔记 | GitHub 上的读书笔记 |
| Wikipedia (Scott Meyers) | 百科总结，基本准确 |

### 黑名单提醒
- 本调研已排除：知乎、微信公众号、百度百科

---

## 附录：关于 "Make interfaces easy to use correctly and hard to use incorrectly" 的深度记录

这是 Meyers 最著名的设计指南，几乎在所有作品中出现：

- **首次正式出版：** IEEE Software, July/August 2004 — "The Most Important Design Guideline?"
- **书籍收录：** Effective C++ 3/e, Item 18（2005）
- **社区影响：** 被 Boost 社区、C++ Core Guidelines（I.1-I.26）、以及无数 CppCon/C++Now 演讲引用
- **核心实现技术：**
  1. 引入新类型（而非用原始类型）—— 用 `Day`、`Month`、`Year` 而非 `int`
  2. 限制合法值 —— 用私有构造函数 + 静态常量
  3. 消除资源管理负担 —— 返回智能指针而非原始指针
  4. 提供一致的接口 —— 匹配内建类型和标准库的行为约定
  5. 正确使用 `const`
- **来源：** aristeia.com/Papers/IEEE_Software_JulAug_2004_revised.htm（一手）

---

> 本文件是 "Agent 1/6 — 著作与系统思考" 调研的输出。后续 Agent 将以此为基础构建人物 Skill。
