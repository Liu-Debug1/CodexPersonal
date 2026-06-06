# 04 — 他者视角：同行评价 / 社区评价 / 批评争议

> 本文档系统梳理 C++ 社区内外对 Bjarne Stroustrup 的评价、批评与对比分析。
> 每条信息标注来源 URL 和可信度（高/中/低）。
> 用于 Bjarne Stroustrup 视角 Skill 构建，确保立场平衡、信息可追溯。

---

## 一、同行评价（Peer Reviews）

### 1.1 Scott Meyers：C++ 历史上最重要的人

**来源**：Artima — "The Most Important C++ People...Ever" (2006)
**URL**：https://www.artima.com/articles/the-most-important-c-peopleemeverem
**可信度**：高 — Scott Meyers 本人撰写

Scott Meyers 在评选"C++ 历史上最重要的人"时，不假思索地将 Stroustrup 排在了首位：

> "Well, duh. He invented the language, he wrote the first compiler for it, he's published extensively about it, he's been actively involved in its dissemination and standardization, and he continues to work with it to this day. [...] Stroustrup could have retired from C++ activities years ago and settled back to bask in the breathless accolades to which all successful inventors are entitled. That he has instead chosen to continue working on the research project he began nearly 30 years ago is a tribute to his dedication to what is now C++."

**Meyers 对 Stroustrup 的定位**：创造者与终身守护者。Meyers 的角色是"地图绘制者"——他不设计语言，而是教开发者如何正确使用它。两人的关系被总结为：*"Bjarne Stroustrup created the C++ universe; Scott Meyers drew the map of that universe."*

**Meyers 引用的 Stroustrup 名言**：
- 1992 年标准化期间的警告：*"C++ is already too large and complicated for our taste... Remember the Vasa!"*（Vasa 号是 17 世纪瑞典战舰，首航即因设计不稳定沉没——比喻项目被自身复杂度压垮。）
- 1996 年回顾：*"So far, C++ has escaped the fate of the Vasa; it has not keeled over and disappeared – despite much wishful thinking and many dire predictions."*

**来源**：Scott Meyers 演讲 "Why C++ Sails When the Vasa Sank" (2013)
**URL**：https://www.slideshare.net/slideshow/why-c-sails-when-the-vasa-sank/36102421
**可信度**：高 — 公开演讲

Meyers 认为 C++ 能避免 Vasa 号命运的四项关键因素：与 C 的兼容、高度通用的特性、范式无关性、以及系统级编程的承诺。

---

### 1.2 Herb Sutter：标准化进程的长期搭档

**来源**：Herb Sutter 博客 — "Stroustrup & Sutter on C++: The Interviews" (2008)
**URL**：https://herbsutter.com/2008/06/10/stroustrup-sutter-on-c-the-interviews/
**可信度**：高 — Sutter 本人发布

作为 C++ 标准委员会主席（自 2002 年起至今），Herb Sutter 与 Stroustrup 在标准化进程中密切合作了二十多年。关键观察：

- Sutter 在 2012 年 C++ and Beyond 大会上用"Modern C++ = Clean, Safe, and Faster Than Ever"定义现代 C++，Stroustrup 本人坚持要求加上"when used in a modern style"修饰语 —— 这体现了两人的微妙关系：Sutter 偏向激进推广，Stroustrup 更谨慎务实。
- Sutter 在"官方"叙事中常被描述为 Stroustrup 的"长期合作伙伴"，两人共同发布过多次方向性文章和演讲。

**来源**：GoingNative 2013 大会公告
**URL**：https://isocpp.org/blog/2013/06/c-fest-goingnative-2013-announced-sep-4-6-redmond-wa-usa
**可信度**：中 — 会议公告

---

### 1.3 Andrew Koenig：第二重要的人

**来源**：ISO C++ 博客 — "C++: as close as possible to C -- but no closer" (A. Koenig 与 B. Stroustrup 联合文章)
**URL**：https://isocpp.org/blog/2014/10/from-the-archives-c-as-close-as-possible-to-c-but-no-closer-a.-koenig-and-b
**可信度**：高 — 联合署名

