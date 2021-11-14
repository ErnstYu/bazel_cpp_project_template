#include "lib/hello-greet.h"

#include <string>

#include "gtest/gtest.h"

TEST(GreetTest, NameCheck) {
  const std::string name = "Thomas";
  const auto greet = get_greet(name);
  EXPECT_STREQ(greet.c_str(), "Hello Thomas!");
  EXPECT_STRNE(greet.c_str(), "Hello Stephan!");

  EXPECT_EQ(7 * 6, 42);
}
