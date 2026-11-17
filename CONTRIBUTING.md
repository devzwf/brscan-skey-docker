# Contributing

Thanks for your interest in brscan-skey-docker. Bug reports, model reports and fixes are all welcome.

## How this repository works

The GitHub repository is a **read-only mirror**. Development happens on a private Git server, and every change is pushed to GitHub automatically. Pull requests are welcome, but they can't be merged on GitHub directly.

## Reporting a problem

Open an [issue](https://github.com/devzwf/brscan-skey-docker/issues) with:

- your scanner model (`SCANNER_MODEL`) and the image tag you use;
- the container logs (`docker logs <container>`);
- what you did on the device (for example: SCAN → Scan to PC → File).

If your model is refused or missing, check `docker run --rm --entrypoint list-models devzwf/brscan-skey` first and say whether it's listed.

## Proposing a change

1. For anything bigger than a small fix, open an issue first so we can agree on the approach.
2. Open a pull request against `main`. A diff in an issue works too.
3. Keep changes focused and update the `README.md` if behaviour or settings change.

What happens next:

- Pull requests show a pending `merged-via-gitea` check. That's expected: it keeps them from being merged on GitHub by mistake.
- The change is reviewed, then applied on the private server, where CI runs (secret scan, build and smoke tests).
- If the commits are applied unchanged, GitHub marks your pull request as merged when the mirror syncs.
- If they need adjusting (rebase, small edits), the pull request is closed with a link to the resulting commit. You stay credited as author or with a `Co-authored-by` line.
- Fixes ship in the next tagged release on Docker Hub.

## Licence

By contributing, you agree that your contribution is licensed under the [MIT License](LICENSE). The Brother drivers are not part of this licence; see [THIRD_PARTY.md](THIRD_PARTY.md).
