# Contribution Guidelines

We're thrilled to have you contribute to the DApp_Postmortems project. Your contributions are vital in keeping our repository a rich and accurate resource for DeFi hack incidents and their proof-of-concept (POC) exploits. Below is a streamlined process for adding new incident entries.

### Note on Contributions

- **Simplicity is Key**: We prioritize simplicity in our codebase. Our focus is on Solidity and maintaining a clean, straightforward environment for development.
- **Language Specificity**: While we value expertise in various programming languages, we encourage contributors to refrain from integrating tools or practices that deviate from our core language: Solidity.
- **Stay Focused**: If you find yourself contemplating the inclusion of external tools or languages, take a moment to realign with the project's goals. Our aim is to foster a dedicated Solidity development space.

## How to Add a New Incident Entry

1. **Fork the Repository**: Start by forking the [DApp_Postmortems repository](https://github.com/emilesean/DApp_Postmortems.git) on GitHub.

2. **Clone Your Fork**: Clone the fork to your local machine and initialize submodules:

   ```bash
   git clone https://github.com/your-username-here/DApp_Postmortems.git
   git submodule update --init --recursive
   ```

3. **Prepare the POC**: Using the [POC template](./src/Poc-template.sol) Navigate to the project directory and run tests:

   ```bash
   cd DApp_Postmortems
   forge test --contracts ./test/yyyy-mm/IncidentName.t.sol -vvv
   forge fmt
   ```

4. **Commit Your Changes**: Create a new branch, commit your changes, and push them:

   ```bash
   git checkout -b IncidentName
   git add .
   git commit -m "feat: Add POC for IncidentName"
   git push origin IncidentName
   ```

5. **Open a Pull Request**: Submit a pull request to the main repository with a detailed description of the incident.

6. **Review Process**: Our maintainers will review your pull request. They may suggest changes. Once approved, it will be merged into the main repository.

**Note**: Ensure your contributions are well-documented and follow the established coding standards. For any queries, reach out to the project maintainers.

**Disclaimer**: The POCs are for educational purposes only and should not be used for illegal activities. Contributors are responsible for their submissions and must comply with all legal and ethical guidelines.
