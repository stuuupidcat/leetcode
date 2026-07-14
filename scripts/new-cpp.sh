#!/usr/bin/env bash
#
# new-cpp.sh — 添加 C++ 题目或解法
#
# 用法:
#   ./scripts/new-cpp.sh <number> <name> <solution>
#
# 示例:
#   ./scripts/new-cpp.sh 0042 trapping-rain-water dp          # 新题 + 第一个解法
#   ./scripts/new-cpp.sh 0001 two-sum brute-force             # 已有题目追加解法
#
# 注意: C++ 侧用连字符命名 (kebab-case)，和 Rust 的下划线不同。
#
# 效果:
#   新题时生成:
#     c++/include/leet-code/problem-0042-trapping-rain-water/<solution>.h  — 解法头文件
#     c++/tests/leet-code/problem-0042-trapping-rain-water/tests.h         — 共享测试
#     c++/tests/leet-code/problem-0042-trapping-rain-water/<solution>.cpp  — 测试注册
#
#   追加解法时生成:
#     c++/include/leet-code/problem-<num>-<name>/<solution>.h
#     c++/tests/leet-code/problem-<num>-<name>/<solution>.cpp
#
# 手动步骤 (脚本会提示):
#   在 c++/CMakeLists.txt 中:
#   1. 将 .h 加入 LEET_CODE_HEADERS
#   2. 将 tests.h 加入 LEET_CODE_HEADERS (新题时)
#   3. 将 .cpp 加入 add_executable("leet-code-tests" ...)
#
# 文件结构说明:
#   - 解法写在 header-only 的 .h 文件中，namespace 隔离不同解法
#   - tests.h 是模板函数，写共享测试用例
#   - 每个 .cpp 实例化测试模板为一个 GTest TEST
#   - `// snip` 标记之间的代码可直接提交 LeetCode
#
# 验证: cmake --build target/c++ -j && ctest --test-dir target/c++
#

set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <number> <name> <solution>" >&2
    echo "  e.g. $0 0042 trapping-rain-water dp" >&2
    exit 1
fi

NUM="$1"
NAME="$2"
SOL="$3"

PROB="problem-${NUM}-${NAME}"
INC_DIR="c++/include/leet-code/${PROB}"
TEST_DIR="c++/tests/leet-code/${PROB}"
HEADER="${INC_DIR}/${SOL}.h"
TEST_CPP="${TEST_DIR}/${SOL}.cpp"
TESTS_H="${TEST_DIR}/tests.h"

# 转换为 C++ 标识符: kebab → snake
to_snake() { echo "$1" | tr '-' '_'; }
# 转换为 PascalCase
to_pascal() { echo "$1" | sed -r 's/(^|-)(\w)/\U\2/g'; }

PROB_NS="problem_${NUM}_$(to_snake "$NAME")"
SOL_NS="$(to_snake "$SOL")"
GUARD_PREFIX="LEET_CODE_$(echo "${PROB}" | tr '[:lower:]-' '[:upper:]_')"
SOL_GUARD="${GUARD_PREFIX}_$(echo "${SOL}" | tr '[:lower:]-' '[:upper:]_')_H"
TESTS_GUARD="${GUARD_PREFIX}_TESTS_H"
TEST_SUITE="Problem${NUM}$(to_pascal "$NAME")"
TEST_NAME="$(to_pascal "$SOL")"

mkdir -p "$INC_DIR" "$TEST_DIR"

# --- 新题: 创建 tests.h ---
if [[ ! -f "$TESTS_H" ]]; then
    cat > "$TESTS_H" << HEADER
#ifndef ${TESTS_GUARD}
#define ${TESTS_GUARD}

#include "../test-utilities.h"
#include <gtest/gtest.h>

namespace leet_code::${PROB_NS}::tests {
template <class S>
void run() {
    // TODO: 添加测试用例
    // const auto test_cases = { ... };
    // for (const auto &[input, expected] : test_cases) {
    //     ASSERT_EQ(S{}.solve(input), expected);
    // }
}
} // namespace leet_code::${PROB_NS}::tests

#endif // ${TESTS_GUARD}
HEADER
    echo "Created $TESTS_H"
fi

# --- 生成解法头文件 ---
if [[ -f "$HEADER" ]]; then
    echo "Error: $HEADER already exists" >&2
    exit 1
fi

cat > "$HEADER" << HEADER
#ifndef ${SOL_GUARD}
#define ${SOL_GUARD}

namespace leet_code::${PROB_NS}::${SOL_NS} {

// ------------------------------------------------------ snip ------------------------------------------------------ //

class Solution {
public:
    // TODO: 实现解法
};

// ------------------------------------------------------ snip ------------------------------------------------------ //

} // namespace leet_code::${PROB_NS}::${SOL_NS}

#endif // ${SOL_GUARD}
HEADER

echo "Created $HEADER"

# --- 生成测试 .cpp ---
if [[ -f "$TEST_CPP" ]]; then
    echo "Error: $TEST_CPP already exists" >&2
    exit 1
fi

cat > "$TEST_CPP" << CPP
#include "tests.h"
#include <leet-code/${PROB}/${SOL}.h>

namespace leet_code::${PROB_NS}::tests {
TEST(${TEST_SUITE}, ${TEST_NAME}) {
    tests::run<${SOL_NS}::Solution>();
}
} // namespace leet_code::${PROB_NS}::tests
CPP

echo "Created $TEST_CPP"

echo ""
echo "TODO: 在 c++/CMakeLists.txt 中添加:"
echo "  LEET_CODE_HEADERS += \"include/leet-code/${PROB}/${SOL}.h\""
[[ ! -f "${TESTS_H}.registered" ]] && echo "  LEET_CODE_HEADERS += \"tests/leet-code/${PROB}/tests.h\""
echo "  leet-code-tests   += \"tests/leet-code/${PROB}/${SOL}.cpp\""
touch "${TESTS_H}.registered" 2>/dev/null || true
