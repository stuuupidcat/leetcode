#!/usr/bin/env bash
#
# new-cpp.sh — 添加 C++ 题目
#
# 用法:
#   ./scripts/new-cpp.sh <number> <name>
#
# 示例:
#   ./scripts/new-cpp.sh 0042 trapping-rain-water
#   ./scripts/new-cpp.sh 0001 two-sum
#
# 效果:
#   生成 c++/problems/<number>-<name>.cpp 单文件模板
#
# 编译运行:
#   g++ -std=c++17 -O2 -I c++/include -o /tmp/sol c++/problems/0042-trapping-rain-water.cpp && /tmp/sol
#

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <number> <name>" >&2
    echo "  e.g. $0 0042 trapping-rain-water" >&2
    exit 1
fi

NUM="$1"
NAME="$2"
FILE="c++/problems/${NUM}-${NAME}.cpp"

if [[ -f "$FILE" ]]; then
    echo "Error: $FILE already exists" >&2
    exit 1
fi

cat > "$FILE" << 'CPP'
#include <cassert>
#include <vector>
using namespace std;

class Solution {
public:
    // TODO: implement
};

int main() {
    Solution s;
    // TODO: add test cases
    // assert(s.method(...) == expected);
    return 0;
}
CPP

echo "Created $FILE"
echo ""
echo "编译运行:"
echo "  g++ -std=c++17 -O2 -I c++/include -o /tmp/sol $FILE && /tmp/sol"
