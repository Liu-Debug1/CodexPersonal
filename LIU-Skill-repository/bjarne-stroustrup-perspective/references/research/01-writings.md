# Bjarne Stroustrup 著作与系统思考调研报告

> 调研日期：2026-05-24
> 调研范围：著作、核心论点、自创术语、重要论文、C++ 各版本设计目标、C++ Core Guidelines 主导思想
> 可信度标记：一手(1°) / 二手(2°) / 推测(?)

---

## 一、出版的著作

### 1.1 The C++ Programming Language（C++ 圣经）

| 版本 | 年份 | ISBN | 页数 | 覆盖标准 | 备注 |
|------|------|------|------|----------|------|
| 1st | 1985.10 | 0-201-12078-X | ~328 | 初始 C++ | 第一本完整描述 C++ 的书 |
| 2nd | 1991.07 | 0-201-53992-6 | ~696 | 2.0 时代 | 反映语言演化 |
| 3rd | 1997.06 | 0-201-88954-4 | ~920 | C++98 前夕 | 含 Templates、STL |
| Special | 2000.02 | 0-201-70073-5 | ~1,029 | C++98 | 3/e 的精装版 + 两个新附录 |
| 4th | 2013.05 | 0-321-56384-0 | ~1,360 | C++11 | 最新版，覆盖 move semantics、并发等 |

**说明**：4/e 是当前最新版本，Stroustrup 表示不再出下一版，转向 A Tour of C++ 体系。（1° — Stroustrup 官网）

### 1.2 The Design and Evolution of C++ (1994)

- **出版**：1994, Addison-Wesley, ISBN 0-201-54330-3
- **定位**：解释 C++ "为什么是现在这个样子" 的必读书
- **起源**：基于 1993 年 ACM HOPL-II 会议论文扩展而来
- **核心章节**：
  - "C with Classes" (1979-1983) 起源
  - C++ 1.0/2.0 演化
  - 设计目标与约束（第 1.3 节系统阐述世界观）
  - ANSI/ISO 标准化工作
- **哲学根源**：Stroustrup 公开承认受亚里士多德（经验论）多于柏拉图（理念论）、休谟多于笛卡尔；参考文献含小说家（Martin A. Hansen、Albert Camus、George Orwell）多于计算机科学家
- **可信度**：1°（Stroustrup 本人撰写）

### 1.3 The Annotated C++ Reference Manual（ARM, 1990）

- **合著者**：Margaret A. Ellis
- **出版**：1990, Addison-Wesley, ISBN 0-201-51459-1
- **页数**：x + 447
- **定位**：ANSI C++ 标准的基础文档（"ANSI base document"）
- **内容**：完整的参考手册 + 注解（解释未包含的特性、设计决策理由、实现技术）
- **目标读者**：语言实现者和专家程序员，非初学者
- **历史地位**：常被社群称作 "the ARM"，是 C++ 标准化早期最重要的技术文档
- **可信度**：1°（Stroustrup 合著）

### 1.4 Programming: Principles and Practice Using C++（PPP）

| 版本 | 年份 | ISBN | 页数 | 覆盖标准 | 备注 |
|------|------|------|-------|----------|------|
| 1st | 2008.12 | 978-0-321-54372-1 | 1,264 | C++98/03 | 面向初学者的入门教材 |
| 2nd | 2014.05 | 978-0-321-99278-9 | 1,312 | C++11 | 获 Dr. Dobb's Jolt 生产力奖 |
| 3rd | 2024.04 | 978-0-13-681648-5 | 656 | C++20/23 | 大幅精简，GUI 改用 Qt |

**第 3 版重大变化**：
- 页码从 1,312 减至 656，约一半
- 专业章节移至线上
- 图形/GUI 库从 FLTK 改为 Qt（跨平台，支持浏览器/手机）
- 支持 Modules（`import std;` / `module PPP;`）
- 纯参考资料移除（指向 cppreference.com）
- 可信度：1°（stroustrup.com/PPP3.html）

### 1.5 A Tour of C++（导览）

| 版本 | 年份 | 页数 | 覆盖标准 |
|------|------|------|----------|
| 1st | 2013.09/2014 | ~190 | C++11 |
| 2nd | 2018.07 | ~240 | C++17 + C++20 预览 |
| 3rd | 2022.09 | ~300 | C++20 + C++23 预览 |

**定位**：面向有经验的程序员的 C++ 快速概览，非入门教材。Stroustrup 明确推荐搭配路线为：Tour → PPP → TC++PL。（1°）

