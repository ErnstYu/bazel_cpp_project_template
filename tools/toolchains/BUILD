""" Setup the customized toolchain for bazel """

load("@bazel_tools//tools/cpp:unix_cc_toolchain_config.bzl", "cc_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")

package(default_visibility = ["//visibility:public"])

filegroup(name = "empty")

cc_toolchain_suite(
    name = "clang_toolchain",
    toolchains = {"k8|clang": "clang-compiler-k8"},
)

cc_toolchain(
    name = "clang-compiler-k8",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = True,
    toolchain_config = ":local_clang",
    toolchain_identifier = ":local_clang",
)

cc_toolchain_config(
    name = "local_clang",
    abi_libc_version = "local",
    abi_version = "local",
    compile_flags = [
        "-Wthread-safety",
        "-fstack-protector",
        "-Wall",
        "-mfma",
        "-no-canonical-prefixes",
        "-Wdeprecated-declarations",
        "-Wno-unknown-warning-option",
        "-fno-omit-frame-pointer",
        "-Werror=macro-redefined",
        "-Werror=range-loop-construct",
        "-Werror=return-type",
        "-Werror=reorder",
        "-Werror=switch",
        "-Werror=thread-safety-analysis",
        "-Werror=unused-but-set-variable",
        "-Werror=unused-function",
        "-Werror=unused-private-field",
        "-Werror=unused-result",
        "-Werror=unused-variable",
    ],
    compiler = "clang",
    cpu = "k8",
    cxx_builtin_include_directories = [
        "/usr/include",
        "/usr/local/include",
        "/usr/lib/clang/13.0.0/include",
    ],
    cxx_flags = [
        "-std=c++17",
        "-stdlib=libstdc++",
        "-DLIBCXX_USE_COMPILER_RT=YES",
        "-DLIBCXXABI_USE_COMPILER_RT=YES",
    ],
    dbg_compile_flags = ["-g"],
    host_system_name = "local",
    link_flags = [
        "-fuse-ld=lld",
        "-lc++abi",
        "-lm",
        "-lpthread",
        "-lstdc++",
        "-rtlib=compiler-rt",
        "-unwindlib=libunwind",
        "-Wl,--build-id=md5",
        "-Wl,--hash-style=gnu",
    ],
    opt_compile_flags = [
        "-g0",
        "-O2",
        "-DNDEBUG",
        "-ffunction-sections",
        "-fdata-sections",
    ],
    opt_link_flags = ["-Wl,--gc-sections"],
    supports_start_end_lib = True,
    target_libc = "local",
    target_system_name = "local",
    tool_paths = {
        "ar": "/usr/bin/llvm-ar",
        "cpp": "/usr/bin/clang",
        "dwp": "/usr/bin/llvm-dwp",
        "gcc": "/usr/bin/clang",
        "gcov": "usr/bin/llvm-cov",
        "ld": "/usr/bin/lld",
        "llvm-cov": "usr/bin/llvm-cov",
        "nm": "/usr/bin/llvm-nm",
        "objcopy": "/usr/bin/llvm-objcopy",
        "objdump": "/usr/bin/llvm-objdump",
        "strip": "/usr/bin/llvm-strip",
    },
    toolchain_identifier = "local",
    unfiltered_compile_flags = [
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
        "-D__TIMESTAMP_=\"redacted\"",
    ],
)
