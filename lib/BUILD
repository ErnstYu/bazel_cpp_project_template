load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")
load("//tools:cpplint.bzl", "cpplint")

package(default_visibility = ["//visibility:public"])

# libraries ####################################
cc_library(
    name = "hello-time",
    srcs = ["hello-time.cc"],
    hdrs = ["hello-time.h"],
)

cc_library(
    name = "hello-greet",
    srcs = ["hello-greet.cc"],
    hdrs = ["hello-greet.h"],
)

# binaries #####################################

# tests #######################################
cc_test(
    name = "hello-greet-test",
    srcs = ["hello-greet-test.cc"],
    deps = [
        ":hello-greet",
        "@com_google_googletest//:gtest_main",
    ],
)

cpplint()
