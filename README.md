## WIP: Example ERC20 using MUD

DISCLAIMER: this is just an example of how an ERC20 could look like using MUD. It is based on OpenZeppelin's ERC20 implementation.

Limitations:
- As the token is also a System, if it gets upgraded its address will change, so you probably want to transfer its ownership to the zero address after deploying so it can't be upgraded.
- This is unaudited code, do not use in production.
- This is just an example of how an ERC20 token could look like using MUD for its storage.

## Usage

### Build

```shell
$ pnpm build
```

### Test

```shell
$ pnpm test
```

### Format

```shell
$ forge fmt
```

### Deploy

To deploy locally:

```shell
$ anvil
$ pnpm deploy:local
```
