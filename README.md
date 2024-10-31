# Decentralized Applications (D-Apps) Security Incidents Postmortems.

![Github Actions][workflow] [![X (formerly Twitter) URL](https://img.shields.io/twitter/url?url=https%3A%2F%2Fx.com%2Fi%2Fcommunities%2F1846491947273236608&label=Community%20Support)](https://x.com/i/communities/1846491947273236608)

[workflow]: https://img.shields.io/github/actions/workflow/status/emilesean/DApp_Postmortems/actions.yml

## Introduction

DApp_Postmortems is a fork of [DefiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) with the following aims

- Reduce compile time for each POC test by modularizing the codebase.
- Simplify the codebase to enhance readability and facilitate contributions.
- Keep all Proof of Concepts (POCs) up to date by aligning them with the latest testing practices in Foundry.
- Standardize the codebase to improve maintainability and scalability.


[DApp Hacks Dashboard](https://emilesean.notion.site/Chapter-4-D-Apps-Hacks-Leader-board-26805dab4aae41c18ed88e9933c34b03)

## Getting Started

1. Follow the [installation instructions](https://book.getfoundry.sh/getting-started/installation.html) to set up [Foundry](https://github.com/foundry-rs/foundry).

2. Clone the repository and install dependencies:

   ```bash
   git clone https://github.com/emilesean/DApp_Postmortems.git
   forge soldeer init
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


**Disclaimer:** This content serves solely as a proof of concept, showcasing past security incidents related to decentralized applications. It is strictly intended for educational purposes and should not be interpreted as encouragement or endorsement of any illegal activities or actual hacking attempts. Any actions taken based on this content are the sole responsibility of the individual, and usage should adhere to applicable laws, regulations, and ethical standards.