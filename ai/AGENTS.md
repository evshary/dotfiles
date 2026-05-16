# General Rules

## Markdown Requirements

When updating any `.md` file:

- Follow `markdownlint` formatting.
- If a `.markdownlint.yaml` file exists in the repository, read and follow that file before making changes.

## Rust Requirements

When working on a Rust project:

- Format files with `rustfmt +nightly --config "unstable_features=true,imports_granularity=Crate,group_imports=StdExternalCrate,skip_children=true" $(git ls-files '*.rs')`.
