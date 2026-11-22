// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * AgentGate — Agent ID 每日打卡榜
 *
 * 设计原则（对齐 Binance Agent ID Hackathon 安全红线）：
 *  - 不碰任何资产：没有 payable、没有 transfer、没有 approve、没有 mint，合约不持有也不经手任何代币
 *  - 无管理员：没有 owner / 没有 pause / 没有提权函数，部署者也无特权
 *  - 不绕过用户确认：只有用户自己发起的 checkIn()，一次签一笔
 *  - 不收集凭证：不存任何链下数据，不使用任何 off-chain 会话
 *  - 只做身份门禁：用 Agent ID 合约的 balanceOf(address) > 0 判定「是否持有 Agent ID」
 *
 * Agent ID 合约（BNB Chain）：0x60b9262456de011f7d15a54cdd8c48baaa8b022f
 *   name: SPACE ID Agent ID / symbol: AI / ERC-721 / non-transferable
 */
interface IAgentIdLike {
    function balanceOf(address owner) external view returns (uint256);
}

contract AgentGateCheckin {
    /// @notice 版本号（用于区分字节码，便于 Etherscan 系浏览器完成源码验证）
    uint256 public constant VERSION = 1;

    /// @notice 官方 Agent ID 合约地址（BNB Chain）
    address public constant AGENT_ID_CONTRACT =
        0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F;

    /// @notice 全局打卡总数
    uint256 public totalCheckins;
    /// @notice 参与过的 Agent ID 地址数（唯一地址）
    uint256 public uniqueAgents;

    /// @notice 地址 => 累计打卡天数
    mapping(address => uint256) public checkinDays;
    /// @notice 地址 => 最后一次打卡的 UTC 日序号
    mapping(address => uint256) public lastDayOf;
    /// @notice 日序号 => 当日打卡人数
    mapping(uint256 => uint256) public dailyCount;

    event CheckedIn(
        address indexed agent,
        uint256 indexed day,
        uint256 streakDays,
        uint256 totalCheckins
    );

    /// @notice 当前 UTC 日序号（1 day = 86400s）
    function today() public view returns (uint256) {
        return block.timestamp / 1 days;
    }

    /// @notice 判断某地址是否持有 Agent ID（balanceOf > 0）
    function isAgent(address account) public view returns (bool) {
        if (account == address(0)) return false;
        try IAgentIdLike(AGENT_ID_CONTRACT).balanceOf(account) returns (
            uint256 bal
        ) {
            return bal > 0;
        } catch {
            return false;
        }
    }

    /**
     * @notice 每日打卡：仅 Agent ID 持有者可调用，同一地址每个 UTC 日一次
     * @dev 纯记录型，无资产流转
     */
    function checkIn() external {
        require(isAgent(msg.sender), "NOT_AGENT_ID");
        uint256 d = today();
        require(lastDayOf[msg.sender] != d, "ALREADY_CHECKED_IN_TODAY");

        if (checkinDays[msg.sender] == 0) {
            uniqueAgents += 1;
        }
        lastDayOf[msg.sender] = d;
        checkinDays[msg.sender] += 1;
        dailyCount[d] += 1;
        totalCheckins += 1;

        emit CheckedIn(
            msg.sender,
            d,
            checkinDays[msg.sender],
            totalCheckins
        );
    }

    /// @notice 前端一次读全：地址的打卡天数、今日是否已打卡、当前日序号
    function statusOf(
        address account
    ) external view returns (uint256 days_, bool doneToday, uint256 day_) {
        day_ = today();
        days_ = checkinDays[account];
        doneToday = lastDayOf[account] == day_;
    }
}
