#!/usr/bin/env bash
#
# new-rust.sh — 添加 Rust 题目或解法
#
# 用法:
#   ./scripts/new-rust.sh <number> <name> <solution>
#
# 示例:
#   ./scripts/new-rust.sh 0042 trapping_rain_water dp          # 新题 + 第一个解法
#   ./scripts/new-rust.sh 0001 two_sum brute_force             # 已有题目追加解法
#
# 效果:
#   新题时生成:
#     src/problem_0042_trapping_rain_water/mod.rs   — trait + 测试骨架
#     src/problem_0042_trapping_rain_water/dp.rs    — 解法骨架
#     并在 src/lib.rs 末尾追加 pub mod 声明
#
#   追加解法时生成:
#     src/problem_0001_two_sum/brute_force.rs       — 解法骨架
#     并在对应 mod.rs 头部追加 pub mod 声明
#
# 文件结构说明:
#   - mod.rs 定义 `pub trait Solution`，包含该题的函数签名
#   - mod.rs 的 tests 模块提供 `pub fn run<S: Solution>()`，写共享测试用例
#   - 每个解法文件实现 `Solution` trait，底部 #[cfg(test)] 调用 run::<Solution>()
#   - `// snip` 标记之间的代码可直接提交 LeetCode
#
# 验证: cargo test problem_0042
#

set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <number> <name> <solution>" >&2
    echo "  e.g. $0 0042 trapping_rain_water dp" >&2
    exit 1
fi

NUM="$1"
NAME="$2"
SOL="$3"

DIR="src/problem_${NUM}_${NAME}"
MOD_FILE="$DIR/mod.rs"
SOL_FILE="$DIR/${SOL}.rs"

# --- 新题: 创建 mod.rs ---
if [[ ! -d "$DIR" ]]; then
    mkdir -p "$DIR"

    cat > "$MOD_FILE" << 'RUST'
pub mod __SOL__;

pub trait Solution {
    // TODO: 填写函数签名
    fn solve();
}

#[cfg(test)]
mod tests {
    use super::Solution;

    pub fn run<S: Solution>() {
        let test_cases = [
            // TODO: 添加测试用例
        ];

        for _case in test_cases {
            todo!()
        }
    }
}
RUST
    sed -i "s/__SOL__/${SOL}/" "$MOD_FILE"

    # 注册到 lib.rs
    echo "pub mod problem_${NUM}_${NAME};" >> src/lib.rs

    echo "Created $MOD_FILE"
fi

# --- 生成解法文件 ---
if [[ -f "$SOL_FILE" ]]; then
    echo "Error: $SOL_FILE already exists" >&2
    exit 1
fi

cat > "$SOL_FILE" << 'RUST'
pub struct Solution;

// ------------------------------------------------------ snip ------------------------------------------------------ //

impl Solution {
    pub fn solve() {
        todo!()
    }
}

// ------------------------------------------------------ snip ------------------------------------------------------ //

impl super::Solution for Solution {
    fn solve() {
        Self::solve()
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_solution() {
        super::super::tests::run::<super::Solution>();
    }
}
RUST

echo "Created $SOL_FILE"

# 追加解法时，把 pub mod 加到 mod.rs 头部
if ! grep -q "pub mod ${SOL};" "$MOD_FILE"; then
    sed -i "1i pub mod ${SOL};" "$MOD_FILE"
    echo "Added 'pub mod ${SOL};' to $MOD_FILE"
fi

echo "Done. Run: cargo test problem_${NUM}"
