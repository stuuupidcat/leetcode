# LeetCode

> 基于 [EFanZh/LeetCode](https://github.com/EFanZh/LeetCode) 的项目修改。

## 进展

[![Progress Chart](https://stuuupidcat.github.io/leetcode/progress.svg)](https://stuuupidcat.github.io/leetcode/)

## 开始

```bash
# 运行所有测试
cargo test

# 运行单题测试
cargo test problem_0001

# 添加新题 / 新解法（见 scripts/）
./scripts/new-rust.sh 0042 trapping_rain_water dp
./scripts/new-cpp.sh 0042 trapping-rain-water dp

# 生成进度报告（输出到 _site/）
cargo run --package progress-tracker --release -- . _site

# C++ 构建（需要 vcpkg + GTest）
cmake -S c++ -B target/c++ -D CMAKE_TOOLCHAIN_FILE="$VCPKG_INSTALLATION_ROOT/scripts/buildsystems/vcpkg.cmake"
cmake --build target/c++ -j
ctest --test-dir target/c++
```