# DApp Security Incidents Postmortems

![Github Actions][workflow] [![X Community](https://img.shields.io/twitter/url?url=https%3A%2F%2Fx.com%2Fi%2Fcommunities%2F1846491947273236608&label=Community%20Support)](https://x.com/i/communities/1846491947273236608)

[workflow]: https://img.shields.io/github/actions/workflow/status/emilesean/DApp_Postmortems/actions.yml

## Introduction

A curated collection of Proof of Concepts (POCs) demonstrating security incidents in decentralized applications (DApps) on EVM-compatible chains. Each POC recreates real-world smart contract vulnerabilities, providing valuable insights for developers and security researchers.

Credit: [DefiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs)

## Objectives

- Optimize POC test compilation through modular codebase design
- Enhance code readability and lower contribution barriers
- Maintain POCs with latest Foundry testing practices
- Establish consistent codebase standards

View our [DApp Hacks Dashboard](https://emilesean.notion.site/Chapter-4-D-Apps-Hacks-Leader-board-26805dab4aae41c18ed88e9933c34b03)

## Quick Start

1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation.html)

2. Clone and setup:
```bash
git clone https://github.com/emilesean/DApp_Postmortems.git
forge soldeer init
```

3. Run POCs:
```bash
forge test --contracts <contract> -vvv
# Example: forge test --contracts ./test/2022-07/Audius.t.sol -vvv
```

## Known Issues

### EVM Version Compatibility
Some POCs require specific EVM versions (check @KeyInfo section):
```bash
forge test --contracts <contract> --evm-version <evm-version> -vvv
# Example: forge test --contracts ./test/2022-08/LuckyTiger.t.sol --evm-version london -vvv
```

### BSC Network Limitations
- Slower response times from BSC RPC nodes
- Limited historical block access on non-archive nodes
- Common error:
```
It looks like you're trying to fork from an older block with a non-archive node which is not supported.
Please try to change your RPC url to an archive node if the issue persists.
```

### Performance Note
Higher verbosity levels (-v, -vv, -vvv) will increase test execution time.

## Contributing

See our [Contributing Guidelines](https://github.com/emilesean/DApp_Postmortems/blob/main/CONTRIBUTING.md)

## Disclaimer

This repository contains proof-of-concept demonstrations for educational purposes only. The content should not be used for illegal activities or actual hacking attempts. Users are responsible for ensuring compliance with applicable laws and regulations.
