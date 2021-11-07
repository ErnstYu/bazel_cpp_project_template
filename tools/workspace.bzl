""" External dependencies."""

load("//third_party/absl:workspace.bzl", absl = "repo")
load("//third_party/cpplint:workspace.bzl", cpplint = "repo")
load("//third_party/gflags:workspace.bzl", gflags = "repo")
load("//third_party/gtest:workspace.bzl", gtest = "repo")
load("//third_party/python_rules:workspace.bzl", python_rules = "repo")

def initialize_third_party():
    """ Load third party repositories.  See above load() statements. """
    absl()
    cpplint()
    gflags()
    gtest()
    python_rules()
