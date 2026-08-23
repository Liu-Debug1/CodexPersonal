---
title: "高亮边界测试"
source: "https://example.com/read?token=a==b&next=c==d"
created: 2026-08-18
tags:
  - "fixture"
---

# 高亮边界测试

## Article

Realistic optimism is not ==complacency==.
%%现实的乐观主义并不等于自满。%%

The analyst called the outlook ==uncertain== but refused to panic.
%%分析师称前景不确定，但拒绝陷入恐慌。%%

A reviewer ==pushed back against the== claim that every setback is permanent.
%%一位评论者反驳了“每次挫折都是永久性的”这一说法。%%

==When directly compared or weighted against each other, losses loom larger than gains.==
%%当损失和收益被直接比较或权衡时，损失在心理上的分量会大于收益。%%

The string `==ignored_inline==` is code, not a learning highlight.

```text
==ignored_fenced==
```

[原文链接](https://example.com/article?x==y&z==q)

# 复盘总结

## 1. translation

### 单词与词组

1. `complacency`（n. 名词）
   - 语境义：自满；对现状过度满意而缺乏警惕。
   - 句中作用：作表语，说明 realistic optimism（现实的乐观主义）不等同于自满。

2. `uncertain`（adj. 形容词）
   - 语境义：不确定的；前景未明的。
   - 句中作用：作宾语补足语，说明分析师对 outlook（前景）的判断。

3. `pushed back against the`（动词短语，短语动词 `push back against` 的一般过去时）
   - 结构：`push back against + 名词`，表示反驳、抵制或反对某个观点；此处 `the` 后接名词 `claim`。
   - 语境义：反驳了/对……提出质疑。

### 长难句

4. `When directly compared or weighted against each other, losses loom larger than gains.`
   - 主干：`losses loom larger than gains`，主语是 `losses`，谓语是 `loom`，`larger than gains` 是比较结构。
   - 从句/修饰：句首 `When directly compared or weighted against each other` 是时间/条件状语从句的省略形式；完整理解为“当（损失和收益）被直接比较或权衡时”。`compared` 与 `weighted` 为过去分词，逻辑主语与主句主语 `losses`、`gains` 指同一组对象。
   - 关键表达：`loom larger than` 表示“显得更重要/分量更大”，不只是物理尺寸更大。
   - 语境翻译：当损失和收益被直接比较或权衡时，损失在人们心中的分量往往显得大于收益。

### 覆盖检查

- 正文有效高亮：4 处，按顺序为 `H01 complacency`、`H02 uncertain`、`H03 pushed back against the`、`H04 When directly compared or weighted against each other, losses loom larger than gains.`。
- 已排除：YAML `source` 中 URL 的 `==`、正文链接 URL 中的 `==`、行内代码 `` `==ignored_inline==` ``、fenced code 中的 `==ignored_fenced==`，以及推荐阅读 URL 的查询参数；它们均未作为学习词条。
- 未发现奇数分隔符或跨边界异常；原文中的等号和代码内容未擅自修改。

## 2. construction

### 主题与核心观点

短文说明“现实的乐观”不等于盲目自满或惊慌失措：面对不确定前景和挫折，应保持有依据的判断，并认识到人们在直接比较时往往会更看重损失。

### 行文脉络

1. 先用对比句界定概念：`realistic optimism` 与 `complacency` 不同，先排除“乐观就是自满”的误解。
2. 接着引入具体判断场景：分析师承认前景 `uncertain`，但 `refused to panic`，展示面对不确定性的克制态度。
3. 随后转向对绝对化主张的反驳：评论者 `pushed back against the claim`，不接受“每次挫折都是永久的”这一结论。
4. 最后用损失与收益的比较规律收束：在直接比较或权衡时，损失的心理分量会显得更大，为前面的谨慎、非灾难化态度提供认知层面的解释。

## 3. synonym

### 文章中的同义证据

- **未发现足够证据形成可靠的基本同义词或同义词组**。正文中的 `complacency`、`uncertain`、`pushed back against` 和长句分别承担“自满”“不确定”“反驳”“损失偏重”的不同语义功能，不能互换。
- `optimism` 与 `complacency` 是概念区分/对照，不是同义词：前者可表示积极但审慎的态度，后者带有不当自满意味。
- `losses` 与 `gains` 是反义对照（损失 ↔ 收益），不是同义替换；保留该说明以避免把文章的对比关系误判为同义关系。

---

*The End*

## 推荐阅读

[另一篇](https://example.com/recommend?foo==bar)
