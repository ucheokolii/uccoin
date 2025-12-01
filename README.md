# uccoin

uccoin is a simple fungible token smart contract built with [Clarinet](https://github.com/hirosystems/clarinet) for the Stacks blockchain.

## Project structure

- `Clarinet.toml` – Clarinet project configuration
- `contracts/uccoin.clar` – main Clarity smart contract implementing the uccoin token
- `settings/` – network configuration for Devnet, Testnet, and Mainnet
- `tests/` – TypeScript tests scaffolded by Clarinet

## Prerequisites

- Clarinet CLI (version 3.x)
- Node.js and npm (for running TypeScript tests)

To verify Clarinet is installed:

```bash
clarinet --version
```

## Smart contract overview

The `uccoin` contract implements a minimal fungible token with:

- `total-supply` tracking (how many uccoin have been minted)
- per-principal balances
- restricted minting (only the contract owner can mint)
- token transfers between principals

### Key data definitions

- `total-supply` – `uint` data-var storing the total number of minted tokens
- `balances` – map from `principal` to `uint` representing balances
- `CONTRACT-OWNER` – hard-coded principal allowed to mint new tokens (by default, the first Clarinet devnet account)

### Public functions

- `mint (amount uint) (recipient principal)`
  - Mints `amount` tokens to `recipient`
  - Only callable by `CONTRACT-OWNER`
  - Returns `(ok true)` on success or `(err u100)` if unauthorized

- `transfer (amount uint) (sender principal) (recipient principal)`
  - Transfers `amount` tokens from `sender` to `recipient`
  - Must be called by `sender` (i.e., `tx-sender` must equal `sender`)
  - Returns `(ok true)` on success or `(err u101)` if the sender has insufficient balance

### Read-only functions

- `get-total-supply ()` – returns the current total supply of uccoin
- `get-balance-of (account principal)` – returns the balance of `account`

## Development

### Running static checks

From the project root:

```bash
clarinet check
```

This command runs Clarity static analysis and syntax checks against all contracts in `contracts/`.

### REPL

You can experiment with the contract in the Clarinet REPL:

```bash
clarinet console
```

From the REPL you can call functions like `get-total-supply`, `mint`, and `transfer` to see how the contract behaves.

### Running tests

A basic test scaffold for `uccoin` was created in `tests/uccoin.test.ts`. To install dependencies and run the tests:

```bash
npm install
npm test
```

## License

See `LICENSE` for licensing information.