Andrew Koenig 是 Stroustrup 在贝尔实验室的亲密同事和密友：
- 被描述为 Stroustrup "*inner circle*" 的核心成员，也是 C++ 发展史上"第二重要的人"
- 两人共同提交了 C++ 模板的第一个正式提案（1988 年）
- Koenig 担任 ANSI/ISO C++ 标准委员会的项目编辑，是标准正文格式和内容的最终仲裁者
- 两人的设计思想高度一致 —— 这是 C++ 能在早期保持方向一致的关键
- Stroustrup 出席了 Koenig 与 Barbara E. Moo 的婚礼（1998 年），说明关系远超同事

---

### 1.4 Andrei Alexandrescu：模板元编程先锋

**来源**：C++ In-Depth 书系合作
**URL**：https://openlibrary.org/works/OL19859732W/C_in-depth
**可信度**：中 — 书籍出版信息

Alexandrescu（《Modern C++ Design》作者）与 Stroustrup 在 "C++ In-Depth" 书系中有合作。Alexandrescu 将模板元编程推向极致，而 Stroustrup 创造了模板这一基础机制。两人在通用编程（generic programming）方向上互补。

---

### 1.5 Sean Parent：Adobe 的 C++ 工程领袖

相关搜索未找到 Sean Parent 对 Stroustrup 的直接公开评价。Parent 以 C++ 并发和算法方面的演讲闻名（"Better Code" 系列），但与 Stroustrup 的公开互动较少。

---

### 1.6 学术界评价

**来源**：National Academy of Engineering — 当选认证 (2004)
**URL**：https://www.nae.edu/177032/Dr-Bjarne-Stroustrup
**可信度**：高 — 官方机构

> "C++ revolutionized the software industry by enabling a variety of software development techniques, including object-oriented programming, generic programming, and general resource management, to be deployed at industrial scale."

**来源**：Texas A&M University / UC3M 荣誉博士颂词
**URL**：https://www.uc3m.es/about-uc3m/honoris-causa/professor-bjarne-stroustrup/laudiato
**可信度**：高

> "It is unusual to find personal profiles with a deep impact at both sides of that divide [academia and industry], as Professor Stroustrup has done... His academic publication record is stellar and so is his impact on many industries. This is infrequent. But what is exceptional is having done it while keeping during decades the very same long-term goal: A programming language that allows combining abstractions and developing software making efficient use of available hardware."

Stroustrup 的学术声誉核心数据：
- **Charles Stark Draper Prize** (2018) — NAE 最高荣誉，与芯片、GPS、光纤发明人同级
- **Faraday Medal** (2017) — IET 最高荣誉，之前得主包括 J.J. Thomson、Donald Knuth、Maurice Wilkes
- **AITO Dahl-Nygaard Senior Prize** (2015) — 面向对象计算领域最高奖
- **ACM Fellow** (1993) / **IEEE Fellow** (2005) / **National Academy of Engineering** (2004)
- 10 部著作、100+ 学术论文
- C++ 用户群估计 440-700 万人
- ISO C++ 标准委员会是所有 ISO 编程语言委员会中规模最大的——比所有其他语言委员会成员总和还多

---

## 二、社区评价（Community Assessment）

### 2.1 C++ 委员会的"BDFL"问题

**关键词**：BDFL（Benevolent Dictator for Life，终身仁慈独裁者）

搜索未发现 C++ 社区直接将 Stroustrup 称为"BDFL"的明确说法。这与 Python（Guido van Rossum 明确称为 BDFL）、Linux（Linus Torvalds）形成对比。原因：

- C++ 设计权在 1990 年代标准化开始后就已分散到委员会
- Stroustrup 本人多次表示，委员会时期的 C++ 不再是"一个人的语言"
- Stroustrup 的角色更像 *chief architect emeritus*（荣誉总架构师）——有巨大影响力但无最终决定权

**来源**：Stroustrup 1996 年访谈 — "设计委员会"话题
**URL**：https://stroustrup.com/italian_interview.html
**可信度**：高 — 一手来源

> "Some details of ISO C++ may show signs of 'design by committee,' but the overall set of facilities is a better match for my original view of what C++ should be than earlier versions of the language."

