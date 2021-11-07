""" Loads the cpplint library """

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Sanitize a dependency so that it works correctly from code that includes
# the project as a submodule.
def clean_dep(dep):
    return str(Label(dep))

def repo():
    http_archive(
        name = "cpplint",
        build_file = clean_dep("//third_party/cpplint:cpplint.BUILD"),
        sha256 = "6abc3acd7b0a3d51d8dcaff0a8cb66c772dea73dd45099cba2d0960ec90e8de4",
        strip_prefix = "cpplint-1.5.5",
        urls = [
            "https://github.com/cpplint/cpplint/archive/1.5.5.tar.gz",
        ],
    )
