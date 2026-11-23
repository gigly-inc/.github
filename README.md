<h1 align="center">Gigly - Community Health Files</h1>

This repository contains the default [community health files][health-files] for the
[`Gigly`](https://github.com/gigly-inc) organization.

[health-files]: https://help.github.com/en/github/building-a-strong-community/creating-a-default-community-health-file

## Renovate presets

`default.json` is the organization's Renovate preset. It extends the shared coding standards, which update only
themselves and GitHub Actions. It keeps this organization's reusable workflows on their version tags and disables its
`@gigly-inc` npm packages, since Renovate cannot read their registry. A repository uses it with:

```json
{
    "$schema": "https://docs.renovatebot.com/renovate-schema.json",
    "extends": ["github>gigly-inc/.github"]
}
```

`application.json` is for applications, which ship their lock files. It extends `default.json` and enables composer and
npm updates: minor and patch updates come as one PR early on Monday (UTC), each major has its own PR, nothing is
automerged except the coding standards, and lock files are maintained weekly. An application extends
`github>gigly-inc/.github:application` in place of the default.

## qlty source

`source.toml` layers this organization's lint policy over the shared coding standards. Its `security/zizmor.yml`
lets this organization's actions and reusable workflows keep their version tags, as GitHub's and the coding standards'
own do. A repository adds it after the coding standards source in `.qlty/qlty.toml`:

```toml
[[source]]
name = "gigly"
repository = "https://github.com/gigly-inc/.github"
tag = "<version>"
```

zizmor cannot extend a config, so the file repeats the coding standards' policy. Keep the two in step when that one
changes.
