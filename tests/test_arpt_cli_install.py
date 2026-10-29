#!/usr/bin/env python3
"""CLI Any-reality (arpt="") must follow original main-script presence semantics."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


def _fn(src: str, name: str) -> str:
    m = re.search(rf"^{name}\(\)\{{.*?\n\}}", src, flags=re.M | re.S)
    if not m:
        raise AssertionError(f"function {name}() not found")
    return m.group(0)


class ArptCliInstall(unittest.TestCase):
    def test_main_script_selects_arpt_by_presence_not_value(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        self.assertIn('[ -z "${arpt+x}" ] || arp=yes', sh)
        ins = _fn(sh, "ins")
        self.assertIn('[ "$arp" != yes ]', ins)
        self.assertNotIn('[ -z "$arpt" ]', ins.split("sleep", 1)[0])
        installsb = _fn(sh, "installsb")
        self.assertIn('if [ -n "$arp" ]; then', installsb)
        self.assertIn("anyreality-sb", installsb)
        self.assertIn("generate reality-keypair", installsb)
        self.assertIn('[ -z "$port_ar" ]', installsb)

    def test_container_selects_empty_arpt_like_main_script(self):
        sh = (ROOT / "container/nodejs/start.sh").read_text(encoding="utf-8")
        self.assertIn('[ -z "${arpt+x}" ] || arp=yes', sh)
        ins = _fn(sh, "ins")
        self.assertNotIn('[ -z "$anpt" ] && [ -z "$arpt" ]', ins)
        self.assertIn('[ "$anp" != yes ]', ins)
        self.assertIn('[ "$arp" != yes ]', ins)
        installsb = _fn(sh, "installsb")
        self.assertIn('if [ -n "$anp" ]; then', installsb)
        self.assertIn('if [ -n "$arp" ]; then', installsb)
        self.assertIn("anyreality-sb", installsb)
        self.assertIn('[ -z "$arpt" ]', installsb)

    def test_reality_keys_abort_when_empty(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        self.assertIn("Reality 密钥生成失败", sh)
        start = (ROOT / "container/nodejs/start.sh").read_text(encoding="utf-8")
        self.assertIn("Reality 密钥生成失败", start)
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        self.assertIn("请在末尾加 rep", sh)


if __name__ == "__main__":
    unittest.main()
