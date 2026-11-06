import csv
import os
import subprocess
import sys
import tempfile
import unittest
from io import StringIO
from pathlib import Path

import inventory


ROOT = Path(__file__).resolve().parents[1]
FIXTURE_DIR = Path(__file__).resolve().parent / "tmp"


def run_cli(contents):
    with tempfile.TemporaryDirectory(dir=FIXTURE_DIR) as temporary_directory:
        input_path = Path(temporary_directory) / "input.csv"
        input_path.write_text(contents, encoding="utf-8", newline="")
        stdout = StringIO()
        stderr = StringIO()
        code = inventory.main([str(input_path)], stdout=stdout, stderr=stderr)
        return code, stdout.getvalue(), stderr.getvalue()


class InventoryGateATests(unittest.TestCase):
    def test_valid_csv_sums_positive_negative_and_zero_and_sorts_skus(self):
        code, output, error = run_cli(
            "sku,delta\nzeta,8\nalpha,5\nzeta,-3\nbeta,0\nalpha,-2\n"
        )
        self.assertEqual(code, 0)
        self.assertEqual(error, "")
        self.assertEqual(
            list(csv.reader(StringIO(output))),
            [
                ["sku", "delta"],
                ["alpha", "3"],
                ["beta", "0"],
                ["zeta", "5"],
            ],
        )

    def test_header_only_is_an_empty_successful_summary(self):
        code, output, error = run_cli("sku,delta\n")
        self.assertEqual(code, 0)
        self.assertEqual(error, "")
        self.assertEqual(list(csv.reader(StringIO(output))), [["sku", "delta"]])

    def test_whitespace_around_nonempty_sku_is_preserved(self):
        code, output, error = run_cli("sku,delta\n alpha ,4\nalpha,2\n")
        self.assertEqual(code, 0)
        self.assertEqual(error, "")
        self.assertEqual(
            list(csv.reader(StringIO(output))),
            [["sku", "delta"], [" alpha ", "4"], ["alpha", "2"]],
        )

    def assert_invalid_input_has_no_success_output(self, contents):
        code, output, error = run_cli(contents)
        self.assertNotEqual(code, 0)
        self.assertEqual(output, "")
        self.assertTrue(error)

    def test_missing_field_fails_without_output(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\nalpha\n"
        )

    def test_extra_field_fails_without_output(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\nalpha,1,extra\n"
        )

    def test_empty_sku_fails_without_output(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\n,1\n"
        )

    def test_whitespace_only_sku_fails_without_output(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\n   ,1\n"
        )

    def test_invalid_integer_fails_without_output(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\nalpha,not-an-integer\n"
        )

    def test_late_field_count_error_emits_no_partial_summary(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\nzeta,4\nalpha,2,extra\n"
        )

    def test_late_integer_error_emits_no_partial_summary(self):
        self.assert_invalid_input_has_no_success_output(
            "sku,delta\nzeta,4\nalpha,2\nomega,bad\n"
        )

    def test_empty_file_and_blank_record_fail_without_output(self):
        for contents in ("", "sku,delta\n\n"):
            with self.subTest(contents=contents):
                self.assert_invalid_input_has_no_success_output(contents)

    def test_invalid_utf8_behavior_is_recorded_as_unspecified_observation(self):
        with tempfile.TemporaryDirectory(dir=FIXTURE_DIR) as temporary_directory:
            input_path = Path(temporary_directory) / "invalid-utf8.csv"
            input_path.write_bytes(b"sku,delta\nalpha,\xff\n")
            environment = os.environ.copy()
            completed = subprocess.run(
                [sys.executable, str(ROOT / "inventory.py"), str(input_path)],
                cwd=ROOT,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                env=environment,
                check=False,
            )
        self.invalid_utf8_observation = {
            "returncode": completed.returncode,
            "stdout": completed.stdout,
            "stderr": completed.stderr,
        }


if __name__ == "__main__":
    unittest.main()
