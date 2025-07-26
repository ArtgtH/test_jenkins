from app.funny_monkey import func_to_test


def test_success_func_to_test():
    assert func_to_test(1, 2) == 3


def test_fail_func_to_test_():
    assert func_to_test(1, 2) == 3
