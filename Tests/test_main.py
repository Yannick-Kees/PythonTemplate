# Copyright (c) 2025, Your Name
# Licensed under the MIT License. See LICENSE for details.

"""
Description
"""

import pytest


def add(a, b):
    return a + b


@pytest.mark.parametrize("a,b,c", [(1, 2, 3), (2, 4, 6)])
def test_add(a, b, c):
    assert add(a, b) == c