### 1.6 C++ In-Depth Series（主编）

- **角色**：Bjarne Stroustrup 担任 Addison-Wesley 此系列的 Consulting Editor
- **第一批选入的书目**（2002 年盒装）：
  1. *Modern C++ Design* — Andrei Alexandrescu
  2. *Accelerated C++* — Andrew Koenig & Barbara Moo
  3. *Essential C++* — Stanley Lippman
  4. *Exceptional C++* — Herb Sutter
  5. *More Exceptional C++* — Herb Sutter
- **系列后续**：A Tour of C++ 本身也属于此系列
- **可信度**：1°（Amazon / 出版商数据、2° 多源交叉验证）

---

## 二、反复出现的核心论点（真信念）

以下论点在 Stroustrup 的著作、演讲、访谈中出现 >=3 次，可视为他的"真信念"。

### 2.1 Zero-Overhead Abstraction（零开销抽象）

> "What you don't use, you don't pay for. And further: What you do use, you couldn't hand code any better."

两条子规则：
1. **零使用零开销**：不用的特性不产生运行时/空间开销
2. **零开销抽象**：使用的抽象不可比手写低阶代码更差

**体现**：virtual 关键字必须显式声明、POD 类型按需初始化、异常不抛则零开销、无强制 GC。这是 C++ 区别于更"便利"语言的存在理由。（1° — D&E, HOPL-IV, CppCon）

### 2.2 "Leave no room for a lower-level language below C++ (except asm)"

> "C++ must maintain C's ability to access hardware directly, to control data structure layout, and to have primitive operation and data types that map on to hardware in a one-to-one fashion."

出自 D&E，在 2024 年 WG21 论文 P3466R0（Sutter）中重申。核心含义：C++ 必须提供足够的底层能力，使开发者不需要为了性能而求助于 C 或汇编。（1° — D&E; P3466R0; 2° — Sutter 的确认）

### 2.3 "C++ is a language for building systems"

C++ 定位为系统编程语言，而非应用层胶水语言。Stroustrup 反复强调 C++ 适用于"infrastructure"（基础设施）级别的软件开发。

### 2.4 Type Safety + Resource Safety（类型安全与资源安全）

Stroustrup 从 2015 年 CppCon 起（至 CppCon 2023）反复宣称：
> "You can write C++ programs that are **statically type safe** and have **no resource leaks**. You can do that **without loss of performance** and **without limiting C++'s expressive power**. This supports the general thesis that **garbage collection is neither necessary nor sufficient** for quality software."

**关键断言**：GC 对安全而言既非必要（RAII + 静态分析足够）也不充分（GC 不防悬挂指针、逻辑错误）。

此论点至少在以下场合重复出现（时间跨度 2015-2023）：
- CppCon 2015 keynote
- 2015 年与 Sutter/Dos Reis 合著论文
- STAC Summit 2016
- OSSF 2019
- P2816R0 WG21 论文 (2023)
- CppCon 2023 "Delivering Safe C++"
- 可信度：1°

### 2.5 "Don't pay for what you don't use"

Zero-overhead principle 的另一种表述。在 D&E 中列为"the most fundamental design principle"。

### 2.6 "C++ 的最大优点和最大缺点都是 C 兼容性"

> "C++'s greatest strength and its greatest weakness has been its C compatibility."

兼容 C 带来了庞大军团（代码库、工具链、程序员），也继承了 C 的语法包袱和不安全习惯。此论点多处重复。
可信度：1°（D&E, HOPL 论文）

### 2.7 "Languages are grown, not designed from first principles"

> "All successful languages are grown and not merely designed from first principles. Principles underlie the first design and guide the further evolution of the language. However, even principles evolve."

此论点贯穿 D&E 全书，是对 "idealist language design"（试图从数学纯原则构建语言）的直接拒绝。
可信度：1°

### 2.8 "Make simple things simple"（Onion Principle）

出自 HOPL-IV 论文。Stroustrup 主张语言应该让简单的事情简单做，复杂的事情才能做好（不是做不到）。这也是他对抗 C++ "太复杂"批评的核心防御。

### 2.9 "Trust the programmer"

> "C++ trusts the programmer. It doesn't protect you from yourself."

这是与 Java/Rust 设计哲学的鲜明对比。Stroustrup 认为程序员应被当作有能力做正确选择的专业人士，不应被强制性语言限制约束。但同时他也承认："Being able to do every trick is not a feature but a bug."
可信度：1°

