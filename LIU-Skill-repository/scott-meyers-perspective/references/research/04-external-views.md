# 04 — 他者视角：外界对 Scott Meyers 的评价

> **说明**：本文汇总了 C++ 业界同行、社区、批评者对 Scott Meyers 的分析、评价和批评。
> 每条信息均标注来源 URL 和可信度（高/中/低）。发现矛盾处保留矛盾，不美化。
> 来源黑名单已排除知乎、微信公众号、百度百科。

---

## 一、同行评价

### 1.1 Bjarne Stroustrup（C++ 之父）

**评价摘要**：
Stroustrup 为 Scott Meyers 的 *Effective Modern C++* 撰写了推荐语，称该书为 **"Another great Scott Meyers book"**，并赞扬 Meyers 清晰解释了普通程序员如何从 C++11/14 的新特性中受益。

但在更广泛的评价中，Stroustrup 始终扮演的是"语言创造者"角色，而 Meyers 是"布道者/教师"角色。一篇广为流传的中文文章《造物主与布道者：C++双子星 Bjarne Stroustrup 和 Scott Meyers 的传奇》将两人描述为：
- **Stroustrup**：造物主，定义了规则，创造了可能性（自上而下）
- **Meyers**：布道师，总结了经验，传播了智慧（自下而上）

该文结尾以一句"对话"形式总结：
> *"C++ 的成功，是因为它解决了真实世界中的真实问题。"* — Stroustrup
> *"但前提是，你得知道怎么正确地用它。"* — Meyers（意译补充）

值得注意的是，Meyers 自己的"五本最重要的 C++ 书籍"列表中，*The C++ Programming Language*（Stroustrup）排在第一位，*Effective C++*（Meyers 自己）排在第二位——创造者与布道者在同一张列表上"握手"。

