# AgentGate 部署与提交手册（Remix 路线）

> 为什么不用我们的 Agentic Wallet 部署：实测 `baw contract-call preview` 的 `--to` 是**必填**（EVM），
> Agentic Wallet 是 keyless 钱包，**不能发「无 to 地址」的部署交易**。所以部署必须由**有私钥的钱包**完成
> —— 也就是你在浏览器里的 MetaMask / OKX Wallet。合约是我写好的，你只需要在 Remix 里点几下。

---

## 一、你需要准备

1. 浏览器装了钱包插件（MetaMask / OKX Wallet / Rabby 都行），已切到 **BNB Smart Chain（chainId 56）**；
2. 该钱包里有一点 BNB 付 gas（部署约 **0.002–0.004 BNB ≈ $1.2–2.5**，我们自己的钱包有 0.0149 BNB 也可以用，但它是 keyless 的，导不出私钥 → **必须用一个你能控制私钥的钱包**）；
3. 一个 GitHub 账号（用于放前端 + 提交时填 website）。

## 二、部署（约 5 分钟）

1. 打开 <https://remix.ethereum.org>（无需安装）；
2. 左侧 `File explorer` → 新建文件 `AgentGateCheckin.sol`，把
   `D:\learn_AI\hackathon\agent-gate\contracts\AgentGateCheckin.sol` 的内容**整段粘贴**进去；
3. 左侧 `Solidity compiler` → 编译器选 **0.8.24 或更高**（与 pragma 一致）→ 点 `Compile AgentGateCheckin.sol`（出现绿勾）；
4. 左侧 `Deploy & run transactions` → `Environment` 选 **Injected Provider - MetaMask**（会弹钱包授权）→ 确认网络是 **BNB Chain (56)**；
5. `Contract` 下拉选 `AgentGateCheckin` → 点 **Deploy** → 钱包确认（gas 约 0.002–0.004 BNB）；
6. 部署成功后，在 `Deployed Contracts` 里复制**合约地址**（`0x...`），发我，我填进前端并推到 GitHub Pages。

## 三、源码验证（BscScan 显示源码，参赛硬门槛）

Remix 里就能一键验证，**不需要 BscScan API key**：

1. `Deploy & run` 面板下方 `Deployed Contracts` → 找到该合约 → 点 **Verify**（Remix 新版）或
2. 到 <https://bscscan.com/address/你的合约地址#code> → `Verify and Publish` → 方式选 **Solidity (Single file)** →
   - Compiler: `v0.8.24`（与你编译的一致）
   - Optimization: **No**（Remix 默认关闭；若你开了就选 Yes / runs 200）
   - License: **MIT**
   - 粘贴同一个 `AgentGateCheckin.sol` 源码；
3. 验证成功后 BscScan 页面会显示 ✅ 源码 —— 这就是「source code verified & open-sourced」。

> 我们也可以走 Sourcify（免 key）验证：`npx @ethereum-sourcify/cli verify ...`，需要我把文件准备好再说。

## 四、前端上线（GitHub Pages，免费）

1. 我把 `index.html`（已写好）推到你已有的 GitHub 账号下新仓库 `qin668586-beep/agent-gate`；
2. 仓库 `Settings → Pages → Source: main / root` → 得到 `https://qin668586-beep.github.io/agent-gate/`；
3. 把合约地址填进 `index.html` 的 `CONTRACT` 常量，重新提交一次即可；
4. 这个 URL 就是提交表里的 **website**。

## 五、提交（官方表单）

- 项目提交表（公告里的 “Submit Project Now”）：<https://app.binance.com/uni-qr/user-survey/fb26d2bd25e04329b1ba77c7b3811d23>
- 社区推广（X 帖）提交表：<https://app.binance.com/uni-qr/user-survey/ff6832f8d2984af289068c9450a3c98c>
- 提交期：**2026-11-18 08:00 → 2026-12-09 08:00 UTC**（北京 12-09 16:00 截止）
- 需要准备：项目名、website、合约地址、Agent ID 使用说明、团队成员/联系方式、领奖地址

## 六、要拿创新奖还差什么

- 硬门槛：**提交期内至少 30 个不同 Agent ID 地址**与合约交互（打一次卡就算一次交互）。
- 现实做法（合法、不刷号）：把这个打卡页丢到 Agent ID 持有者聚集的地方（币安广场、X 带 hackathon 话题、相关 TG 群），
  说明「零金额、只花 gas、验证你是 Agent ID 持有人在链上的存在感」。
- 不能做：批量注册小号刷交互（红线明确写了会被取消资格）。

## 七、合规自查（针对我们这套东西）

| 红线 | 我们是否触碰 | 说明 |
|---|---|---|
| 网页二维码登录钱包 | ❌ 不触碰 | 本页只用浏览器钱包注入（用户自己签名），没有二维码/配对码 |
| 服务器存会话代下单 | ❌ 不触碰 | 纯静态页 + 链上合约，无后端 |
| 绕过用户确认的资产操作 | ❌ 不触碰 | 合约无 payable / 无 transfer / 无 approve |
| 合约开源 + 披露 owner 权限 | ✅ 满足 | 无 owner、无提权函数，MIT 开源 |
| 冒充币安品牌 | ✅ 规避 | 名字用 AgentGate，域名/仓库都不含 binance/bnb |
| 收集助记词/私钥 | ❌ 不触碰 | 不收集任何凭证 |
| 承诺收益 | ✅ 规避 | 页面只写风险提示，无收益承诺 |
| Agent ID 被包装成「按名字查钱包」 | ✅ 规避 | 只判 `balanceOf>0`，不查名字、不查他人余额明细 |

> 注意：我们现有的 `agent-hunter` 面板**不提交**（它有 8791 二维码登录页 + 自动铸造，触第 1/2/3 条红线）。
