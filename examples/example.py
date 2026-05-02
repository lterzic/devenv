"""Descriptive statistics utilities."""

import math


def mean(data: list[float]) -> float:
    """Return the arithmetic mean of data."""
    if not data:
        raise ValueError("mean requires at least one data point")
    return sum(data) / len(data)


def median(data: list[float]) -> float:
    """Return the median value of data."""
    if not data:
        raise ValueError("median requires at least one data point")
    sorted_data = sorted(data)
    midpoint = len(sorted_data) // 2
    if len(sorted_data) % 2 == 0:
        return (sorted_data[midpoint - 1] + sorted_data[midpoint]) / 2
    return sorted_data[midpoint]


def variance(data: list[float], *, ddof: int = 0) -> float:
    """Return the variance of data."""
    if len(data) < 2:
        raise ValueError("variance requires at least two data points")
    mu = mean(data)
    return sum((x - mu) ** 2 for x in data) / (len(data) - ddof)


def std_dev(data: list[float], *, ddof: int = 0) -> float:
    """Return the standard deviation of data."""
    return math.sqrt(variance(data, ddof=ddof))
