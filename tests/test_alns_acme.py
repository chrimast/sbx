#!/usr/bin/env python3
"""alns=y must auto-issue a CA cert into /root/sbxca via official acme.sh."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


def _fn(src: str, name: str) -> str:
    m = re.search(rf"^{name}\(\)\{{.*?\n\}}", src, flags=re.M | re.S)
    if not m:
        raise AssertionError(f"function {name}() not found")
    return m.group(0)


class AlnsAutoCert(unittest.TestCase):
    def test_main_script_persists_and_exports_alns(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        self.assertRegex(sh, r"for v in [^\n]*\balns\b")
        self.assertIn("export alns=${alns:-''}", sh)

    def test_issueca_uses_official_acme_not_upstream_wrapper(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        self.assertIn("issueca(){", sh)
        issue = _fn(sh, "issueca")
        self.assertIn("get.acme.sh", issue)
        self.assertNotIn("yonggekkk/acme-yg", issue)
        self.assertNotIn("ygkkkca", issue)
        self.assertIn("/root/sbxca/private.key", issue)
        self.assertIn("/root/sbxca/cert.crt", issue)
        self.assertIn("/root/sbxca/ca.log", issue)
        self.assertIn("--standalone", issue)
        self.assertIn("--server letsencrypt", issue)

    def test_alns_calls_issueca_and_falls_back_to_self_signed(self):
        sh = (ROOT / "sbx.sh").read_text(encoding="utf-8")
        tail = sh[sh.find('echo "脚本未安装') :]
        self.assertIn("issueca", tail)
        self.assertNotIn("已停止安装", tail)
        self.assertNotIn("请自行准备 /root/sbxca", sh)
        self.assertIn("将使用自签证书的TLS", tail)
        self.assertNotIn("exit 1", tail.split("ins\n", 1)[0])

    def test_index_allows_domain_or_ip_cert(self):
        html = (ROOT / "index.html").read_text(encoding="utf-8")
        self.assertIn('id="alns"', html)
        self.assertIn('id="cadn"', html)
        self.assertIn("本机IP证书", html)

    def test_readme_documents_acme(self):
        md = (ROOT / "README.md").read_text(encoding="utf-8")
        self.assertIn("acme.sh", md)
        self.assertIn("/root/sbxca", md)
        self.assertIn("get.acme.sh", md)


if __name__ == "__main__":
    unittest.main()
