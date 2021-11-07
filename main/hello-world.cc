#include <iostream>
#include <string>

#include "absl/status/statusor.h"
#include "absl/strings/str_format.h"
#include "gflags/gflags.h"
#include "lib/hello-greet.h"
#include "lib/hello-time.h"

DEFINE_int32(answer, 42, "The answer to life, the universe and everything.");

absl::StatusOr<int> GetAnswer(int x) {
  if (x == FLAGS_answer) return x;

  return absl::NotFoundError(absl::StrFormat("Wrong answer, got %d!", x));
}

int main(int argc, char** argv) {
  std::string who = "world";
  if (argc > 1) {
    who = argv[1];
  }
  std::cout << get_greet(who) << std::endl;
  print_localtime();

  const auto answer_or = GetAnswer(42);
  if (answer_or.ok()) std::cout << "Correct answer! Horray!\n";

  return 0;
}
