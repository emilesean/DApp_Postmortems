# Decentralized Applications Security Incidents Postmortems

![Github Actions][workflow] [![Telegram Chat][tg-badge]][tg-url] [![Telegram Support][tg-support-badge]][tg-support-url]

[workflow]: https://img.shields.io/github/actions/workflow/status/emilesean/DApp_Postmortems/actions.yml
[tg-badge]: https://img.shields.io/endpoint?color=neon&logo=telegram&label=chat&style=flat-square&url=https%3A%2F%2Ftg.sumanjay.workers.dev%2FDApp_Postmortems
[tg-url]: https://t.me/DApp_Postmortems
[tg-support-badge]: https://img.shields.io/endpoint?color=neon&logo=telegram&label=support&style=flat-square&url=https%3A%2F%2Ftg.sumanjay.workers.dev%2FDApp_Postmortems
[tg-support-url]: https://t.me/DApp_Postmortems

## Introduction

DApp_Postmortems is a project aimed at aggressively refactoring [DefiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) with the following objectives:

- Reduce compile time for each POC test by modularizing the codebase.
- Simplify the codebase to enhance readability and facilitate contributions.
- Keep all Proof of Concepts (POCs) up to date by aligning them with the latest testing practices in Foundry.
- Standardize the codebase to improve maintainability and scalability.

The repository includes 
| Year         | Incidents |
| ------------ | --------- |
| 2017         | 1         |
| 2018         | 1         |
| 2019         | 0         |
| 2020         | 8         |
| 2021         | 33        |
| 2022         | 127       |
| 2023         | 189       |
| 2024         | 65        |
| ----------   | --------- |
| Total/Unique | 424/404   |

[DApp Hacks Dashboard](https://scrawny-sumac-c62.notion.site/52b64769ce474d658e0109b7cad521cc?v=d33d0369be064263b2d44caff9b256a6)

## Getting Started

1. Follow the [installation instructions](https://book.getfoundry.sh/getting-started/installation.html) to set up [Foundry](https://github.com/foundry-rs/foundry).

2. Clone the repository and install dependencies:

   ```bash
   git clone https://github.com/emilesean/DApp_Postmortems.git
   git submodule update --init --recursive
   ```

3. Run individual POCs:

   ```
   forge test --contracts <contract> -vvv
   # Example: forge test --contracts ./test/2022-07/Audius.t.sol -vvv
   ```

4.  Known Issues:


  -  Some POC are dependent on older EVM Versions The @KeyInfo Section of the POC will Specify EVM version dependancy . To run them, you need to specify the EVM version:

   ```
   forge test --contracts <contract> --evm-version <evm-version> -vvv
   # Example: forge test --contracts ./test/2022-08/LuckyTiger.t.sol --evm-version london -vvv
   ```
 - BSC POC take long to run BSC rpc nodes take long to respond to requests espcially when quering far into the past.

  - Many BSC nodes are non archiving or appear to have a limit on the number of blocks into the past you can query we keep running into this error with BSC nodes. We need a reliable rpc providers for BSC.
 ``` 
 It looks like you're trying to fork from an older block with a non-archive node which is not supported. Please try to change your RPC url to an archive node if the issue persists.  
 ```
 - Turning up the level of verbosity will slow down the test with each level of verbosity.

5. Check out the [Contributing Guidelines](https://github.com/emilesean/DApp_Postmortems/blob/main/CONTRIBUTING.md)


**Disclaimer:** This content serves solely as a proof of concept, showcasing past security incidents related to decentralized applications. It is strictly intended for educational purposes and should not be interpreted as encouragement or endorsement of any illegal activities or actual hacking attempts. Any actions taken based on this content are the sole responsibility of the individual, and usage should adhere to applicable laws, regulations, and ethical standards.find . -type f -name '*.t.sol' | wc -l