他同时承认：*"Naturally, my patience has been sorely tested but by and large, I'm happy with the outcome of the C++ standardization effort."*

---

### 2.2 社区对 Stroustrup 管理风格的看法

**来源**：Open Channel IEEE 访谈 (1990s)
**URL**：https://www.stroustrup.com/ieee_interview.html
**可信度**：高 — 一手来源

在 STL（标准模板库）的采纳过程中，Stroustrup 声称委员会避免了"设计委员会"陷阱：
> "By adopting STL with only minor modifications and additions, we avoided the dreaded design by committee."

**来源**：C++View 访谈 (2001)
**URL**：https://www.stroustrup.com/01chinese.html
**可信度**：高 — 一手来源

关于"C++ 标准化为何令人沮丧"：
> "Standardization is an extremely valuable, most important, largely underestimated, and most frustrating activity... Standardization is a slow process, often focussed on minute technical details, and you need to get dozens of people from many countries and from very diverse technical cultures to agree... The C++ committee is not an organization that is happy with a vote being 'won' by a 60% to 40% margin. Such a vote would be considered a failure. We aim for consensus, meaning 'almost everybody agrees' and work until we reach that."

**来源**：HOPL4 论文 (2020) — "Thriving in a Crowded and Changing World"
**URL**：https://scholar.archive.org/work/a2cafus5uvcvro2i6hl5m43h4u
**可信度**：高 — 同行评审论文

> "The ISO C++ standards committee doesn't have a generally accepted set of design criteria or set of criteria for accepting a feature. This is not for lack of trying."
> "The problem is that people find it too hard to agree on interpretation and too easy to ignore what they don't like."
> "Many are simply too certain of their opinions."

---

## 三、批评与争议（Criticisms & Controversies）

### 3.1 C++ 复杂度问题——谁的责任？

**争议焦点**：C++ 是不是太复杂了？Stroustrup 应不应为此负责？

#### 支持方（这并非 Stroustrup 的错）
- C++ 的复杂度来自三个约束：与 C 兼容、静态类型检查、最高性能 —— 这是客观约束而非个人意志
- Stroustrup 早在 1992 年就警告过"Remember the Vasa"——他非常清楚复杂度风险
- 现代 C++（C++11+）实际上比旧 C++ 更简单（有 `auto`、range-for、智能指针等）

**来源**：Stroustrup — "Five Popular Myths about C++" (2014)
**URL**：https://isocpp.org/blog/2014/12/five-popular-myths-about-c-bjarne-stroustrup
**可信度**：高 — 一手来源

#### 反对方（Stroustrup 应负责）
- C++ 的"三大约束"本身就是 Stroustrup 选择的，不是客观必然
- 他可以选择不与 C 保持如此高的兼容性，从而大幅降低复杂度
- 他在早期拒绝了多次简化的机会（例如没有及时采纳垃圾回收）

**来源**：Chinese article on C++ complexity
**URL**：http://www.51testing.com/mobile/view.php?itemid=846426
**可信度**：中 — 技术博客

---

### 3.2 C 兼容性——包袱还是天才之举？

**Stroustrup 的立场**：
- 明确声明：*"as close to C as possible — but no closer"*
- 如果 C 不存在，他也会选择与其他语言兼容——"发明又一种循环写法"没有意义
- 兼容 C 避免了"另一种邪教语言：信徒眼中美丽、但追求实效的程序员只会打哈欠"

**来源**：Stroustrup 1996 年访谈
**URL**：https://stroustrup.com/italian_interview.html
**可信度**：高 — 一手来源

**批评者的立场**：
- Rhodri James（Python 邮件列表）：*"C++ has a fundamental flaw; it wants to be both a high-level language and compatible with C, under the mistaken impression that C is a high level language. Since C is actually an excellent macro-assembler, this dooms the exercise from the very start."*
- C 兼容性导致大量遗留问题：`NULL` vs `nullptr`、`longjmp`、C 风格转型、`malloc`/`free`、VLA 等

