# -*- python -*-
""" Generate cpplint rules for targets """

load("@rules_python//python:defs.bzl", "py_test")

# From https://bazel.build/versions/master/docs/be/c-cpp.html#cc_library.srcs
_SOURCE_EXTENSIONS = [source_ext for source_ext in """
.c
.cc
.cpp
.cxx
.c++
.C
.h
.hh
.hpp
.hxx
.inc
""".split("\n") if len(source_ext)]

# The cpplint.py command-line argument so it doesn't skip our files!
_EXTENSIONS_ARGS = ["--extensions=" + ",".join(
    [ext[1:] for ext in _SOURCE_EXTENSIONS],
)]

def _extract_labels(srcs):
    """Convert a srcs= or hdrs= value to its set of labels."""

    # Tuples are already labels.
    if type(srcs) == type(()):
        return list(srcs)
    return []

def _is_source_label(label):
    for extension in _SOURCE_EXTENSIONS:
        if label.endswith(extension):
            return True
    return False

def _add_linter_rules(source_labels, source_filenames, name, data = None):
    # Common attributes for all of our py_test invocations.
    data = (data or [])
    size = "small"
    tags = ["cpplint"]

    # Google cpplint.
    cpplint_cfg = ["//:CPPLINT.cfg"] + native.glob(["CPPLINT.cfg"])
    py_test(
        name = name + "_cpplint",
        srcs = ["@cpplint//:cpplint"],
        data = data + cpplint_cfg + source_labels,
        args = _EXTENSIONS_ARGS + source_filenames,
        main = "cpplint.py",
        size = size,
        tags = tags,
    )

def cpplint(data = None, extra_srcs = None):
    """
    Add a test rule over the C++ sources for every rule in the BUILD file.

    Args:
      data:       extra data sources (or configs) for linting.
      extra_srcs: extra srcs that need linting.
    """

    # Iterate over all rules.
    for rule in native.existing_rules().values():
        # Extract the list of C++ source code labels and convert to filenames.
        candidate_labels = (
            _extract_labels(rule.get("srcs", ())) +
            _extract_labels(rule.get("hdrs", ()))
        )
        source_labels = [
            label
            for label in candidate_labels
            if _is_source_label(label)
        ]
        source_filenames = ["$(location %s)" % x for x in source_labels]

        # Run the cpplint checker as a unit test.
        if len(source_filenames) > 0:
            _add_linter_rules(source_labels, source_filenames, rule["name"], data)

    # Lint all of the extra_srcs separately in a single rule.
    if extra_srcs:
        source_labels = extra_srcs
        source_filenames = ["$(location %s)" % x for x in source_labels]
        _add_linter_rules(
            source_labels,
            source_filenames,
            "extra_srcs_cpplint",
            data,
        )
