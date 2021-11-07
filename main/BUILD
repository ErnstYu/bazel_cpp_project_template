load("@rules_cc//cc:defs.bzl", "cc_binary")
load("//tools:cpplint.bzl", "cpplint")

# libraries ####################################

# binaries #####################################
cc_binary(
    name = "hello-world",
    srcs = ["hello-world.cc"],
    deps = [
        "//lib:hello-greet",
        "//lib:hello-time",
        "@com_github_gflags_gflags//:gflags",
        "@com_google_absl//absl/status:statusor",
    ],
)

# tests #######################################

cpplint()