**来源**：Python 邮件列表
**URL**：https://mail.python.org/archives/list/python-list@python.org/message/VAGNAPKPB5LCYBVZNWFDNKNEQPHQF3SL/
**可信度**：中 — 邮件列表讨论

**Paul Chiusano 的"Worse is Better"文化批判**：
> "Stroustrup had the skills and knowledge to create a better language, but he chose to accept as a design requirement retaining full compatibility with C, including all its warts."

**来源**：Paul Chiusano — "The problematic culture of Worse is Better"
**URL**：https://web.archive.org/web/20250209183424/http://pchiusano.github.io/2014-10-13/worseisworse.html
**可信度**：中 — 个人博客

**Stroustrup 的回应（2020 年更新）**：
> "Two decades ago, I thought a merger would be technically feasible; now I am not so sure."
> "I consider the value of compatibility obvious."

**来源**：ISO C++ 联络组邮件
**URL**：https://lists.isocpp.org/liaison/att-0193/attachment
**可信度**：高 — 一手来源

---

### 3.3 C++ 设计哲学不一致——"不和谐混合"的批评

**批评的核心**：C++ 被指为多种语言的不和谐混合——过程式（来自 C）、面向对象（来自 Simula）、泛型（来自模板）、函数式（来自 lambda 和算法库）——缺乏统一哲学。

**来源**：中文技术分析文章
**URL**：http://www.51testing.com/mobile/view.php?itemid=846426
**可信度**：中

文章将 C++ 分为"三个半子语言"：Better C、ADT C++（不含继承/多态的类）、IDL C++（COM 风格接口）、以及半个 GP C++（泛型编程）。这种分裂是批评的主要对象。

**Stroustrup 的辩护**：
多范式不是缺陷而是刻意设计——他从未想要纯 OO 语言。
> "I never called C++ an object-oriented programming language."（2025 年访谈）

**来源**：虎嗅网 — Stroustrup 近期采访 (2025-2026)
**URL**：https://www.huxiu.com/article/4860787.html
**可信度**：中 — 二手报道

---

### 3.4 C++ 标准化委员会的决策方式批评

**Stroustrup 本人对委员会的批评**（HOPL4, 2020）：
- 350+ 成员的共识型机构难以产生连贯结果
- 缺乏统一的验收标准
- 成员来自完全不同背景，对 C++ 应该成为什么没有共识
- `operator.()` 提案历经 30 年、6 次提案、大量设计和实现工作——从未交付
- 默认比较功能最终选择了复杂的三路比较 `<=>` 而非简单方案，使新手失望

**具体案例：Concepts 被移除（2009 年）**

**来源**：Stroustrup — "The C++0x 'Remove Concepts' Decision"
**URL**：https://www.mendeley.com/catalogue/5bf95e0b-617d-3370-8677-1dda2593dae8/
**可信度**：中 — 需验证链接准确性

Stroustrup 长期投入的 Concepts 功能在 2009 年法兰克福会议上被委员会投票移除，他称之为"对那些多年投入 Concepts 工作的人的巨大失望"。

**2025 年进展：Committee Prefers Stroustrup's Profiles to Rustification**

**来源**：Hacker News — "C++ Committee Prefers Bjarne's Profiles to Baxter's Rustification"
**URL**：https://news.ycombinator.com/item?id=45286562
**可信度**：中 — 论坛讨论 + The Register 报道

委员会选择了 Stroustrup 的 Profiles（渐进式安全）而非 Sean Baxter 更激进的 Rust 风格安全提案。批评者认为 Profiles 可能将 C++ "巴尔干化"为安全和非安全子集。

---

### 3.5 Linus Torvalds 的 C++ 批评与 Stroustrup 的回应

**2007 年 Git 邮件列表上的著名炮轰**：

当开发者 Dmitry Kakurin 质疑 Git 为何用 C 而非 C++ 编写时，Torvalds 回应：

> "C++ 是一种糟糕的（horrible）语言。而且因为有大量不够标准的程序员在使用而使情况更糟，以至于极容易产生彻头彻尾的垃圾。"

> "任何喜欢用 C++ 而不是 C 开发项目的程序员，可能都是我希望踢出去的人，免得他们来搞乱我参与的项目。"

