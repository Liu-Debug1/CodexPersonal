---
name: mubu-diet-recorder
description: Use this skill whenever the user reports what they ate, asks to calculate calories/macros, wants diet tracking during fat loss/muscle gain, or mentions writing daily intake to 幕布/今日速记. It calculates today's cumulative calories, carbohydrates, and protein, then records only the top summary cells in the user's Mubu daily note via Chrome when possible.
---

# Mubu Diet Recorder

Use this skill to turn the user's meal reports into a running daily nutrition total and record it in Mubu.

The user's workflow is:

1. The user reports a meal or snack in chat.
2. Calculate the meal's calories, carbohydrates, and protein.
3. Read or infer today's existing cumulative total.
4. Update Mubu `今日速记 -> 当天日期 -> 饮食` top summary table only:
   - Row `今日热量摄入`: total calories
   - Row `碳水`: total carbohydrates
   - Row `蛋白质`: total protein
5. Reply with the updated totals and the next-meal recommendation.

Do not update the lower `Food / 热量 / 蛋白质 / 碳水 / 脂肪` detail table unless the user explicitly asks for detail-table editing.

## Capability Routing

- Prefer the Chrome plugin (`chrome:control-chrome`) for Mubu writing.
- Use the user's existing Chrome login session. Do not inspect cookies, local storage, passwords, or session stores.
- If Chrome cannot connect, times out, or the Mubu page cannot be verified, report that writing failed and keep the calculated totals in the chat.
- Do not silently switch to Computer Use or the Mubu desktop app. Ask for explicit permission before using desktop/window control because it can interfere with the user's mouse and keyboard.
- If the task is only nutrition calculation and the user does not ask to record it, calculate and answer without opening Mubu.

## Mubu Write Target

Target page:

- Mubu daily note: `https://mubu.com/app/dailyNotes/...`
- Section: `饮食`
- Table: the small top summary table above the food detail table.
- Write only the right-side blank/value cells for:
  1. `今日热量摄入`
  2. `碳水`
  3. `蛋白质`

Expected values:

- `今日热量摄入`: e.g. `350kcal`
- `碳水`: e.g. `48g`
- `蛋白质`: e.g. `16g`

Before writing:

- Verify the visible page date matches today's date in the user's timezone unless the user explicitly names another date.
- Verify the `饮食` section and the small summary table are visible or detectable.
- Prefer reading existing values from the summary table and adding the new meal. If the summary cells are blank, treat current total as zero.
- If the user says this is a correction, replacement, or "今天是新的一天", overwrite instead of adding as appropriate.

After writing:

- Verify the three summary values are visible in the correct table.
- Keep the Mubu tab open if it was an existing user tab or the user may want to inspect it.
- State briefly whether writing succeeded.

## Nutrition Calculation Rules

Default daily targets from the user's current plan:

- Calories: usually `1700-1900kcal`; use `1800kcal` as the default planning target.
- Protein: `130g/day`
- Carbohydrates: `140-150g/day`; use the user's stated target if they mention one.
- Fat: do not require precise tracking unless the user asks, but keep practical awareness of eggs, chicken skin, oil, and sauces.

Use the user's preferred values when available:

| Food | Calories | Protein | Carbs | Fat |
|---|---:|---:|---:|---:|
| 紫光蛋白粉 30g | 118kcal | 22.2g | 4.1g | |
| 牛奶 180ml | 116kcal | 5.8g | 8.6g | |
| 香蕉 120g | 110kcal | | 26.4g | |
| 全蛋 1个 | about 60-70kcal | 6g | 1.5g | about 4-5g |
| 蛋黄 1个 | 48kcal | 2.4g | 0.5g | 4.2g |
| 蛋清 1个 | 12.6kcal | 3.6g | 1g | |
| 熟米饭 100g | 116kcal | 2.6g | 25.6g | |
| 生大米 40g | 140kcal | about 3g | 31g | |
| 干面条 50g | 175kcal | 5-6g | 36-38g | |
| 干面条 100g | 350kcal | 10-12g | 72-76g | |
| 去皮琵琶腿 1个 | 160kcal | 23g | 0-2g | 6g |
| 带皮琵琶腿 1个 | 200-230kcal | 18-22g | 1-3g | 9-15g |
| 巴旦木 1.5g | 10kcal | | | 0.85g |
| 蓝莓 130g | 74kcal | | 19g | |

For foods not in the table:

- Estimate from common nutrition references and clearly mark it as an estimate.
- For restaurant foods, include an uncertainty range when oil/sauce is unknown.
- Use the user's stated weight first. If unclear, distinguish dry weight vs cooked weight, edible portion vs bone-in weight, and raw vs cooked.

## Response Pattern

For each meal report, answer in this compact structure:

```text
这次估算：
热量 X kcal，碳水 Yg，蛋白质 Zg。

今天累计：
热量 A kcal，碳水 Bg，蛋白质 Cg。

已写入幕布：A kcal / Bg / Cg。
后续建议：...
```

If Mubu writing fails:

```text
这次估算：...
今天累计：...

幕布写入没有成功，原因是：...
你可以先按这个值手动填，或稍后让我重试 Chrome。
```

## Edge Cases

- If the user reports multiple foods in one message, calculate each item, then sum.
- If the user says "刚才那份不是100g，是150g", recalculate the affected meal and update the cumulative total rather than adding a new meal.
- If existing Mubu summary values seem inconsistent with the chat history, state the discrepancy and choose the safer interpretation before writing.
- If the user asks for a future plan rather than reporting food already eaten, do not write Mubu.
- If Chrome asks for login, CAPTCHA, permission prompts, or account actions, stop and ask the user to handle that step.
