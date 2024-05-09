# Decentralized Applications Security Incidents POCs

## Introduction

DAppHackPOC is a project aimed at aggressively refactoring [DefiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs) with the following objectives:

- Simplify the codebase to enhance readability and facilitate contributions.
- Keep all Proof of Concepts (POCs) up to date by aligning them with the latest testing practices in Foundry.
- Standardize the codebase to improve maintainability and scalability.

The repository includes **404 incidents**.

[DApp Hacks Dashboard](https://scrawny-sumac-c62.notion.site/52b64769ce474d658e0109b7cad521cc?v=d33d0369be064263b2d44caff9b256a6)

## Getting Started

1. Follow the [installation instructions](https://book.getfoundry.sh/getting-started/installation.html) to set up [Foundry](https://github.com/foundry-rs/foundry).

2. Clone the repository and install dependencies:
    ```bash
    git clone https://github.com/emilesean/DAppHackPOC.git
    git submodule update --init --recursive
    ```

3. Run individual POCs:
    ```
    forge test --contracts <contract> -vvv
    # Example: forge test --contracts ./test/2022-07/Audius.t.sol -vvv
    ```

4. Check out the [Contributing Guidelines](https://github.com/emilesean/DAppHackPOC/blob/main/CONTRIBUTING.md)

**Disclaimer:** This content serves solely as a proof of concept, showcasing past security incidents related to decentralized applications. It is strictly intended for educational purposes and should not be interpreted as encouragement or endorsement of any illegal activities or actual hacking attempts. Any actions taken based on this content are the sole responsibility of the individual, and usage should adhere to applicable laws, regulations, and ethical standards.