他批评 STL 和 Boost 为"彻头彻尾的垃圾"，认为面向对象抽象导致"低效的抽象编程模型"。

**2010 年再次炮轰**：
> "C++ 是一门很烂的语言。不管什么时候 C++ 都不能是最正确的选择。"

**2021 年（Rust 进入内核的讨论中）**：
当有人建议用 C++ 而非 Rust 时，Linus 大笑并嘲讽：
> "C++ 真是一门很烂的语言。C++ 根本解决不了 C 语言的问题，它只会让事情变得更糟糕。"

**Stroustrup 的回应（极度克制）**：

据多篇中文媒体报道，Stroustrup "人格高，不跟喷他的人互喷"。他的核心反驳：

> "Linus Torvalds 不是 C++ 程序员，（据我所知）他已经有十年没有真正使用过 C++ 了，而且他用的是一个非常糟糕的 C++ 编译器……更重要的是，他工作在高度专业化的领域：很少有程序员做内核开发——而其中有些人确实用 C++。"

他还指出：
> "C 并不简单：请解释一下 unsigned short 到 int 的转换规则。"

认为"C 更简单"是一个**有害的神话（myth）**，会损害相信它的个人和组织。

**来源**：多篇中文综述
**URL**：https://www.eet-china.com/mp/a399797.html
**可信度**：中 — 二手资料

---

### 3.6 Rust 社区的批评

**核心批评**：C++ 在语言层面无法保证内存安全，而 Rust 通过 borrow checker 在编译期强制执行。

**关键统计数据**：
- ~70% 的安全 CVE 根因是内存安全错误（常见于 C/C++）
- Google Android 团队报告"Rust 代码中零内存安全漏洞"
- Microsoft Azure CTO Mark Russinovich 呼吁新项目使用 Rust 而非 C/C++
- US CISA 设定了 2026 年内存安全路线图截止日期

**Stroustrup 的反驳**：

在 P2739 提案和公开声明中：
- *"Safety is broader than memory safety"* —— 安全是多维度的（类型安全、资源安全、线程安全），C++ 可以通过 Profiles 框架解决所有维度
- Modern C++ 已可通过 Core Guidelines、静态分析器和智能指针达到安全水平
- 他将 Rust 的主导地位称为"对 C++ 前所未有的严重攻击"
- 他称大多数开发者每年只生产约 2,000 行生产代码——这在 Rust 社区中被嘲讽为过时

**来源**：LWN — Stroustrup's Plan for Bringing Safety to C++
**URL**：https://lwn.net/Articles/949481/
**可信度**：高 — 技术深度报道

**Rust 社区的回应**：
- 他的 opt-in 安全方法（Profiles）存在根本缺陷——安全必须是默认项而非可选项
- 他将"内存安全"重新定义为众多安全问题之一的做法被批评为"稻草人论证"
- 有评论者称他"被时代抛弃"

**来源**：Slashdot / Hacker News — "Rust Safety Is Not Superior to C++"
**URL**：https://news.ycombinator.com/item?id=34487557
**可信度**：中 — 论坛讨论

---

### 3.7 其他重大批评

#### 著名的 1998 年伪造访谈

**来源**：Snopes 辟谣 — "Program Management"
**URL**：https://www.snopes.com/fact-check/program-management/
**可信度**：高 — 事实核查

一篇广泛流传的伪造"访谈"中，虚构 Stroustrup 承认 C++ 故意设计得复杂以保护程序员薪资。Snopes 已辟谣，Stroustrup 本人对此有幽默感："would have been a much funnier parody had he written it himself"。

#### C++ 语法和解析器问题

**来源**：Usenet 讨论
**可信度**：低 — 零散网络讨论

批评者称 Stroustrup "开始设计时显然不理解如何编写正确的 LL/LALR 文法"，导致 C++ 文法混乱、编译器速度慢（需要回溯解析）、错误信息差。

#### 学术界对 PL 领域地位的争议

**来源**：多种观点综合
**可信度**：中

