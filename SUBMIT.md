# Agent ID Hackathon · 提交材料草稿（填表用）

> 两份表单（必须提交期 2026-11-18 08:00 → 2026-12-09 08:00 UTC 内完成）：
> - **项目提交**：https://app.binance.com/uni-qr/user-survey/fb26d2bd25e04329b1ba77c7b3811d23
> - **社区 X 帖提交**：https://app.binance.com/uni-qr/user-survey/ff6832f8d2984af289068c9450a3c98c

---

## 一、项目提交表（草稿，英中双语，按表单字段填）

**Project name**：`AgentGate`

**Website**：`https://qin668586-beep.github.io/agent-gate/`（部署后填实际地址）

**Contract address(es)（BNB Chain）**：`<部署后填写>`

**Category**：Identity / Access control（身份与访问控制）

**One-liner（≤120 字符）**：
> AgentGate is an on-chain daily check-in board that only Agent ID holders can use — pure identity, zero asset custody.

**Agent ID usage description（这段是评审重点，写清"怎么用"）**：
> AgentGate uses the Agent ID ERC-721 contract (`0x60b926…b022f`) as its **only** access rule: `checkIn()` calls `balanceOf(msg.sender) > 0` on-chain, so the right to participate is derived directly from holding a Binance Agent ID. No off-chain allowlist, no signature server, no admin. The product demonstrates Agent ID as a reusable **on-chain identity primitive** for access control and participation tracking — the same pattern any dApp can adopt to gate features, drops, or dashboards by agent identity.

**Product status**：Live（已上线）

**How to use（3 行）**：
1. Claim an Agent ID in Binance App (Wallet → Agent ID).
2. Connect the same address on the site, click "Check in daily", confirm one transaction (gas only, no value).
3. Addresses without an Agent ID are rejected by the contract (`NOT_AGENT_ID`).

**Source code**：`https://github.com/qin668586-beep/agent-gate`（BscScan 已验证）

**Team**：1 人独立开发者（`vic668586.ai`）

**Safety self-check（对应官方 10 条红线的自查，可直接贴）**：
- No web QR/pairing login; the site only uses injected wallet, user signs every tx.
- No server-side session, no backend at all (static page + contract).
- Contract has no payable, no transfer, no approve, no mint, no admin/owner, no upgrade.
- Open source, MIT, verified on BscScan; there are no privileged functions to disclose.
- No brand impersonation (project name / repo / domain do not use "Binance" or "BNB").
- No credential collection; no reward promises; risk warning shown on page.
- Agent ID is not used to look up other wallets by name — only `balanceOf(self)`.

**Reward receiving address**：`<你的收款地址>`

---

## 二、社区推广 X 帖（草稿）

**要求**：原创内容 + 带 `#BinanceWalletHackathon` 和 `#AgenticWallet`，然后到上面第二份表单交链接。

### 英文版（推荐主发，评审是英文视角）

> Most "agent" dApps gate access with an off-chain allowlist.
> We gate it with the Agent ID itself.
>
> AgentGate: an on-chain daily check-in board where the only rule is `balanceOf(yourAgentId) > 0`.
> No server. No admin. No custody. One transaction, gas only.
>
> Why it matters: Agent ID is a non-transferable ERC-721 identity — that makes it usable as a permissions primitive, not just a username. Same pattern works for gated dashboards, drops, and participation proofs.
>
> Contract is ~80 lines, verified & MIT: github.com/qin668586-beep/agent-gate
>
> #BinanceWalletHackathon #AgenticWallet

### 中文版（可作引用转发或广场同步）

> 大多数 "agent" 应用用白名单做门禁，我们直接用 Agent ID 本身。
>
> AgentGate：一个链上每日打卡榜，唯一规则就是 `balanceOf(你的 Agent ID) > 0`。无后端、无管理员、不经手资产，一笔交易只花 gas。
>
> 意义在于：Agent ID 是不可转让的 ERC-721 身份，它天然可以当「权限原语」用——门禁、空投门槛、参与凭证都能复用这套模式。
>
> 合约 80 行，已开源并验证：github.com/qin668586-beep/agent-gate
>
> #BinanceWalletHackathon #AgenticWallet

---

## 三、凑 30 个 Agent ID 的做法（创新奖硬门槛，合法路径）

1. **先自己打卡**（`vic668586.ai`）→ 证明产品可用、截图存证；
2. 在 **币安广场** 发一条中文说明（我们已有 `square/post.mjs`），讲「零金额、只花 gas、证明你 Agent ID 的链上存在感」；
3. 在 X 发上面那条帖子，回复区贴打卡页链接；
4. 找 Agent ID 相关 TG 群/中文社群（我们线索轮里有一批），发「免费打卡、不涉及资产」一句话；
5. 记录 `uniqueAgents` 增长，接近 30 时截图存档（提交材料里可以附数据）。

**不要做**：批量注册小号刷交互（红线明确取消资格）。

---

## 四、时间线（倒计时）

| 日期 | 事项 |
|---|---|
| 11-22 ～ 11-23 | 部署合约 + BscScan 验证 + Pages 上线（需要你的钱包） |
| 11-24 | 提交项目表（占位也要先交，后面可更新材料） |
| 11-25 ～ 12-05 | 拉 30 个 Agent ID 打卡；广场 + X 曝光 |
| 12-06 | 提交社区 X 帖表单 |
| **12-09 08:00 UTC** | **硬截止（北京 16:00）** |
