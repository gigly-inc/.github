# Security Policy

Gigly builds healthcare workforce technology, so we take the security and privacy of our systems and data
seriously. We appreciate the efforts of security researchers and the wider community in helping us keep our
platform safe.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.**

Instead, report them privately through one of the following channels:

- **GitHub private vulnerability reporting** — use the **"Report a vulnerability"** button under the
  **Security** tab of the affected repository. This is the preferred method.
- **Email** — contact us at `security@gogigly.com` if you are unable to use GitHub's reporting tool.

When reporting, please include as much of the following as you can:

- A description of the vulnerability and its potential impact.
- Steps to reproduce, or a proof of concept.
- The affected repository, version, or endpoint.
- Any suggested remediation, if you have one.

**Do not include real personal or organization data** in your report. If a vulnerability exposes such data,
describe the exposure rather than attaching the data itself.

## What to expect

After you submit a report:

- We will acknowledge it within **2 business days**.
- We will provide an initial assessment within **5 business days**.
- We will keep you informed of our progress at least every **two weeks** until the issue is resolved.
- We will credit you in any public advisory, unless you ask us not to.

## Coordinated disclosure

We follow a coordinated disclosure model. We ask that you:

- Give us a reasonable window to investigate and remediate before any public disclosure — typically
  **90 days**, sooner for trivial fixes.
- Avoid accessing, modifying, or destroying data that is not yours.
- Avoid actions that degrade service availability for legitimate users.
- Comply with all applicable laws and regulations.

In return, we commit to working with you in good faith and will not pursue legal action against researchers
who report vulnerabilities in line with this policy.

## Scope

This policy applies to repositories owned by the [`gigly-inc`](https://github.com/gigly-inc) organization.
Vulnerabilities in third-party dependencies should be reported to the relevant upstream project, though we
welcome a heads-up so we can track and mitigate them.

The following are out of scope:

- Social engineering of Gigly staff or contractors.
- Physical attacks against Gigly personnel or facilities.
- Denial-of-service attacks, volumetric or otherwise.

## Supported versions

Security fixes are applied to the latest released version of each product. Older versions may receive
critical fixes at our discretion.