- **来源**：[微信文章《造物主与布道者》](http://mp.weixin.qq.com/s?__biz=MzE5MTQ3NDgzMA==&mid=2247484018&idx=1&sn=54c163e5f5cf5ece5b2dee50c9725996)
- **来源**：*Effective Modern C++* 书前推荐页
- **可信度**：中（微信文章为二手转述，但推荐语可查证于原书）

---

### 1.2 Herb Sutter（C++ 标准委员会主席，Microsoft）

**评价摘要**：
在 Scott Meyers 2015 年宣布退休时，Herb Sutter 在 isocpp.org 上发表了公开回应：

> *"Scott, we have appreciated all you've contributed to C++ over many years. Your first book, first edition, got me and many others grounded in C++."*
> （Scott，我们感谢你多年来对 C++ 的所有贡献。你的第一本书的第一版，让我和许多人打下了 C++ 的基础。）

这句话分量很重——来自 C++ 委员会主席的公开感谢，并承认 Meyers 的书对自己的影响。

Sutter 也是 N4164 论文（将 "universal reference" 改名为 "forwarding reference"）的三位作者之一。该论文明确反对 Meyers 的术语，但 Sutter 本人与 Meyers 之间保持着专业上的尊重。

在书评/用户讨论中，Sutter 的 *Exceptional C++* 系列常与 Meyers 的 *Effective* 系列对比：
| 方面 | Meyers | Sutter |
|------|--------|--------|
| 风格 | 规则导向，essay 格式 | 问答/谜题格式 |
| 难度 | 中等，更易读 | 较难，假设读者已具备深厚 C++ 知识 |
| 深度 | 广度优先，实用规则 | 深度优先，尤其异常安全 |
| 代码量 | 文本多，代码少 | 代码多，精心构造的示例 |

有读者评论：*"You can tell Sutter is the better programmer... Meyers tells you what to do; Sutter makes you understand why."*

- **来源**：[isocpp.org - } // good to go](https://isocpp.org/blog/2015/12/good-to-go-by-scott-meyers)
- **来源**：[GNUCash C++ wiki](https://code.gnucash.org/wiki/index.php?title=C%2B%2B&diff=cur&oldid=13184)
- **来源**：[Amazon 书评对比](https://www.amazon.com.au/product-reviews/0201615622/)
- **可信度**：高（isocpp.org 为官方站点，Sutter 的引言明确可查）

---

### 1.3 Andrei Alexandrescu（*Modern C++ Design* 作者，C++ 标准委员会成员）

**评价摘要**：
Alexandrescu 为 *Effective Modern C++* 撰写了高度正面的推荐语：

> *"Finding utmost expertise is hard enough. Finding teaching perfectionism—an author's obsession with strategizing and streamlining explanations—is also difficult. You know you're in for a treat when you get to find both embodied in the same person. **Effective Modern C++ is a towering achievement from a consummate technical writer.** It layers lucid, meaningful, and well-sequenced clarifications on top of complex and interconnected topics, all in crisp literary style. You're equally unlikely to find a technical mistake, a dull moment, or a lazy sentence in Effective Modern C++."*
>
> — Andrei Alexandrescu，署名 *author of Modern C++ Design*

Meyers 也将 Alexandrescu 的 *Modern C++ Design* 列入"五本最重要的 C++ 书籍"之一。两位作者互表敬意。

从风格对比：
| 方面 | Meyers | Alexandrescu |
|------|--------|--------------|
| 领域 | 最佳实践、陷阱避免 | 模板元编程、策略式设计 |
| 难度 | 中高级，可读性强 | 极高，需深厚模板功底 |
| 影响 | 行业标准实践 | 推动编译器标准化、开创 Loki 库 |

一个来自 Hacker News 的有趣观察：*"Modern C++ Design by Andrei Alexandrescu is a very awesome book, but the fact that there are surprises in it for Scott Meyers should give the student pause."* 暗示即使对 Meyers 来说，Alexandrescu 的一些模板技术也令人惊讶——说明后者的书走在了时代前面，即使是 C++ 顶级专家也未必熟悉。

- **来源**：*Effective Modern C++* 推荐页（archive.org 存档：[链接](https://ia802804.us.archive.org/23/items/EffectiveModernC/Effective-Modern-C%2B%2B.pdf)）
- **来源**：[Wikipedia - Modern C++ Design](https://web.archive.org/web/20230413030211/https://en.wikipedia.org/wiki/Modern_C%2B%2B_Design)
- **可信度**：高（推荐语可在原书 PDF 中查证）

---

### 1.4 其他同行轶事

**Sean Parent（Adobe，C++ 委员会成员）**：未找到 Parent 对 Meyers 的直接公开评价。但在 C++ 社区活动中，Parent 的 "C++ Seasoning" 演讲和 Meyers 的"Effective"系列在实践导向上一脉相承。需要进一步确认直接引用。

**GNUCash 开发者文档**将 Meyers 和 Sutter 的书列为团队必读：

> *"If you buy all of them new, it will run well over $200... Meyers's and Sutter's books are widely available used at a fraction of the cost, and understanding them will make you a much better C++ programmer."*

**CSDN 论坛（2005）**：一场关于 *Exceptional C++* 和 *Effective C++* 的技术讨论中，一用户对比了两本书对 `new T[n]` 在构造函数抛出异常时内存泄漏问题的处理，认为 *More Effective C++* Item 10 的解释"明显优于" Sutter 的处理。

- **来源**：[GNUCash C++ wiki](https://code.gnucash.org/wiki/index.php?title=C%2B%2B&diff=cur&oldid=13184)
- **来源**：[CSDN 论坛](https://bbs.csdn.net/topics/80121761)
- **可信度**：中（论坛讨论可靠但非正式来源）

---

## 二、社区评价

### 2.1 书籍影响力排名

**Scott Meyers 自己的"五本最重要的 C++ 书籍"（2006 年）**：
| 排名 | 书名 | 作者 | 年份 |
|------|------|------|------|
| 1 | *The C++ Programming Language* | Bjarne Stroustrup | 1986 |
| 2 | ***Effective C++*** | **Scott Meyers** | **1992** |
| 3 | *Design Patterns* | GoF | 1995 |
| 4 | *International Standard for C++* | ISO/IEC | 1998 |
| 5 | *Modern C++ Design* | Andrei Alexandrescu | 2001 |

Meyers 对自己的书评价道：
> *"I got lucky with this book; it happened to be the right book at the right time. By 1991, lots of programmers had mastered the basics of the language... This was one of the first books to focus on using C++ as opposed to simply learning it."*

他特别提到 **GNU C++ 编译器甚至增加了一个选项来警告违反 *Effective C++* 准则的构造**——这是其影响力的一个标志。

**StackOverflow 社区排名**：*Effective C++* 在"史上最具影响力的编程书籍"综合榜单中位列 **第 13 名**（在所有编程语言中），*More Effective C++* 位列 **第 14 名**，与 *Code Complete*、*The Pragmatic Programmer*、*SICP* 等经典并列。

- **来源**：[Meyers 原文 - The Most Important C++ Books...Ever](https://www.cnblogs.com/oiramario/archive/2006/11/06/551809.html)
- **来源**：[GitHub - influential-cs-books](https://github.com/Jyothi-Jaci/influential-cs-books/blob/master/README.md)
- **可信度**：高（Meyers 原文存档于多个镜像站点）

### 2.2 GCC `-Weffc++` 编译选项

GCC 编译器从早期版本（至少 2.95，1999 年）开始提供 `-Weffc++` 选项，用于检查违反 *Effective C++* 规则的代码。这是编译器历史上少有的、直接以一本书命名的编译选项。

社区对 `-Weffc++` 的评价褒贬不一：
- **正面**：体现了 Meyers 规则在业界的权威地位
- **负面**：有用户抱怨该选项"有点过于严格"（"a little too strict about initialization"），GCC 团队收到过关于误报的 bug 报告
- 该选项的问题一直延续到现代 GCC（2023 年仍有相关的 bug 报告 [#110186]）

- **来源**：[GCC 邮件列表 - 1999 年讨论](https://gcc.gnu.org/legacy-ml/gcc/1999-08n/msg00996.html)
- **来源**：[GCC bug #110186 (2023)](https://gcc.gnu.org/pipermail/gcc-bugs/2023-June/825817.html)
- **可信度**：高

### 2.3 对 C++ 教育培训市场的影响

Meyers 在培训市场的影响力是巨大的：

- 退休时统计：**6 本书、2 套注释版培训材料、超过 4 打线上视频、约 80 篇文章/访谈/学术论文**
- 大量评论者称他的书是企业"新员工必读"、团队入门标准
- 他的 `Item`（条款）格式被其他语言借鉴：《Effective Java》（Joshua Bloch）、《Effective Python》（Brett Slatkin）等都沿用了这一范式

**模式影响**：Meyers 创造的"xx 个有效方法"格式已成为技术写作的一个标准模板——将经验提炼为可操作的条款，每条款包含规则、解释、示例和注意事项。

**社区中的典型评论**：
> *"His books were the first recommendation for new recruits at our software company."*
> *"Effective C++ made me the crane among chickens (鹤立鸡群) in my team."*

- **来源**：Scott Meyers 退休博客
- **来源**：多篇豆瓣书评
- **可信度**：中（多为个体主观评价，但样本量足够大）

### 2.4 对 C++ Core Guidelines 的影响

C++ Core Guidelines（由 Stroustrup 和 Sutter 领导）明确承认其建立在 **"decades of experience and previous coding rules (such as Scott Meyers' Effective C++ books)"** 之上。

社区对两者的关系评价：
- **C++ Core Guidelines = 泛读**（广度优先，每个规则简洁明了）
- **Meyers 的书 = 精读**（深度优先，每个条款详细阐述）
- 两者互补而非替代，"Read both if you have the energy, or switch when you get tired of one."

- **来源**：[ACCU 书评 - C++ Core Guidelines Explained](https://accu.org/bookreviews/2023/bruntlett_2006/)
- **来源**：知乎讨论（作为参考，非主要可信来源）
- **可信度**：高（ACCU 为权威 C++ 组织）

---

## 三、批评与争议

### 3.1 "Universal Reference" 命名争议

这是 Meyers 面临的最著名的技术争议。

**背景**：Meyers 在 2012 年 C++ and Beyond 大会上首次提出 "universal reference" 这个术语，用来描述模板参数推导中的 `T&&`（可同时绑定左值和右值）和 `auto&&`。该术语被 C++ 社区广泛采用，出现在大量博客、演讲和 StackOverflow 答案中。

**标准委员会的反对（2014 年，N4164 论文）**：
Herb Sutter、Bjarne Stroustrup、Gabriel Dos Reis 联合提交 N4164，正式引入 **"forwarding reference"** 作为标准术语，理由：

1. **"Universal" 有误导性**——暗示这些引用可以"到处使用"或"用于一切"，但实际上它们有特定用途
2. **主要目的是转发（forwarding）**——这个构造是专门为通过 `std::forward` 转发参数而设计的
3. **`auto&&` 也是用于转发**——包括 range-for 循环和泛型 lambda

论文原文（§3.1）：
> *"It is a name that just rolls off the tongue and is misleading because 'universal references' aren't universal in the sense of how pervasively they should be used."*

**社区反应**：
- Meyers 表示自己"在 loop 中"（知情），同意更改，没有反对
- 在 *Effective Modern C++* 中，他保留了 "universal reference" 但加脚注说明 "forwarding reference" 是官方术语
- 一些社区成员（如 Ben Hekster）认为这个概念本身是"多余的"——引用折叠规则已经清楚解释了行为
- 截至今天，"universal reference" 在社区中仍然广泛使用（特别是在旧博客和 StackOverflow 答案中），但官方标准术语是 "forwarding reference"

**矛盾保留**：这场争议没有真正的"赢家"。Meyers 创造了社区广泛接受的名称，但委员会用更准确但更机械的名称将其取代。Meyers 优雅地接受了改变，但社区中术语混用仍在继续。

- **来源**：[N4164 - Forwarding References (PDF)](https://rap.no/JTC1/SC22/WG21/docs/papers/2014/n4164.pdf)
- **来源**：[isocpp.org - N4164 公告](https://isocpp.org/blog/2014/10/n4164)
- **来源**：[StackOverflow 讨论](https://browse.library.kiwix.org/content/stackoverflow.com_en_all_2023-11/questions/39552272/is-there-a-difference-between-universal-references-and-forwarding-references)
- **可信度**：高（标准委员会官方论文）

---

### 3.2 "规则太死板 / 太保守"的批评

#### 3.2.1 vterrain.org 的逐条批评

这是最详细的批评之一，作者逐条分析 *Effective C++*（第一版）和 *More Effective C++* 的建议，认为许多建议是"过于笼统的概括"（sweeping generalizations）：

| 条款 | 批评内容 |
|------|---------|
| Item 1（const 优于 #define） | 忽略链接器行为和内存膨胀 |
| Item 2（优先使用 iostream） | "largely bogus"（基本是扯淡）——未提及 iostream 的"极度低效开销"（约 20 层调用深度，仅为定义流就要分配大块内存） |
| Item 3（优先用 new/delete） | 未提及 `malloc`/`free` 对非类对象通常更高效 |
| Item 7（OOM 处理） | 不必要地增加了复杂性 |
| Items 8-10（自定义 operator new/delete） | 建议不切实际 |
| Items 20 & 30 | 发现两个条款之间存在矛盾——建议避免返回非 const 指针到私有成员，又在别处无意中鼓励类似做法 |

总体评价：作者认为这些书"wonderful"（很好），但许多具体建议在真实项目中站不住脚。

- **来源**：[vterrain.org - Notes on Effective C++](http://vterrain.org/Implementation/effective.html)
- **可信度**：中（个人观点，但分析详细，提供了具体的反例论证）

#### 3.2.2 YAGNI 冲突（c2.com Wiki）

**"Program in the Future Tense"**（More Effective C++ 中的原则）与极限编程的 **YAGNI（You Aren't Gonna Need It）** 之间存在张力。

Ron Jeffries（XP 创始人之一）评价：
> *"Scott is a bit more inclined to build an abstract class than I'd be... He is a little more inclined to put in isolation code."*

结论：Meyers 的建议"与 XP 相当一致，只是不那么极端"——他推荐做**稍微**多的前瞻设计，而 XP 说除了干净的抽象之外什么都不做。

- **来源**：[c2.com - Yagni And Cpp](http://c2.com/wiki/remodel/?YagniAndCpp)
- **可信度**：高

#### 3.2.3 GameDev 圈的批评（性能开销）

游戏开发者论坛讨论 Meyers 的 OO 原则是否引入了过多开销：

> *"Following Meyers' advice does strike me as adding a lot of extra overhead when you're stretching computing power to the limit."*

但反方也指出：虚拟分派和拷贝的开销是已知的，模板和现代 C++ 技术可以缓解。

- **来源**：[GameDev.net - Strict OO principles vs. speed](https://www.gamedev.net/forums/topic/560855-strict-oo-principles-vs-speed/)
- **可信度**：中（论坛讨论）

---

### 3.3 "Effective C++ 过时了"的争论

#### 3.3.1 具体过时的内容

基于多位评论者的总结，以下条款已明显过时：

| 过时的条款 | 内容 | 现代替代 |
|-----------|------|---------|
| Item 05 | 编译器默默编写的函数 | C++11 增加了移动构造函数和移动赋值运算符 |
| Item 06 | 声明为 private 且不实现来禁止拷贝 | C++11 用 `= delete` |
| Item 07 | 没有"禁止派生"机制 | C++11 引入 `final` |
| Item 13 | 使用 `auto_ptr` | 改为 `unique_ptr` |
| Item 17 | new 对象后放入智能指针 | 直接用 `make_shared<T>(args)` |
| Item 29/51 | `throw()` 异常声明 | 改为 `noexcept` |
| Item 38 | set 空间开销大（红黑树） | 可用 `unordered_set`（哈希表） |
| Item 54 | `std::tr1::` 命名空间 | 已全部并入 `std::` |

#### 3.3.2 "依然值得读"的反驳

一篇 2026 年的深度解读文章总结：

> *"如果你觉得《Effective C++》过时了，往往不是因为它真的过时，而是因为你还没读懂它。"*

论点支持：
1. **资源管理原则不变**：RAII 思想在 C++20/23 中仍然核心
2. **对象生命周期问题更隐蔽**：`shared_ptr` 也会带来循环引用
3. **设计决策不会因语法糖消失**：何时用值语义、何时用引用、如何设计接口等核心原则独立于语言版本

#### 3.3.3 双重观点——Hacker News 2023

> *"Back in 2015 I read Effective Modern C++ by Scott Meyers... My feeling... is that I didn't read a collection of new nice additions to the language, but a list of minefields and new fancy ways to crash your program."*

该评论认为书的质量很高，但问题在于 C++ 语言本身：

> *"Effective Modern C++ is a very well written book and very instructive. Its flaws are none of the book or writer, but of the language itself."*

并引用了 Meyers 自己承认无法再维护更新的声明：

> *"C++ is a large, intricate language with features that interact in complex and subtle ways, and I no longer trust myself to keep all the relevant facts in mind."*

- **来源**：[Hacker News - C++ Papercuts (2023)](https://news.ycombinator.com/item?id=37292749)
- **来源**：[blog - 为什么 2026 年还要读《Effective C++》](http://mp.weixin.qq.com/s?__biz=MzE5MTk4MzEwNg==&mid=2247485356&idx=1&sn=7765d8e5991e41160924ad14f8eecfdb)
- **来源**：[豆瓣评价 - 有用的 tips，但是 C++98/03](https://book.douban.com/review/14560548/)
- **可信度**：高（HN 原文可查证）到中（微信文章为二手来源）

---

### 3.4 "太基础 / 太浅"的批评

最尖锐的批评来自 Amazon 的 1 星评价（Franco Embarcadero, 2005）：

> *"This book and its predecessor... are overrated. If you have read Bjarne Stroustrup's C++ Programming Language... and/or Stanley Lippman's C++ Primer... this book of Meyers presents nothing new that you would have already known."*

> *"Meyers has always capitalized on simply telling you what you should already know assuming you had read a more thorough text like Stroustrup's and/or Lippman's."*

该评价推荐 Herb Sutter 的书，称其"在细节和整体质量上远超 Meyers 的书"。

其他批评：
- CodeGuru 论坛用户：担心 Meyers 的书是"Step-by-step"类型的，只有"do's and don'ts 的长列表"，没有真正的设计深度
- Amazon 2 星评价：抱怨示例过于复杂——"你把大部分时间花在理解示例上，而不是理解概念"
- 豆瓣中文读者：批评侯捷翻译版有"机翻感"、"台湾腔太重"，术语"客制化"等不符合大陆习惯

| 批评类型 | 具体内容 |
|---------|---------|
| 太基础 | 读过 Stroustrup/Lippman 后没有新内容 |
| 太浅 | 每条款只有~5 页，不如 Sutter 深入 |
| 被高估 | 赞美者可能没有读过更深入的书 |
| 示例复杂 | 示例反而增加了理解难度 |
| 翻译差 | 中文版翻译质量参差不齐 |

- **来源**：[Amazon 1-Star Reviews](https://www.amazon.com/Effective-Specific-Improve-Programs-Designs/product-reviews/0321334876/ref=cm_cr_dp_d_hist_2?ie=UTF8&filterByStar=two_star&reviewerType=all_reviews#reviews-filter-bar)
- **来源**：[CodeGuru Forums](https://forums.codeguru.com/printthread.php?t=212763&pp=15&page=1)
- **来源**：[豆瓣书评](https://book.douban.com/subject/1453373/comments/)
- **可信度**：中（个人主观评价，但数量较多形成模式）

### 3.5 "Effective Modern C++ 是一份地雷清单"（Hacker News）

来自 2023 年 Hacker News "C++ Papercuts" 讨论的深度评论：

> *"My feeling during the read, and my definite conclusion afterwards, is that I didn't read a collection of new nice additions to the language, but a list of minefields and new fancy ways to crash your program. That there is no chapter which doesn't end up being a list of gotchas."*

亮点：
- 这本书无意中揭示了 C++ 的复杂性已经失控
- 每章最后都是一堆"陷阱"——lambda 有 32 种失败方式
- 这不是 Meyers 的错，而是 C++ 语言的错
- 对比 Rust：Rust 将用户导向好的惯用决策，而 C++ 不这样做

- **来源**：[Hacker News - C++ Papercuts](https://news.ycombinator.com/item?id=37292749)
- **来源**：[Amazon 评论 - "most challenging programming book"](https://www.amazon.sg/product-reviews/1491903996/)
- **可信度**：高

---

### 3.6 退休后的遗产评价（2015-现在）

**Meyers 退休声明（2015.12.31）**：
他在 "} // good to go" 中宣布退休，理由是自己"25 年投入到 C++"，而此时 C++ 解释市场已经"繁荣"——更多会议、更多博客、更多视频、StackOverflow、C++ Core Guidelines——"My voice is dropping out, but a great chorus will continue."

**2018 年的进一步公告**：
Meyers 承认自己再也**记不住 C++ 的全部复杂性**来进行技术勘误。这是一个被社区广泛引用的标志性事件——如果连 Scott Meyers 都跟不上了，C++ 的复杂度对普通开发者意味着什么？

**社区的三个方向性反应**：

1. **怀念与致敬**：139 条评论，Herb Sutter 亲自留言，被称为"一个时代的终结"
2. **对 C++ 未来的担忧**："So long Scott Meyers, So long C++?"——他的离开被视为 C++ 复杂性达到临界点的信号
3. **知识断层问题**：Meyers 的书成为"快照"——冻结在 C++14 时代，无人能接替他的角色更新到 C++17/20/23

一个关键的问题浮现：**为什么没有人能接替 Scott Meyers？**
- 写一本 *Effective C++17* 或 *Effective C++20* 需要：深厚的语言知识 + 卓越的教学能力 + 执着于准确性的完美主义
- 三重条件的组合极为罕见
- C++ 标准演进速度加快，使得个人写书的速度跟不上语言变化

- **来源**：[Scott Meyers 退休博客](http://scottmeyers.blogspot.com/2015/12/good-to-go.html)（[archive.org 备份](https://web.archive.org/web/20250117121730/http://scottmeyers.blogspot.com/2015/12/good-to-go.html)）
- **来源**：[Approxion - So long Scott Meyers, So long C++?](https://www.approxion.com/so-long-scott-meyers-so-long-c/)（无法直接抓取，但标题揭示了社区的忧虑）
- **来源**：[micro.blog - Scott Meyers Can No Longer Remember the Full Intricacies of C++](https://brokaw.micro.blog/2018/09/08/scott-meyers-can.html)
- **可信度**：高

---

## 四、对比总结

### 4.1 "四大 C++ 作者"对比

| 维度 | Scott Meyers | Herb Sutter | Andrei Alexandrescu | Bjarne Stroustrup |
|------|-------------|-------------|---------------------|-------------------|
| **角色** | 教师/最佳实践编译者 | 深度解谜专家/委员会主席 | 模板元编程开拓者 | 语言创造者 |
| **代表作** | *Effective* 系列 | *Exceptional* 系列 | *Modern C++ Design* | *The C++ Programming Language* |
| **风格** | 规则导向，essay 格式 | Socratic 问答格式 | 前沿创新，抽象度高 | 学术性，全面参考 |
| **目标读者** | 中级（有 1 年经验） | 中高级 | 专家 | 所有人 |
| **难度** | 中等 | 中高 | 极高 | 从入门到参考 |
| **委员会角色** | 无（外部顾问） | 主席（前） | 成员 | 成员 |
| **截至 2026 现状** | 已退休，不再更新 | 仍活跃 | 仍活跃（D 语言等） | 仍活跃 |
| **批评** | 太浅/过时/规则死板 | 缺"为什么"的解释 | 过于晦涩/不适于实践 | 太厚/入门曲线陡 |

### 4.2 矛盾汇总

| 矛盾点 | 观点 A | 观点 B |
|--------|--------|--------|
| 深度评价 | "Essential, practical wisdom" | "Too basic, nothing new" |
| 规则价值 | "Clear guidelines for real projects" | "Sweeping generalizations, context-blind" |
| 前瞻设计 | "Good defensive programming" | "Violates YAGNI, too conservative" |
| 过时问题 | "Core principles timeless" | "Specific items outdated in C++17/20" |
| 术语贡献 | "Universal reference is intuitive" | "Misleading, forwarding reference is correct" |

---

## 来源汇总

| # | 来源 | URL | 可信度 |
|---|------|-----|--------|
| 1 | N4164 - Forwarding References（标准委员会论文） | https://rap.no/JTC1/SC22/WG21/docs/papers/2014/n4164.pdf | 高 |
| 2 | isocpp.org - } // good to go | https://isocpp.org/blog/2015/12/good-to-go-by-scott-meyers | 高 |
| 3 | Scott Meyers 退休博客 | http://scottmeyers.blogspot.com/2015/12/good-to-go.html | 高 |
| 4 | Hacker News - C++ Papercuts (2023) | https://news.ycombinator.com/item?id=37292749 | 高 |
| 5 | GNUCash C++ wiki | https://code.gnucash.org/wiki/index.php?title=C%2B%2B&diff=cur&oldid=13184 | 高 |
| 6 | vterrain.org - Notes on Effective C++ | http://vterrain.org/Implementation/effective.html | 中 |
| 7 | c2.com - Yagni And Cpp | http://c2.com/wiki/remodel/?YagniAndCpp | 高 |
| 8 | Amazon 1-Star Reviews (Effective C++) | https://www.amazon.com/Effective-Specific-Improve-Programs-Designs/product-reviews/0321334876/ | 中 |
| 9 | GCC -Weffc++ 历史讨论 | https://gcc.gnu.org/legacy-ml/gcc/1999-08n/msg00996.html | 高 |
| 10 | GCC bug #110186 (2023) | https://gcc.gnu.org/pipermail/gcc-bugs/2023-June/825817.html | 高 |
| 11 | ACCU 书评 - C++ Core Guidelines Explained | https://accu.org/bookreviews/2023/bruntlett_2006/ | 高 |
| 12 | *Effective Modern C++* PDF（含 Alexandrescu 推荐语） | https://ia802804.us.archive.org/23/items/EffectiveModernC/Effective-Modern-C%2B%2B.pdf | 高 |
| 13 | micro.blog - Scott Meyers Can No Longer Remember... | https://brokaw.micro.blog/2018/09/08/scott-meyers-can.html | 中 |
| 14 | StackOverflow - universal vs forwarding reference | https://stackoverflow.com/questions/39552272/is-there-a-difference-between-universal-references-and-forwarding-references | 高 |
| 15 | GameDev.net - Strict OO principles vs. speed | https://www.gamedev.net/forums/topic/560855-strict-oo-principles-vs-speed/ | 中 |
| 16 | 豆瓣书评（综合） | https://book.douban.com/subject/1453373/comments/ | 中 |
| 17 | GitHub - influential-cs-books | https://github.com/Jyothi-Jaci/influential-cs-books/ | 中 |
| 18 | 微博文章 - 造物主与布道者 | http://mp.weixin.qq.com/s/...（见正文） | 低（微信平台，但引用自原书推荐页可验证） |

---

*本文档由 WebSearch 调研汇总，2026-05-24 完成。*