### 2.10 多范式的执着

> "Object-oriented programming is where you use class hierarchies... Some good abstractions don't use class hierarchies and are well expressed without them."

四个受支持的范式：
1. Procedural programming（过程式）
2. Data abstraction（数据抽象）
3. Object-oriented programming（面向对象）
4. Generic programming（泛型编程）

C++ 从未被设计为纯 OOP 语言。（1° — Artima 访谈系列）

---

## 三、自创术语与概念

### 3.1 RAII（Resource Acquisition Is Initialization）

- **设计者**：Bjarne Stroustrup（1984-1989 年间开发）
- **命名者**：术语由 Stroustrup 本人提出，时间约在 1990 年论文中首次书面出现
- **核心思想**：资源获取在构造函数完成，释放由析构函数保证——利用栈展开机制实现确定性资源管理
- **历史意义**：证明确定性析构比 GC 更强大（对于非内存资源），直接启发了 Rust 的 `Drop` trait
- **名称争议**：Stroustrup 后来承认名字起得不好——它描述的是"获取"（what happens），而非更有价值的"释放"（the benefit）。备选名包括 CADRe（Constructor Acquires, Destructor Releases）和 SBRM（Scope-Based Resource Management）
- **可信度**：1°（Stroustrup 1989 论文 except89.pdf; D&E; InformIT 访谈）

### 3.2 "C with Classes" → "C++"

- "C with Classes" 是 1979-1983 年使用的名称
- "C++" 于 1983 年秋冬最终确定，由 Rick Mascitti 提议，类属递增运算符意味语言是 C 的"递增版"
- 最初名字有争议，Stroustrup 自己也不太喜欢，但找不到更好的
- 可信度：1°（HOPL-II 论文; D&E）

### 3.3 `struct` is a `class`

> "The 'a struct is a class' notion is what has stopped C++ from drifting into becoming a much higher-level language with a disconnected low-level subset."

确保 struct 和 class 是同一概念（仅默认访问权限不同），使 C++ 不会分裂为"高层 OO 语言"和"底层 C 子集"两个世界。此决策保护了 Unix 头文件的后向兼容。
可信度：1°（D&E）

### 3.4 Other C++ design terms

- **"Onion principle"** — 语言应像洋葱，有很多层，不同用户使用不同层
- **"Train model"** — C++ 标准发布采用定时火车模型（每 3 年一班），用于 HOPL-IV 讨论
- **"Zero-overhead abstraction"** — 虽然术语后来被 Rust 等语言借用，但 Stroustrup 是最早将其作为核心设计原则系统化的人
- **可信度**：1°

---

## 四、重要论文与 ISO 标准提案

### 4.1 HOPL 系列（历史回顾记录，最权威的 C++ 发展史）

| 论文 | 年份 | 覆盖时期 | 长度 |
|------|------|----------|------|
| "A History of C++: 1979–1991" | HOPL-II, 1993 | 1979-1991 | 27pp |
| "Evolving a language in and for the real world: C++ 1991–2006" | HOPL-III, 2007 | 1991-2006 | 59pp |
| "Thriving in a crowded and changing world: C++ 2006–2020" | HOPL-IV, 2020 | 2006-2020 | 168pp |

三篇连续覆盖 40+ 年 C++ 历史，是理解 C++ 设计目标的权威一手资料。
可信度：1°（ACM 数字图书馆）

### 4.2 安全相关 WG21 提案（2021-2026）

| 编号 | 年份 | 主题 |
|------|------|------|
| P2410R0 | 2021 | Type-and-resource safety in modern C++ |
| P2739R0 | 2022 | A call to action: Think seriously about "safety" |
| P2816R0 | 2023 | Safety Profiles: Type-and-resource Safe programming |
| P3572R0 | 2025 | Pattern matching |
| P3651R0 | 2025 | Dealing with pointer errors |
| D3704R0 | 2026 | A type-safety profile |
| P3970R0 | 2026 | Profiles and Safety: a call to action |

### 4.3 C++11 关键提案（Stroustrup 主导或深度参与）

- **N1984** — `auto` type deduction（接受）
- **N1978** — `decltype`（接受）
- **N1980** — generalized constant expressions / `constexpr`（接受）
- **N2214** — `nullptr`（与 Herb Sutter 合写，接受）
- **N2532** — uniform initialization（接受）
- **N2679** — initializer lists for standard containers（接受）
- **N3044** — defining move special member functions（接受）

