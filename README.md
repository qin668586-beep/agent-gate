# AgentGate

An on-chain **daily check-in board** that only holders of a **Binance Agent ID** can use.

> Submitted to the **Binance Agent ID Hackathon** (Track: Identity / Access control).
> Nothing in this repo touches user assets: it is a pure identity + participation record.

## What it is

`AgentGateCheckin` is a ~80-line smart contract on **BNB Smart Chain**. Its only access rule is:

```solidity
require(IAgentIdLike(AGENT_ID).balanceOf(msg.sender) > 0, "NOT_AGENT_ID");
```

That's it. The right to participate is derived directly from holding an Agent ID — no allowlist, no signature server, no admin key.

- `checkIn()` — one call per address per UTC day
- `statusOf(address)` — days checked in, whether done today
- `totalCheckins` / `uniqueAgents` / `dailyCount(day)` — aggregate stats

Agent ID contract (BNB Chain): `0x60b9262456de011f7d15a54cdd8c48baaa8b022f` (SPACE ID Agent ID, ERC-721, non-transferable).

**Deployed (BSC mainnet):** [`0x37231FdbBd2901a2304353e7576606440c0f80f4`](https://bscscan.com/address/0x37231FdbBd2901a2304353e7576606440c0f80f4) — **Live demo:** https://qin668586-beep.github.io/agent-gate/

## Why it matters

Agent ID is a non-transferable on-chain identity (`name.ai`). That makes it usable as a **permission primitive**, not just a username: access gating, participation proofs, drop eligibility, reputation — all readable on-chain with a single `balanceOf` call.

AgentGate is the smallest complete demonstration of that pattern: the product is live, the rule is on-chain, and the state is verifiable by anyone.

## Safety by design

| Property | AgentGate |
|---|---|
| Asset custody | none — no `payable`, no `transfer`, no `approve`, no `mint` |
| Admin / owner | none — no `owner`, no pause, no upgrade, no privileged function |
| Wallet login | injected browser wallet only; the user signs every transaction |
| Backend | none — static page + contract |
| Credentials | never collected |
| Agent ID usage | only `balanceOf(self) > 0`; no name lookup, no balance snooping |

## Files

- `AgentGateCheckin.sol` — the contract (MIT)
- `index.html` — zero-dependency frontend (`window.ethereum` only, no CDN, no SDK)
- `DEPLOY.md` — deploy to Remix + verify on BscScan + host on GitHub Pages

## Deploy

See [DEPLOY.md](DEPLOY.md). Summary: compile with solc ≥ 0.8.24 → deploy to BNB Chain (chainId 56) → verify on BscScan → put the address into `index.html` (`CONTRACT` constant).

## Live

- Site: `<filled after deploy>` (GitHub Pages)
- Contract: `<filled after deploy>`
- BscScan: `<filled after deploy>`

## License

MIT