在编程语言（PL）学术界，C++ 的地位复杂：
- 正面：被广泛用于系统软件、高性能计算、CERN 发现希格斯玻色子所用的软件
- 负面：PL 理论界倾向认为 C++ 是"工程产物而非理论设计"，不如 ML/Haskell/Scheme 在类型理论上有学术贡献
- Stroustrup 的贡献更多在"将 PL 理论工程化并推向工业规模"而非纯理论创新
- 他的学术出版物（100+ 论文）涵盖了分布式系统、语言设计、工具链等多个领域

---

## 四、与同代语言设计师的对比

### 4.1 vs James Gosling (Java)

**核心差异**：

| 维度 | Stroustrup (C++) | Gosling (Java) |
|------|------------------|----------------|
| **定位** | 多范式系统语言 | "蓝领语言"（blue collar），刻意简化 |
| **用户类型** | 工程师，专业程序员 | 任何开发者 |
| **内存管理** | 手动 / RAII / 析构函数 | 垃圾回收、数组边界检查 |
| **设计原则** | "不为不使用的东西付费" | 可移植性、安全性、可靠性 |
| **营销** | 有机传播，无市场推广 | Sun 大力营销——"有史以来最强烈的编程语言营销活动" |
| **起源** | 贝尔实验室（计算机消费者） | Sun Microsystems（计算机供应商） |

**关键引语**：
- Gosling：*"For me as a language designer, the real 'simple' ultimately means 'I hope J. Random Developer can grasp the specification.'"*
- Stroustrup 对 Java 简化的警告：Java 的简单性"部分是幻觉，部分是语言不完整的表现（功能尚未添加）"——他预测 Java 规模将翻倍或三倍。

**来源**：The C Family of Languages: Interview with Dennis Ritchie, Bjarne Stroustrup, and James Gosling (2000)
**URL**：https://web.archive.org/web/20200428230138/http://www.gotw.ca/publications/c_family_interview.htm
**可信度**：高 — 一手访谈

Stroustrup 的谦逊总结：
> "None of these languages was radically different or dramatically better than other contemporary languages. They were, however, good enough and the beneficiaries of luck and 'social' factors such as Unix, low price, marketing (Java only), etc."

---

### 4.2 vs Anders Hejlsberg (C#)

**核心差异**：
- Hejlsberg 将 C# 设计为更"安全、干净"的 C++ 替代品，保留 C++ 的语法风格但消除了许多陷阱
- C# 保留了运算符重载等 C++ 特性（Gosling 在 Java 中弃用的），但通过垃圾回收和托管运行时消除了内存管理负担
- Hejlsberg 的创新包括：属性（properties）、LINQ、async/await —— 这些后来影响了 C++ 的发展方向
- Stroustrup 对 C# 的态度：公开场合基本不评论，但 C++ 委员会后来引入的许多特性（如 range-for、lambda）与 C# 已有的功能方向一致

**搜索局限性**：未找到两人直接对比的深入材料。Hejlsberg 的公开声明中鲜少直接评价 Stroustrup 或 C++。

---

### 4.3 vs Guido van Rossum (Python)

**Stroustrup 本人的对比**（源自官网 Quotes 页面）：
> "Guido van Rossum wanted a language that was usable by everybody and I wanted a language that was good for engineers. I don't want everybody to program the brakes in my car."
> "Yes, and IMO, we both succeeded."

**来源**：stroustrup.com/quotes.html
**URL**：https://www.stroustrup.com/quotes.html
**可信度**：高 — 一手来源

**核心差异**：

| 维度 | Stroustrup (C++) | van Rossum (Python) |
|------|------------------|---------------------|
| **用户定位** | "让所有人编程我的汽车刹车是危险的" | "人人可用的语言" |
| **类型系统** | 静态类型 | 动态类型 |
| **标准库哲学** | 精炼——只包含"每个程序员都需要的" | "batteries included"——大而全 |
| **哲学** | 多范式、零开销抽象 | "一件事情只有一种方法去做" |
| **社群文化** | 工程师文化，重视效率和控制 | 可读性至上，新手友好 |