### 4.4 Concepts 相关

- **N3580 (2013)** — Concepts Lite: Constraining Templates with Predicates
- **P0557R1 (2017)** — Concepts: The Future of Generic Programming
- **OOPSLA'06** — "Concepts: Linguistic Support for Generic Programming in C++"（合作：Gregor, Jarvi, Siek, Dos Reis, Lumsdaine）
- **POPL'06** — "Specifying C++ Concepts"（与 Gabriel Dos Reis）
- **SLE 2011** — "Design of Concept Libraries for C++"（与 Andrew Sutton）→ 获 ACM SIGPLAN Most Influential Paper Award (2021)
- **2025 arXiv** — "Concept-based Generic Programming in C++"

### 4.5 方向性论文

- **P0939 series** — Direction for ISO C++（多版迭代）
- **P2000 series** — Direction for ISO C++（当前活跃）
- **P0684R0** — C++ Stability, Velocity, and Deployment Plans（与 Titus Winters 等）
- **P0542R0 (2017)** — Support for contract based programming
- **P1947R0 (2019)** — C++ exceptions and alternatives

### 4.6 学术论文

- **"Exception Safety: Concepts and Techniques"** (2001, Springer LNCS-2022) — 定义了异常安全三保证：
  - Basic guarantee（基本保证：保持不变量，无资源泄漏）
  - Strong guarantee（强保证：失败操作无效果）
  - Nothrow guarantee（不抛保证）
- **"A brief introduction to C++'s model for type- and resource-safety"** (2015, 与 Sutter/Dos Reis) — Core Guidelines 的理论基础
- **"21st Century C++"** (2025, Blog@CACM)

### 4.7 GSL（Guidelines Support Library）

- 与 Core Guidelines 同时发布（2015 CppCon）
- 核心类型：
  - `gsl::span<T>` → C++20 标准化为 `std::span`（但 GSL 版强制边界检查）
  - `gsl::not_null<T>` — 禁止空指针，未进入标准
  - `gsl::owner<T*>` — 所有权标注，零运行时开销，仅供静态分析使用
  - `gsl::byte` → C++17 标准化为 `std::byte`
- 主要实现：Microsoft 的 header-only 库（github.com/microsoft/GSL）
- 可信度：1°（isocpp.org; WG21 论文）

---

## 五、对各 C++ 版本的设计目标阐述

### 5.1 C++98（第一个国际标准）

**设计目标**：
- 稳定语言（此前已在实际使用中多年）
- 标准化 STL（Stepanov 的贡献，Stroustrup 称之为 "saved C++"）
- 形式化 Templates、Exceptions、RTTI

**Stroustrup 的评价**：STL 和泛型编程技术"拯救了 C++，使其能够成长为一门充满活力的现代语言"。（1°）

### 5.2 C++11（"Feels like a new language"）

**设计目标**：
- 简化使用同时增强表达能力
- 原生支持并发（memory model + threads）
- 改进编译期计算（constexpr）
- 消除不必要的拷贝（move semantics）
- 统一初始化语法

**Stroustrup 的评价**："C++11 是 C++ 的一个重要新版本，让 C++ 感觉像一门新语言。"体现了 zero-overhead 原则的扩展。

### 5.3 C++14（"Completing C++11"）

**设计目标**：
- 基于实际使用经验完善 C++11 特性
- 修复问题，填补空白
- 不引入重大新范式

**Stroustrup 的评价**："相对较小的改进，完成了 C++11 的工作。"体现"don't pursue perfection but provide transition paths"原则。

### 5.4 C++17（"Lost at Sea" / "大海迷航"）

**设计目标**：
- 解决实际编程痛点（filesystem, variant, optional）
- 引入更多函数式和现代编程范式
- 完善并发支持

**Stroustrup 的评价**："Lost at Sea" — 委员会在此周期中方向争论严重，进展艰难。

### 5.5 C++20（"Direction Disputes"）

**设计目标**：
- Concepts（Stroustrup 自 1988 年以来的个人项目，最终以"Concepts Lite"路线实现）
- Modules（替代 #include 预处理模型）
- Coroutines（原生异步编程）
- Ranges（组合式、惰性求值）

**Stroustrup 的评价**：Concepts 将改变人们对泛型编程的思维方式。但同时承认委员会在方向上缺乏共识。

### 5.6 C++23（增量改进）

