import pytest

def add(a,b):
    return a+b

@pytest.mark.parametrize("a,b,c",[(1,2,3),(2,4,6)])
def test_add(a,b,c):
    assert add(a,b) == c
