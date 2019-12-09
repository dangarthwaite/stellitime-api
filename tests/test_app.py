import unittest
from app import main as app

class TestApp(unittest.TestCase):
    def test_post(self):
        result = app(['{"message": "happy path"}'])
        self.assertIn("happy path", result)