**对比总结**：Stroustrup 和 van Rossum 的目标市场几乎完全互补。C++ 统治底层高效领域，Python 主导数据科学和快速开发。两者的语言设计体现了各自创始人对"谁应该编程"的根本不同看法。

---

### 4.4 vs Graydon Hoare (Rust)

**Hoare 创建 Rust 的动机**（2006 年）：
电梯坠毁事件：Hoare 在 Mozilla 工作期间回到公寓，电梯坏了——其软件崩溃。他住在 21 楼。爬楼梯时想：*"我们这些电脑人连一个不坏的电梯都造不出来，太荒谬了！"*

这种对 C/C++ 内存错误的挫折感催生了 Rust。

**Rust 对 C++ 的根本性格局挑战**：

| 维度 | Rust (Hoare) | C++ (Stroustrup) |
|--------|-------------|-------------------|
| **内存安全** | 编译期通过所有权/借用强制执行 | 手动；智能指针帮助但无编译期保障 |
| **并发安全** | 类型系统（Send/Sync traits）防止数据竞争 | 程序员需手动使用锁；数据竞争 = UB |
| **安全文化** | `unsafe` 块稀少、受审查、有文档 | 无正式安全文化；YOLO 做法常见 |
| **学习曲线** | 陡（所有权模型独特但一致） | 陡（几十年累积的复杂性和特性交互） |

**来源**：MIT Technology Review — "How Rust went from a side project to the world's most-loved programming language" (2023)
**URL**：https://www.technologyreview.com/2023/02/14/1067869/rust-worlds-fastest-growing-programming-language/amp/
**可信度**：高 — 主流科技媒体深度报道

---

## 五、Stroustrup 对批评者的反驳方式

### 5.1 反驳策略特征

**核心模式：理性克制，以理服人**
- 从不对批评者进行人身攻击（与 Torvalds 的激烈风格形成鲜明对比）
- 倾向于用数据和逻辑反驳，而非情绪化回应
- 在承认不足的同时坚守核心理念

**具体模式**：

- **对"太复杂"的批评**：承认复杂性是真实的，但将其重新定位为"强大能力不可避免的副产品"，指出现代 C++ 已大幅改善，并提醒批评者使用过时的知识
- **对"太危险"的批评**：将安全重新定义为多维问题，强调 C++ 的安全措施（Core Guidelines、Profiles）正在快速改进
- **对"被 Rust 超越"的批评**：否定 Rust 的优越性宣称，强调"安全不仅是内存安全"
- **对语言比较的回避**：名言 *"Language comparisons are rarely meaningful and even less often fair"* —— 指出偏见来源（熟悉的缺陷看似小事，陌生的缺陷看似根本性）

### 5.2 标志性反驳名言

- *"There are only two kinds of languages: the ones people complain about and the ones nobody uses."* — 回击所有批评
- *"C makes it easy to shoot yourself in the foot; C++ makes it harder, but when you do it blows your whole leg off."* — 承认 C++ 的危险性，但暗示这是强大能力的代价
- *"Please explain the conversion rules from unsigned short to int."* — 回击"C 更简单"的神话
- *"I don't want everybody to program the brakes in my car."* — 区分"工程师专业语言"与"通用教育语言"

### 5.3 对 AI 时代的回应（2025-2026）

**来源**：虎嗅网 — "C++之父开撕AI Coding" (2025-2026)
**URL**：https://www.huxiu.com/article/4860787.html
**可信度**：中 — 中文科技媒体

在最近的一次播客访谈中，Stroustrup 表达了对 AI 生成代码的担忧：
> "我已经看到资深开发者开始退休，因为他们不想处理每次改 prompt 都会改变的 AI 生成代码的验证工作。"

这体现了他一以贯之的立场：质量、可靠性和可维护性比速度和便利性更重要。

---

## 六、综合评估与总结

### 6.1 他者视角的整体评价

