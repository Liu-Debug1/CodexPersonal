# Bjarne Stroustrup 完整时间线

> 编译日期：2026-05-24
> 信息来源标注可信度：A（官方/一手来源）、B（权威二手来源）、C（一般网络来源）
> 语言：中文，保留英文术语原名

---

## 早年与教育（1950-1979）

### 1950年12月30日 — 出生
- 出生于 **丹麦奥胡斯（Aarhus, Denmark）**，工人家庭
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 1969-1975 — 奥胡斯大学（Aarhus University）
- 攻读数学与计算机科学
- 获得 **Cand.Scient.（硕士）** 学位
- 期间学习了 **Simula** （面向对象编程语言），对后来的 C++ 设计产生了深远影响
- 从 Simula 发明人 **Kristen Nygaard** 的讲座中获得了面向对象编程的基础理念
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 1975-1979 — 剑桥大学博士研究
- 进入 **剑桥大学丘吉尔学院（Churchill College, Cambridge）**
- 导师：**David Wheeler**（EDSAC 的先驱之一，"Wheeler Jump" 发明人）
- 博士论文：**"Communication and control in distributed computer systems"**（分布式计算机系统中的通信与控制）
- 1979 年获得 **计算机科学 PhD**
- 关键转折：博士期间用 Simula 写分布式系统模拟器，但因为垃圾回收导致性能太差（ > 80% 时间花在 GC 上），被迫用 BCPL 重写。这段经历直接点燃了他创造一种兼具 Simula 抽象能力和 C 效率的语言的欲望
- 来源：[researchr.org](https://researchr.org/publication/ethos-9683) — 可信度 B；[dblp.org](https://dblp.org/rec/phd/ethos/Stroustrup79.html) — 可信度 B

---

## 贝尔实验室时代（1979-2002）—— C++ 的诞生与成熟

### 1979 — 加入贝尔实验室
- 加入 **AT&T 贝尔实验室计算机科学研究中心（Murray Hill, NJ）**
- 同年 4 月，开始分析 UNIX 内核的分布式网络扩展可能性
- 10 月，名为 **Cpre** 的预处理器开始工作，为 C 语言增加了类似 Simula 的 class 支持
- 来源：[stroustrup.com](https://stroustrup.com) — 可信度 A

### 1979-1983 — "C with Classes" 研发期

| 时间 | 里程碑 |
|------|--------|
| 1979.10 | Cpre 预处理器首次内部使用 |
| 1980.03 | 已在 16 个系统上支持真实项目 |
| 1980.04 | 第一份 "C with Classes" 技术报告发表 |
| 1982 | 《Adding Classes to the C Language》参考手册发布 |
| 1983 | 加入 virtual functions、function/operator overloading、references |

- 核心设计原则：在运行时效率、代码紧凑性、数据紧凑性上对标 C 语言（曾发现 3% 的 overhead 并当作 bug 修复）
- 来源：[stroustrup.com/hopl2.pdf](http://stroustrup.com/hopl2.pdf) — 可信度 A；《The Design and Evolution of C++》— 可信度 A

### 1983年12月 — C++ 命名
- **Rick Mascitti** 建议将 "C with Classes" 更名为 **"C++"**（++ 是 C 的自增运算符，象征改进后的 C）
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 1984 — Cfront 编译器完成
- 第一个 C++ 编译器 **Cfront** 完成
- 工作原理：将 C++ 源码翻译为 C，再由标准 C 编译器编译
- 主要用 "C with Classes" 编写
- 来源：[stroustrup.com](https://stroustrup.com) — 可信度 A

### 1985年10月 — 双里程碑：书籍 + 编译器发布
- **《The C++ Programming Language》第 1 版** 出版（Addison-Wesley）
- **Cfront 1.0** 商业发布
- 在没有正式标准的时代，这本书充当了事实上的语言参考
- 来源：[stroustrup.com/1st.html](https://web.archive.org/web/20230208153917/https://www.stroustrup.com/1st.html) — 可信度 A

### 1989 — 加入 ANSI/ISO C++ 标准化委员会
- 开始积极参与 C++ 标准化工作，持续至今
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 1990 — 《The Annotated C++ Reference Manual》（ARM）出版
- 与 **Margaret A. Ellis** 合著
- 作为 ANSI 标准化的基础文档
- 覆盖 C++ Release 2.0：multiple inheritance、abstract classes、templates、exception handling
- 来源：[thriftbooks.com](https://www.thriftbooks.com/w/the-annotated-c-reference-manual_bjarne-stroustrup_margaret-a-ellis/383721/) — 可信度 B

### 1993 — Cfront 退役
- C++ 语言复杂度增长（尤其是 exceptions），Cfront 的 C 语言翻译路线不再可行
- Cfront 4 个 release 后正式退役
- 同年 PVS-Studio 后来的静态分析发现其源码仅有少量 minor bugs
- 来源：[i-programmer.info](https://www.i-programmer.info/programming/cc/9212-finding-bugs-in-the-first-c-compiler-what-does-bjarne) — 可信度 B

### 1993 — ACM Grace Murray Hopper Award
- 因 C++ 的奠基性工作获奖
- 来源：[awards.acm.org](https://awards.acm.org/hopper/award-recipients) — 可信度 A

### 1994 — 《The Design and Evolution of C++》出版
- 从设计者的角度追述 C++ 的演变历程
- 涵盖 1979-1993 年的完整设计决策，包括被否决的特性
- 获得 Dr. Dobb's Productivity Award
- 来源：[bookshop.org](https://bookshop.org/p/books/the-design-and-evolution-of-c-bjarne-stroustrup/c41ff083ce25da30) — 可信度 B

### 1996 — 被任命为 AT&T Fellow
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 1998年11月 — C++98 正式发布（ISO/IEC 14882:1998）
- **第一个 C++ 国际标准**
- 在 Stroustrup 领导下由 ANSI/ISO 联合委员会（ANSI X3J16 + ISO WG21）完成
- 来源：[geeksforgeeks.org](https://www.geeksforgeeks.org/cpp/cpp-03-standard/) — 可信度 B

### 2001-2002 — 领导大规模编程研究部
- 担任贝尔实验室 **Large-Scale Programming Research Department** 主任直至 2002 年底
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

---

## 德州农工大学时代（2002-2014）—— 学术界回归

### 2002 — 加入 Texas A&M 大学
- 任 **College of Engineering Chair Professor in Computer Science**
- 原因：他感到"是时候做出改变了"，认为在大学"有一些东西可以教"
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2003 — C++03 标准发布
- 主要是 C++98 的 bug-fix 版本
- 仅新增 value initialization 一个特性
- 来源：[geeksforgeeks.org](https://www.geeksforgeeks.org/cpp/cpp-03-standard/) — 可信度 B

### 2004 — 入选美国国家工程院（NAE）
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2008 — 晋升 Distinguished Professor
- 德州农工大学最高学术职称
- 同年开始编写教材《Programming: Principles and Practice Using C++》
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 B

### 2009 — 《Programming: Principles and Practice Using C++》第 1 版出版
- 专为零编程经验者设计
- 基于他在 Texas A&M 讲授的工程新生编程课程
- 来源：stroustrup.com — 可信度 A

### 2011 — 被命名为 University Distinguished Professor（终身荣誉）
- 2011 年秋季在普林斯顿大学 CS 系学术休假
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2011年8月 — C++11 正式发布
> ==== 【分水岭：C++11 时代】 ====

- 原代号 **C++0x**（x 代表 2008 或 2009，暗示乐观预期），最终耗时 13 年
- C++ 历史上最大的更新：
  - move semantics、lambda expressions、auto、constexpr
  - nullptr、range-for、smart pointers、threading support
  - 标准库大幅扩展（hash tables、regex、random 等）
- 延迟原因（Stroustrup 自述）：
  - 委员会普遍误以为 ISO 规则要求在标准发布后等待一段时间才能启动新特性工作
  - 直到 2002 年才真正开始工作，浪费了约 4 年
  - 来源：[stroustrup.com](https://www.stroustrup.com) — 可信度 A；[dl.acm.org](https://dl.acm.org/doi/10.1145/1238844.1238848) — 可信度 A
- **关键转折点**：C++11 的长期延迟暴露了标准化流程的问题，促使委员会后续缩短发布周期

### 2012年春 — 剑桥大学计算机实验室学术休假
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2013 — 《The C++ Programming Language》第 4 版
- 全面更新以覆盖 C++11
- 来源：[informit.com](https://www.informit.com/store/c-plus-plus-programming-language-9780321563842) — 可信度 B

### 2014 — 《Programming: Principles and Practice Using C++》第 2 版
- 更新为 C++11/C++14
- 来源：[informit.com](https://www.informit.com/store/programming-principles-and-practice-using-c-plus-plus-9780133796735) — 可信度 B

---

## Morgan Stanley 时代 + 哥大兼任（2014-2022）—— 工业界回归

### 2014年1月 — 加入 Morgan Stanley + 哥伦比亚大学兼任
> ==== 【关键转折点：Texas A&M -> Morgan Stanley】 ====

- 加入 **Morgan Stanley** 技术部，任 **Managing Director**
- 同时担任 **哥伦比亚大学计算机系 Visiting Professor**
- 搬到纽约的原因之一是希望更靠近子女和孙辈
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2014 — 《A Tour of C++》第 1 版
- 为有经验的程序员提供 C++ 的快速概览
- 来源：[stroustrup.com](https://www.stroustrup.com) — 可信度 A

### 2015年9月 — C++ Core Guidelines 启动
- 在 **CppCon 2015** 主题演讲中公开宣布
- 与 **Herb Sutter**（微软，ISO C++ 委员会主席）联合发起
- 配套工具：**Guideline Support Library (GSL)** + 静态分析检查器
- 核心主张："在 C++ 内部，有一个更小、更简单、更安全的语言正在挣扎着出来"
- 来源：[isocpp.org](https://isocpp.org/blog/2015/09/bjarne-stroustrup-announces-cpp-core-guidelines) — 可信度 A；[github.com/isocpp/CppCoreGuidelines](https://github.com/isocpp/CppCoreGuidelines) — 可信度 A

### 2015 — Dahl-Nygaard Prize
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2017 — IET Faraday Medal + 剑桥丘吉尔学院 Honorary Fellow
- Faraday Medal 是 IET 最高荣誉
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2018 — 查尔斯·斯塔克·德拉普奖（Charles Stark Draper Prize）
- 美国工程院最高荣誉，被称为工程界的"诺贝尔奖"
- 奖金 $500,000
- C++ 是继 Fortran（John Backus, 1993）之后第二个获此奖项的编程语言
- 同年还获得 **IEEE Computer Pioneer Award** 和 **John Scott Legacy Medal**
- 来源：[isocpp.org](https://isocpp.org/blog/2018/02/bjarne-stroustrup-receives-draper-prize-engineerings-top-u.s.-honor) — 可信度 A

### 2019 — 晋升 Morgan Stanley 首位 Technical Fellow
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2020 — C++20 发布
- **concepts** 终于加入语言（Stroustrup 自 1980 年代就开始呼吁的语言特性）
- 同时包含 modules、coroutines、ranges、spaceship operator（<=>）
- 来源：[isocpp.org](https://isocpp.org) — 可信度 A

### 2021年1月 — 担任 Metaspex 技术顾问
- Metaspex：专注于从规约自动转换到高性能云应用的公司
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

---

## 哥伦比亚大学全职教授时代（2022-至今）—— 学术回归 + C++ 安全战场

### 2022年4月2日 — 从 Morgan Stanley 退休
- 退休以专注于非商业 C++ 工作、旅行和家庭
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2022年7月 — 哥伦比亚大学全职教授
> ==== 【关键转折点：Morgan Stanley -> 哥伦比亚大学全职教授】 ====

- 被任命为 **Columbia University 计算机科学系正教授**
- 来源：[engineering.columbia.edu](https://www.engineering.columbia.edu/faculty-staff/directory/bjarne-stroustrup) — 可信度 A

### 2022 — 《A Tour of C++》第 3 版
- 更新为 C++20
- 来源：[stroustrup.com](https://www.stroustrup.com) — 可信度 A

### 2023 — C++23 发布
- 头号特性：**标准库模块（`import std;`）**，编译速度提升 ~10 倍
- Stroustrup 评价："模块最终将成为我们组织代码方式中最重要的改进"
- 由于疫情影响，设计讨论受限，scope 较小
- pattern matching、contracts、executors 被推迟到 C++26
- 来源：[isocpp.org](https://isocpp.org/blog/2023/08/cpp23-the-next-c-standard-rainer-grimm) — 可信度 B

### 2024年4月 — 《Programming: Principles and Practice Using C++》第 3 版
- 大幅精简（约为第 2 版的一半）
- 全面采用 C++20/C++23
- 图形/GUI 章节基于 Qt 重写，支持浏览器和手机端运行
- 纯参考资料移入在线资源，引导读者使用 cppreference.com
- 来源：[stroustrup.com/PPP3.html](https://www.stroustrup.com/PPP3.html) — 可信度 A

### 2024年12月14日 — 复旦大学"21st Century C++"主题演讲
- 地点：复旦大学邯郸校区
- 内容：资源管理、错误处理、concept-based generic programming、模块化、性能优化
- 300+ 听众
- 来源：[cs.fudan.edu.cn](https://cs.fudan.edu.cn/a5/38/c24256a763192/page.htm) — 可信度 A

### 2025 — 入选 Kraks Blaa Bog 2025（丹麦《名人录》）
- 仅 ~8,000 名有影响力的丹麦人入选，2025 年仅 101 名新增
- 对计算机科学家而言是罕见荣誉
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2025年2月 — 发布 P3611R0（Pointer Error Safety）
- 针对指针错误的动态/静态检查提案
- 来源：[open-std.org](https://www.open-std.org/JTC1/SC22/WG21/docs/papers/2025/p3611r0.pdf) — 可信度 A

### 2025年3月 — 发布 P3651R0（Profiles are essential）
> ==== 【关键转折点：Profiles 安全路线成为 C++ 存亡之争】 ====

- 前所未有的紧急警告：**"Unprecedented, serious attacks on C++"**
- 面对美国 CISA/FBI 和欧盟监管机构对内存安全的强制要求
- 称 Profiles 是 **"essential for the future of C++"**
- 警告若无行动，C++ 将在新项目中遭弃用、研发投入减少
- 来源：[open-std.org](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2025/p3651r0.pdf) — 可信度 A

### 2025年5月 — Profiles 框架详案 P3704R0
- 明确的 Profiles 技术路线：opt-in、向后兼容、"subset-of-superset"
- 域特定：不同 profile 服务于教学、内存安全、资源安全、实时系统等
- 终极目标：**complete type safety**
- 来源：[open-std.org](https://www.open-std.org/JTC1/SC22/WG21/docs/papers/2025/p3704r0.pdf) — 可信度 A

### 2025年9月 — Safe C++ 提案被放弃
- WG21 投票结果：19 票支持 Profiles，9 票支持 Safe C++，11 票两者都要，6 票中立
- Stroustrup 批评 Safe C++：不是真正的 C++ 子集、只解决内存安全（而非更广泛的安全维度）、删除了"几乎所有好的/安全的 C++ 代码"
- Profiles 路线获胜，但同样未能进入 C++26
- 来源：[azalio.io](https://www.azalio.io/safe-c-proposal-for-memory-safety-flames-out/) — 可信度 B

### 2025年9月15日 — CppCon 2025 开幕主题演讲
- 主题：**"Concept-based Generic Programming"**
- 来源：[cppcon.org](https://cppcon.org/2025-keynote-bjarne-stroustrup/) — 可信度 A

### 2026年2月11日 — 个人简历更新
- 新增：担任 **YetiWare 高级顾问**（解决基础性并行编程问题）
- 来源：[stroustrup.com/bio.html](https://stroustrup.com/bio.html) — 可信度 A

### 2026年2月23日 — Columbia Engineering 人物专题
- 标题：**"The Mind Behind C++"**
- 回顾职业生涯、C++ 哲学、以及他关于"教工程师批判性思考而非仅仅用 AI 工具编码"的理念
- 来源：[engineering.columbia.edu](https://www.engineering.columbia.edu/about/news/mind-behind-c) — 可信度 A

### 2026年3月28日 — C++26 标准获批
- Herb Sutter 称其"自 C++11 以来最引人注目的版本"
- 包含：static reflection、contracts、std::execution、hardened standard library
- **Profiles 未能纳入**，Stroustrup 表示失望但承认"至少他们没有什么都不做"
- **C++29 时间表同步通过**
- 来源：[theregister.com](https://www.theregister.com/2026/03/31/cplusplus26_approved/) — 可信度 B

### 2026年3月 — Stroustrup 对 C++26 Contracts 的强烈反对
- 称 contracts "既不是最小，也不可行"
- 建议不要在实际项目中使用 C++ 的 contracts
- 批评：增加复杂性、代码含义因出现位置而异
- 最终通过：114 票赞成 / 12 票反对 / 3 票弃权
- 来源：[theregister.com](https://www.theregister.com/2026/03/31/cplusplus26_approved/) — 可信度 B

---

## 关键转折点总结

| 时间 | 转折点 | 意义 |
|------|--------|------|
| 1979 | 剑桥博士 -> 贝尔实验室 | 从分布式系统研究转向编程语言设计 |
| 1983 | C with Classes -> C++ 命名 | 语言正式诞生 |
| 2002 | 贝尔实验室 -> Texas A&M | 从工业界回归学术界，培养新一代程序员 |
| 2011 | C++11 发布 | 13 年沉寂后的最大爆发，语言现代化 |
| 2014 | Texas A&M -> Morgan Stanley + 哥大 | 短暂回到工业界，同时保持学术联系 |
| 2015 | C++ Core Guidelines 启动 | 系统性解决 C++ 安全问题的开端 |
| 2022 | Morgan Stanley -> 哥伦比亚全职教授 | 彻底回归学术 |
| 2025 | Profiles 安全提案 + Safe C++ 被放弃 | C++ 应对监管安全压力的路线抉择 |
| 2026 | C++26 获批但 Profiles 未纳入 | 安全争论持续，C++29 是下一个关键战场 |

---

## 时代分水岭

### C++11 时代（2011-2020）
- 特征：语言现代化（auto、move、lambda、threading）
- 关键行动：编写《The C++ Programming Language 4th》《Tour of C++》《PPP2》
- 核心事件：C++11 突破 13 年瓶颈、C++14/17 稳步迭代、C++Core Guidelines 发布
- 标志性成就：2018 年 Draper Prize（工程界诺贝尔奖）

### post-C++20 时代（2020-至今）
- 特征：安全主导（safety 取代特性扩展成为第一优先级）
- 关键行动：Profiles 提案、硬化的标准库、应对监管压力
- 核心事件：Safe C++ 提案的较量、Contracts 争议、C++26/29 路线博弈
- 标志性危机：美国 CISA/FBI（2024.10）将 C/C++ 标记为危险语言，2026年1月截止期
- 核心叙事转变：Stroustrup 从"语言创造者"转变为"语言保卫者"

---

## 当前状态（2026年5月）

### 任职
- **哥伦比亚大学计算机科学系 正教授**（2022.07-至今）
- **YetiWare 高级顾问**（2026.02-至今）
- **Metaspex 技术顾问**（2021.01-至今）

### 核心关注
1. **Profiles 安全框架**：争取在 C++29 中纳入
2. **C++ 监管应对**：面对 CISA/FBI、欧盟的强制安全要求
3. **教学与写作**：在哥大授课，持续更新著作
4. **标准化工作**：活跃在 WG21，影响语言演进方向

### 已知未证实信息
- 尚未发现 2025-2026 年有新书写作计划
- Profiles 的具体实现尚未有任何编译器支持
- 行业趋势：45% 的新安全关键项目已转向 Rust（2026 Linux Foundation 调查）

---

## 来源索引

| URL | 可信度 |
|-----|--------|
| [stroustrup.com/bio.html](https://www.stroustrup.com/bio.html) | A — 官方简历 |
| [stroustrup.com/interviews.html](https://www.stroustrup.com/interviews.html) | A — 官方访谈索引 |
| [stroustrup.com/papers.html](https://www.stroustrup.com/papers.html) | A — 官方论文列表 |
| [engineering.columbia.edu/faculty/bjarne-stroustrup](https://www.engineering.columbia.edu/faculty-staff/directory/bjarne-stroustrup) | A — 哥大教职员页 |
| [isocpp.org](https://isocpp.org) | A — C++ 官方资讯站 |
| [open-std.org (WG21 papers)](https://www.open-std.org/JTC1/SC22/WG21/docs/papers/2025/) | A — 标准委员会论文 |
| [github.com/isocpp/CppCoreGuidelines](https://github.com/isocpp/CppCoreGuidelines) | A — 官方仓库 |
| [cs.fudan.edu.cn](https://cs.fudan.edu.cn/a5/38/c24256a763192/page.htm) | A — 复旦大学官方 |
| [cppcon.org](https://cppcon.org) | A — CppCon 官方 |
| [dl.acm.org (HOPL paper)](https://dl.acm.org/doi/10.1145/1238844.1238848) | A — ACM 论文 |
| [awards.acm.org](https://awards.acm.org/hopper/award-recipients) | A — ACM 奖项 |
| [isocpp.org Draper Prize](https://isocpp.org/blog/2018/02/bjarne-stroustrup-receives-draper-prize-engineerings-top-u.s.-honor) | A — isocpp 报道 |
| [theregister.com](https://www.theregister.com/2026/03/31/cplusplus26_approved/) | B — The Register 报道 |
| [azalio.io Safe C++](https://www.azalio.io/safe-c-proposal-for-memory-safety-flames-out/) | B — Azalio 报道 |
| [handwiki.org](https://handwiki.org/wiki/Biography:Bjarne_Stroustrup) | B — 综合百科 |
| [researchr.org / dblp.org](https://researchr.org/publication/ethos-9683) | B — 学术数据库 |

---

*本文档是 Bjarne Stroustrup Persona Skill 的组成部分，用于支撑其思维框架和时间线推理。*
