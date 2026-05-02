#!/usr/bin/env python3
"""Project-specific semantic lint for ingestion hygiene."""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Issue:
    level: str
    code: str
    message: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run project semantic lint checks.")
    parser.add_argument(
        "--config",
        default=".project-lint.json",
        help="Path to project lint config (relative to repo root).",
    )
    return parser.parse_args()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def parse_frontmatter(md_text: str) -> dict[str, str]:
    if not md_text.startswith("---\n"):
        return {}
    end = md_text.find("\n---\n", 4)
    if end == -1:
        return {}
    block = md_text[4:end]
    fields: dict[str, str] = {}
    for line in block.splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"').strip("'")
    return fields


def collect_glob_files(root: Path, globs: list[str]) -> list[Path]:
    collected: set[Path] = set()
    for pattern in globs:
        for path in root.glob(pattern):
            if path.is_file():
                collected.add(path)
    return sorted(collected)


def is_ignored(rel_path: str, ignore_globs: list[str]) -> bool:
    path_obj = Path(rel_path)
    return any(path_obj.match(pattern) for pattern in ignore_globs)


def is_allowlisted(code: str, rel_path: str, allowlist_globs: dict[str, list[str]]) -> bool:
    patterns = allowlist_globs.get(code, [])
    if not patterns:
        return False
    path_obj = Path(rel_path)
    return any(path_obj.match(pattern) for pattern in patterns)


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parents[1]
    config_path = (repo_root / args.config).resolve()
    if not config_path.exists():
        print(f"[FAIL] Missing config: {config_path}")
        return 2

    config = json.loads(read_text(config_path))
    purpose_keywords = [keyword.lower() for keyword in config.get("purpose_keywords", [])]
    ingest_paths = config.get("ingest_paths", [])
    ignore_globs = config.get("ignore_globs", [])
    reference_globs = config.get("reference_globs", [])
    entry_glob = config.get("entry_glob", "knowledge/entries/**/*.md")
    raw_root = config.get("raw_root", "raw")
    raw_field = config.get("raw_field", "source_file")
    allowlist_globs = config.get("allowlist_globs", {})

    issues: list[Issue] = []

    ingest_files: list[Path] = []
    for ingest_path in ingest_paths:
        path = repo_root / ingest_path
        if path.exists() and path.is_dir():
            ingest_files.extend(sorted([p for p in path.rglob("*") if p.is_file()]))

    ingest_files = sorted(set(ingest_files))
    rel_ingest_files = [p.relative_to(repo_root).as_posix() for p in ingest_files]
    rel_ingest_files = [
        rel_path for rel_path in rel_ingest_files if not is_ignored(rel_path, ignore_globs)
    ]

    reference_files = collect_glob_files(repo_root, reference_globs)
    reference_text = "\n".join(read_text(path) for path in reference_files).lower()

    for rel_path in rel_ingest_files:
        base_name = Path(rel_path).name.lower()
        if rel_path.lower() not in reference_text and base_name not in reference_text:
            level = "warning" if is_allowlisted("ORPHAN_INGEST", rel_path, allowlist_globs) else "error"
            issues.append(
                Issue(
                    level,
                    "ORPHAN_INGEST",
                    f"Ingest file is not referenced by tracked docs: {rel_path}",
                )
            )

    entry_files = collect_glob_files(repo_root, [entry_glob])
    entry_for_raw: dict[str, Path] = {}
    raw_root_prefix = raw_root.strip("/") + "/"
    for entry_file in entry_files:
        text = read_text(entry_file)
        fields = parse_frontmatter(text)
        rel_entry = entry_file.relative_to(repo_root).as_posix()

        raw_value = fields.get(raw_field, "").strip()
        if raw_value:
            raw_rel = raw_value.strip()
            entry_for_raw[raw_rel] = entry_file
            if not (repo_root / raw_rel).exists():
                issues.append(
                    Issue(
                        "error",
                        "MISSING_RAW_FILE",
                        f"Entry points to missing raw file ({raw_field}): {rel_entry} -> {raw_rel}",
                    )
                )

        tags_value = fields.get("tags", "")
        if not tags_value:
            issues.append(
                Issue(
                    "warning",
                    "MISSING_TAGS",
                    f"Entry is missing tags in frontmatter: {rel_entry}",
                )
            )

        if purpose_keywords:
            text_lower = text.lower()
            if not any(keyword in text_lower for keyword in purpose_keywords):
                issues.append(
                    Issue(
                        "error",
                        "NO_PURPOSE_LINK",
                        "Entry does not contain any project-purpose keywords: "
                        f"{rel_entry}",
                    )
                )

    for rel_path in rel_ingest_files:
        if not rel_path.startswith(raw_root_prefix):
            continue
        if rel_path not in entry_for_raw:
            level = "warning" if is_allowlisted("UNTRACKED_RAW", rel_path, allowlist_globs) else "error"
            issues.append(
                Issue(
                    level,
                    "UNTRACKED_RAW",
                    f"Raw file has no entry with `{raw_field}`: {rel_path}",
                )
            )

    errors = [issue for issue in issues if issue.level == "error"]
    warnings = [issue for issue in issues if issue.level == "warning"]

    if not issues:
        print("[PASS] project-lint semantic checks passed")
        print(
            f"Checked {len(rel_ingest_files)} ingest files, {len(entry_files)} entry files, "
            f"{len(reference_files)} tracked references."
        )
        return 0

    print("[FAIL] project-lint found issues" if errors else "[WARN] project-lint found warnings")
    for issue in issues:
        prefix = "ERROR" if issue.level == "error" else "WARN "
        print(f"- [{prefix}] {issue.code}: {issue.message}")
    print(
        f"\nSummary: {len(errors)} error(s), {len(warnings)} warning(s), "
        f"{len(rel_ingest_files)} ingest file(s) scanned."
    )
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