**设计目标**：
- 完善 C++20 特性
- 扩展标准库（expected, generator）
- 完善 Modules（`import std`）
- Deducing `this`

**Stroustrup 的评价**：相对温和的版本，符合三年发布节奏。可信度：1°（HOPL-IV 论文; WG21）

---

## 六、C++ Core Guidelines 主导思想

### 6.1 发起

- 2015 年 9 月 CppCon 开幕主题演讲上由 Stroustrup 宣布
- 发布后 GitHub 上立即成为 #1 trending 仓库
- 合著者/主编：Bjarne Stroustrup + Herb Sutter
- 初始贡献者来自 CERN、Microsoft、Morgan Stanley

### 6.2 三大支柱

1. **Type safety**（类型安全） — 完整静态检查 + 静态无法覆盖处使用运行时检查
2. **Resource safety**（资源安全） — 无资源泄漏（内存、文件句柄、锁等）
3. **Elimination of avoidable complexities and inefficiencies**（消除不必要的复杂性和低效）

### 6.3 核心理念规则（Philosophy section P）

| 规则 | 内容 |
|------|------|
| P.1 | Express ideas directly in code（用代码直接表达想法） |
| P.2 | Write in ISO Standard C++（写在 ISO 标准内） |
| P.3 | Express intent（表达意图） |
| P.4 | Ideally, a program should be statically type safe（理想状态下程序静态类型安全） |
| P.5 | Prefer compile-time checking to run-time checking（优先编译期检查） |
| P.6 | What cannot be checked at compile time should be checkable at run time（编译期无法检查的应运行时检查） |
| P.7 | Catch run-time errors early（尽早捕获运行时错误） |
| P.8 | Don't leak any resource（不泄漏任何资源） |
| P.9 | Don't waste time or space（不浪费时间和空间） |
| P.11 | Encapsulate messy constructs（封装混乱的结构） |

### 6.4 实现机制

- **RAII** — "since 1979, and still the best"
- **所有权抽象** — `unique_ptr`, `shared_ptr`, `vector`, `string`, `lock_guard` 等
- **GSL** — `owner<T>`, `span<T>`, `not_null<T>`
- **静态分析** — 扩展类型系统，编译期捕获生命周期和所有权违例
- **Lifetime safety rules** — 指针不过活其所有者

### 6.5 Stroustrup 的主导断言

> "Following the rules will lead to code that is **statically type safe**, has **no resource leaks**, and catches many more programming logic errors than is common in code today. And it will run fast — you can afford to do things right."

可信度：1°（Core Guidelines 仓库; isocpp.org）

---

## 七、GSL（Guidelines Support Library）

### 7.1 概述

GSL 是 Core Guidelines 的配套库，由 Microsoft 主导实现（header-only）。
- 类型：`span<T>`, `not_null<T>`, `owner<T*>`, `string_span`, `zstring`, `byte` 等
- 设计原则：零开销（尽可能使用编译器优化而非运行时检查）

### 7.2 标准化状态

| 类型 | 状态 |
|------|------|
| `gsl::byte` | C++17 标准化为 `std::byte` |
| `gsl::span` | C++20 标准化为 `std::span`（去掉了强制边界检查） |
| `gsl::not_null` | 未标准化 |
| `gsl::owner` | 未标准化，仅供静态分析 |
| `gsl::finally` | 未标准化 |

### 7.3 关键差异：gsl::span vs std::span

- `gsl::span` 在 debug 模式下强制边界检查
- `std::span`（C++20）不强制边界检查（零开销原则的 trade-off）

---

## 八、发现的知识点与矛盾点

### 8.1 需要进一步确认的点

1. **N4186 — GSL 标准提案**：未能在本次调研中找到确切来源。可能是 WG21 的早期论文编号，但需要直接查阅 WG21 论文列表确认。待补。
2. **"C++ In-Depth Series" 完整书目**：除了首批 5 本和后来的 Tour，中间是否有其他入选书，多源信息不一致，需进一步核实。
3. **Stroustrup 在 WG21 中的具体角色**：他是活跃成员和方向性论文的主要作者，但在委员会中他经常提及的"缺乏共同愿景"与他作为创世者的权威之间存在张力。他是否有正式职务（如 Chair 或 Study Group convener）待确认。

### 8.2 矛盾点

