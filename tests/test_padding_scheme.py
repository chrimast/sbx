#!/usr/bin/env python3
"""AnyTLS inbounds must pin a padding scheme distinct from the official default."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]

OFFICIAL = [
    "stop=8",
    "0=30-30",
    "1=100-400",
    "2=400-500,c,500-1000,c,500-1000,c,500-1000,c,500-1000",
    "3=9-9,500-1000",
    "4=500-1000",
    "5=500-1000",
    "6=500-1000",
    "7=500-1000",
]

PINNED = [
    "stop=7",
    "0=30-30",
    "1=80-280",
    "2=220-380,c,380-720",
    "3=40-80,200-600",
    "4=300-800",
    "5=200-700",
    "6=250-650",
]


def schemes_in(text: str) -> list[list[str]]:
    blocks = re.findall(
        r'"padding_scheme"\s*:\s*\[(.*?)\]',
        text,
        flags=re.S,
    )
    out = []
    for block in blocks:
        lines = re.findall(r'"([^"]+)"', block)
        out.append(lines)
    return out


class PaddingSchemePinned(unittest.TestCase):
    def test_official_default_is_not_used(self):
        self.assertNotEqual(PINNED, OFFICIAL)
        self.assertEqual(PINNED[1], "0=30-30")

    def test_sbx_anytls_inbounds_use_pinned_scheme(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        found = schemes_in(sh)
        self.assertGreaterEqual(len(found), 2, found)
        for scheme in found:
            self.assertEqual(scheme, PINNED)

    def test_container_anytls_inbounds_use_pinned_scheme(self):
        sh = (ROOT / "container/nodejs/start.sh").read_text(encoding="utf-8")
        found = schemes_in(sh)
        self.assertGreaterEqual(len(found), 2, found)
        for scheme in found:
            self.assertEqual(scheme, PINNED)


if __name__ == "__main__":
    unittest.main()
