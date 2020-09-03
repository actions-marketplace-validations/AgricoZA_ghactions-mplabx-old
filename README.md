# Build with MPLABX Github Actions

This action will build a MPLAB X project.

It runs on Linux Ubuntu 18.04 and uses:

- MPLAB 5.40
- xc8 v2.30
- xc16 v1.60
- Peripheral libraries for PIC24/ds24 v2.0

## Inputs

### `project`

**Required** The path to the projec to build (relative to the repository). For example: 'firmware.X'.

### `configuration`

The configuration of the project to build. Defaults to `default`.

## Outputs

None.

## Example usage

Add the following `.github/workflows/build.yml` file to your project:

```yaml
name: Build
on: [push]

jobs:
  build:
    name: Build project
    runs-on: ubuntu-latest
    steps:
      - name: Download source
        uses: actions/checkout@v1

      - name: Build library
        uses: velocitek/ghactions-mplabx@master
        with:
          project: firmware.X
          configuration: default
```