1. **C++ 复杂性的矛盾**：
   - Stroustrup 一面说 "Within C++, there is a much smaller and cleaner language struggling to get out"（承认 C++ 过度复杂）
   - 一面说 "The world is VERY complex, and to some extent the tools we use reflect that"（辩护复杂性）
   - 一面又说委员会"lacks a shared vision"导致特性膨胀
   - 这三个立场并存但存在张力，他自己并未调和

2. **"Don't pay for what you don't use" vs. C++ 的整体复杂性**：
   - 按 zero-overhead 原则，不用的特性应该零开销——但"学习"和"理解"的认知开销不是零
   - Stroustrup 承认这一点，但从未给出令人满意的调和，只是说 "you don't need to learn it all"
   - 批评者认为这是回避问题：不用的特性仍然出现在错误信息、库接口、他人代码中

3. **C 兼容的双刃剑**：
   - Stroustrup 明确承认 C 兼容性既是最大优点也是最大缺点
   - 但他从未提出过"切断 C 兼容"的认真提议（甚至反对）
   - 在安全倡导中，他主张用类型系统 + RAII + 静态分析避免 C 风格的陷阱，而非移除 C 兼容性

4. **GC 的立场演变**：
   - C++98/11 时代，Stroustrup 认为 GC 在 C++ 中应有合理位置（甚至标准委员会考虑过加入 GC 支持）
   - 2015 年后，他转为断言 "GC is neither necessary nor sufficient for quality software"
   - 立场转变的精确时机和原因可能需要 HOPL-IV 论文进一步确认
   - 推测：2015 年 Core Guidelines 的提出标志着这一转变的公开化

---

## 九、来源索引

### 一手来源（Stroustrup 本人撰写/发表）

| 来源 | URL | 类型 |
|------|-----|------|
| Books page | stroustrup.com/books.html | 著作列表 |
| Papers page | stroustrup.com/papers.html | 论文列表 |
| WG21 papers | stroustrup.com/WG21.html | 标准提案 |
| HOPL-II (1993) | dl.acm.org/doi/10.1145/155360.155375 | 历史回顾 |
| HOPL-III (2007) | dl.acm.org/doi/10.1145/1238844.1238848 | 历史回顾 |
| HOPL-IV (2020) | dl.acm.org/doi/10.1145/3386320 | 历史回顾 |
| D&E (1994) | ISBN 0-201-54330-3 | 设计哲学 |
| Type & Resource Safety (2015) | isocpp.org/blog/2015/10/type-and-resource-safety | 安全模型 |
| Exception Safety (2001) | Springer LNCS-2022 | 异常安全 |
| PPP3 page | stroustrup.com/PPP3.html | 教材信息 |
| Core Guidelines | github.com/isocpp/CppCoreGuidelines | 编码规范 |
| P2816R0 (2023) | open-std.org/JTC1/SC22/WG21/docs/papers/2023/p2816r0.pdf | 安全提案 |
| C++ Myths (2014) | isocpp.org/blog/2014/12/five-popular-myths-about-c-bjarne-stroustrup | 反驳批评 |

### 二手来源（他人总结/评论）

| 来源 | URL | 类型 |
|------|-----|------|
| Wikipedia "The C++ Programming Language" | en.m.wikipedia.org/wiki/The_C++_Programming_Language | 版本信息 |
| Wikipedia "Bjarne Stroustrup" | en.m.wikipedia.org/wiki/Bjarne_Stroustrup | 生平 |
| Artima 访谈系列 (2003-2004) | artima.com | 多范式设计 |
| InformIT 访谈 (2013) | informit.com/articles/article.aspx?p=2080042 | RAII 命名 |
| Software Engineering SE | softwareengineering.stackexchange.com | 设计原则讨论 |
| P3466R0 (Sutter, 2024) | open-std.org/jtc1/sc22/wg21/docs/papers/2024/p3466r0.pdf | 零开销重申 |
| DeepWiki (isocpp/CppCoreGuidelines) | deepwiki.com/isocpp/CppCoreGuidelines | Core Guidelines 解析 |

---

## 附录：调研方法说明

1. 信息源优先级：Stroustrup 官网 > ACM DL > isocpp.org > WG21 论文 > Amazon/O'Reilly 目录 > 技术博客
2. 黑名单：知乎、微信公众号、百度百科未使用（按用户要求）
3. 可信度标准：一手(1°) = Stroustrup 本人书写/演讲；二手(2°) = 经多人独立验证的公开信息；推测(?) = 单源信息或推理
4. 矛盾的保留：第 8 节中的矛盾均直接记录，不做调和处理
