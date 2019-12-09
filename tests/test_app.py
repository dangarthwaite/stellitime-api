import unittest
import json
import os
from app import main as app
from app import counter_table, COUNTER_TABLE_NAME

starting_values = {'default': 0}

class TestApp(unittest.TestCase):
    def setUp(self):
        if not os.getenv("DYNAMODB_LOCAL"):
            raise (RuntimeError("CRITICAL: Can only be run against local database"))

    def new_payload(self):
        return ["app.py"]

    def test_getting_default_counter(self):
        payload = self.new_payload()
        error, result = app(payload)
        self.assertFalse(error)
        self.assertEqual("Automation For The People", result["body"]["message"])
        global starting_values
        starting_values['default'] = result["body"]["counter_value"]
        self.assertGreater(starting_values['default'], 0)

    def test_getting_default_counter_again(self):
        payload = self.new_payload()
        error, result = app(payload)
        self.assertFalse(error)
        self.assertEqual("Automation For The People", result["body"]["message"])
        counter = result["body"]["counter_value"]
        global starting_values
        self.assertEqual(counter, starting_values['default'])