| 维度 | 评价 |
|------|------|
| **同行尊重度** | 极高。Scott Meyers、Herb Sutter、Andrew Koenig 等核心人物均给予最高评价 |
| **社区争议度** | 中高。C++ 语言本身争议极大，但这些争议是"爱之深责之切" |
| **工业界地位** | 极高。C++ 仍是 TIOBE 前 4 的语言，在嵌入式、金融、游戏、基础软件领域不可替代 |
| **学术界地位** | 高。Draper Prize / Faraday Medal / Dahl-Nygaard Prize 证明其学术影响力 |
| **公共形象** | 温和理性的学者形象，从不直接攻击竞争对手 |
| **最大共识** | Stroustrup 创造了一种能让工业界切实使用的语言——这是最高赞誉 |
| **最大争议** | C 兼容性决策——被一些批评者认为是 C++ "一切问题的根源" |

### 6.2 对他最关键的三个批评

1. **C 兼容性**：保留了 C 的缺陷，使 C++ 永远无法成为一个干净的语言
2. **委员会领导的失败**：未能为 C++ 委员会提供足够强力的方向性领导，导致标准膨胀
3. **安全问题的反应迟缓**：在内存安全成为行业共识前长期否认，直到 2023-2025 年才积极回应

### 6.3 对他最坚实的三项赞誉

1. **RAII 与析构函数**：一项被 Java/C#/Rust 等语言以不同形式借鉴的原创性贡献
2. **零开销抽象原则**："不为不使用的东西付费"——影响深远的工程哲学
3. **长期坚守**：40 多年持续投入 C++ 的演化，没有"做完就跑"

---

## 附录：信息源汇总

| 来源类型 | URL | 可信度 |
|---------|-----|--------|
| Artima (Scott Meyers) | https://www.artima.com/articles/the-most-important-c-peopleemeverem | 高 |
| ISO C++ 博客 | https://isocpp.org/blog/2014/12/five-popular-myths-about-c-bjarne-stroustrup | 高 |
| stroustrup.com (Quotes) | https://www.stroustrup.com/quotes.html | 高 |
| stroustrup.com (Italian Interview) | https://stroustrup.com/italian_interview.html | 高 |
| stroustrup.com (IEEE Interview) | https://stroustrup.com/ieee_interview.html | 高 |
| HOPL4 论文 | https://scholar.archive.org/work/a2cafus5uvcvro2i6hl5m43h4u | 高 |
| Snopes (辟谣) | https://www.snopes.com/fact-check/program-management/ | 高 |
| MIT Tech Review | https://www.technologyreview.com/2023/02/14/1067869/rust-worlds-fastest-growing-programming-language/amp/ | 高 |
| LWN (Stroustrup safety plan) | https://lwn.net/Articles/949481/ | 高 |
| LWN (Multi-language codebase) | https://lwn.net/Articles/1007574/ | 高 |
| The C Family Interview | https://web.archive.org/web/20200428230138/http://www.gotw.ca/publications/c_family_interview.htm | 高 |
| EET China (Linus 批评综述) | https://www.eet-china.com/mp/a399797.html | 中 |
| 51Testing (复杂度分析) | https://www.51testing.com/mobile/view.php?itemid=846426 | 中 |
| Paul Chiusano blog | https://web.archive.org/web/20250209183424/http://pchiusano.github.io/2014-10-13/worseisworse.html | 中 |
| HN Discussion | https://news.ycombinator.com/item?id=34487557 | 中 |
| 虎嗅网 (AI 访谈) | https://www.huxiu.com/article/4860787.html | 中 |
| ISO C++ Liaison | https://lists.isocpp.org/liaison/att-0193/attachment | 高 |
| UC3M 荣誉博士颂词 | https://www.uc3m.es/about-uc3m/honoris-causa/professor-bjarne-stroustrup/laudiato | 高 |
| NAE 当选认证 | https://www.nae.edu/177032/Dr-Bjarne-Stroustrup | 高 |
| Herb Sutter blog | https://herbsutter.com/2008/06/10/stroustrup-sutter-on-c-the-interviews/ | 高 |

---

> **编制日期**：2026-05-24
> **编制目的**：为 Bjarne Stroustrup 视角 Skill 构建提供平衡的第三方视角
> **注意**：本文件以中文撰写，保留英文术语原名。信息来源包含一手和二手资料，
> 已标注可信度。二手资料的内容可能存在传播失真，使用时应交叉验证。
