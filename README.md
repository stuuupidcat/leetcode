# LeetCode

> 基于 [EFanZh/LeetCode](https://github.com/EFanZh/LeetCode) 的项目修改。

## 进展

[![Progress Chart](https://stuuupidcat.github.io/leetcode/progress.svg)](https://stuuupidcat.github.io/leetcode/)

## 开始

### Rust

```bash
# 运行所有测试
cargo test

# 运行单题测试
cargo test problem_0001

# 添加新题 / 新解法
./scripts/new-rust.sh 0042 trapping_rain_water dp
```

### C++

每题一个独立 `.cpp` 文件，无外部依赖，直接编译运行：

```bash
# 编译运行单题
g++ -std=c++17 -O2 -I c++/include -o /tmp/sol c++/problems/0001-two-sum.cpp && /tmp/sol

# 添加新题
./scripts/new-cpp.sh 0042 trapping-rain-water
```

### 其他

```bash
# 生成进度报告（输出到 _site/）
cargo run --package progress-tracker --release -- . _site
```