## Bazel C++ project template

This is a template for creating a C++ project to work with [bazel](https://bazel.build), a simple yet powerful build tool that has been widely utilized.

With the basic building configurations, some commonly used packages and most trivial code examples provided, this template exists in hope of simplifying the start of a new C++ repo to be built with bazel and clang. The template contains the following basic components:

- basic bazel configuration, tested with bazel 4.2.1
- clang toolchain for bazel, tested with clang 12.0.1, with c++17 enabled by default
- the following third-party packages:
  - [Abseil](https://github.com/abseil/abseil-cpp) (LTS 20210324.2)
  - [cpplint](https://github.com/cpplint/cpplint) (1.5.5)
  - [gflags](https://github.com/gflags/gflags) (2.2.2)
  - [gtest](https://github.com/google/googletest) (1.11.0)

Most part of the configurations in this template is adapted from the [Apollo](https://github.com/ApolloAuto/apollo) project.

Enjoy your life with bazel and clang, and most importantly: remember to **Live at Head**.
