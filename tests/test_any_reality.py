#!/usr/bin/env python3
"""Any-reality (arpt) must exist in generator, installer, and container script."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class AnyRealityPresent(unittest.TestCase):
    def test_index_has_arpt_option(self):
        html = (ROOT / "index.html").read_text(encoding="utf-8")
        self.assertIn('data-proto="arpt"', html)
        self.assertIn("Any-reality", html)
        self.assertIn("'arpt'", html)
        self.assertIn("protoKeys", html)
        self.assertRegex(html, r"isRealityEnabled[\s\S]*arpt")

    def test_sbx_sh_wires_arpt(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        self.assertIn("arpt", sh)
        self.assertIn("port_ar=${arpt", sh)
        self.assertIn("anyreality-sb", sh)
        self.assertIn("generate reality-keypair", sh)
        self.assertIn("security=reality", sh)
        self.assertIn("sbarpt", sh)
        self.assertIn('"$arp" = yes', sh)

    def test_container_start_wires_arpt(self):
        sh = (ROOT / "container/nodejs/start.sh").read_text(encoding="utf-8")
        self.assertIn("export arpt=${arpt}", sh)
        self.assertIn("anyreality-sb", sh)
        self.assertIn("generate reality-keypair", sh)
        self.assertIn("security=reality", sh)

    def test_no_branding_markers(self):
        for rel in ("sbx.sh", "container/nodejs/start.sh", "index.html"):
            text = (ROOT / rel).read_text(encoding="utf-8")
            self.assertNotIn("💣", text, rel)
            self.assertNotIn("argosbxstatus", text, rel)
            self.assertNotIn("yonggekkk", text, rel)


if __name__ == "__main__":
    unittest.main()
