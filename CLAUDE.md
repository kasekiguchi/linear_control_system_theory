# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains lecture materials for "Linear Control System Theory" (線形システム制御論 / 線形制御理論), originally created by Professor Mihira (三平先生). Materials may be freely modified, but modifications should remain traceable for now.

The repository is primarily LaTeX documents and MATLAB scripts — there is no build system, test suite, or CI pipeline.

## File Encoding

All `.tex` and `.txt` files are encoded in **Shift_JIS (SJIS)** with CRLF line endings. When reading or editing these files, be aware that standard UTF-8 tools will show garbled output. Use `iconv -f SJIS` or similar to convert for viewing.

## Repository Structure

- **`lecture v30 SJIS (2024)公開用/`** — Main lecture materials (textbook and slides)
  - Root-level `.tex` files (`chap1.tex`–`chap8.tex`, `chapD.tex`, etc.) are textbook chapters
  - `10_システム制御系.tex`, `20_電気電子系.tex`, `30_日大生産工学部.tex` — Course-specific textbook entry points
  - `10_slide_電電・日大・シ制前半/` — Slides for first half (used by all three courses)
  - `20_slide_シ制後半詳解/` — Slides for second half (system control course only)
  - `head.tex` — Shared preamble with package definitions
  - `*.sty` files — Custom style files (`eclclass.sty`, `matx.sty`, `subfigure.sty`)
  - Slide chapter numbers correspond to textbook chapter numbers

- **`演習問題集（電気電子系：毎年更新）/`** — Exercise problem sets, updated annually
  - Year folders (`2024/`, `2025/`) contain the current exercise sets
  - Each topic has its own folder (e.g., `030_controllability/`, `070_pole_assign/`)
  - Each topic folder contains a `.tex` file and a `matlab*.m` file
  - `000_header_year.txt` — Change the lecture year here
  - Topics `010_3mass`, `020_LCR`, `110_linearization` are reused yearly without MATLAB
  - `ToBeDelete/` folders contain old versions kept for reference

- **`シミュレーター(with JAVA 2022)/`** — Tricycle/trailer simulator
  - `Simulator/Simulator.jar` — Run via `Simulator.bat` (Windows) or `Simulator.sh`
  - `Documents/` — Simulator manual
  - `MaTX/` — MaTX-related help files

- **`試験問題/`** — Past exam problems organized by course (`_システム制御系/`, `_電気電子系/`)

## Workflow for Annual Exercise Updates

1. Edit `000_header_year.txt` to set the current lecture year
2. Navigate to each topic folder
3. Run the `.m` file in MATLAB (working directory must be the topic folder)
4. Modify parameters in the `.m` file as needed and re-run
5. Compile the `.tex` file to generate problems and solutions

## LaTeX Compilation

The lecture materials use Beamer for slides and a custom document class. Compile with a LaTeX engine that supports SJIS encoding (e.g., pLaTeX or upLaTeX with appropriate settings). The `head.tex` file defines shared packages and macros used across all documents.
