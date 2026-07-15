pub mod solution;

pub trait Solution {
    // TODO: 填写函数签名
    fn solve(nums: Vec<i32>, target: i32) -> Vec<i32>;
}

#[cfg(test)]
mod tests {
    use super::Solution;

    pub fn run<S: Solution>() {
        let test_cases = [((vec![2, 7, 11, 15], 9), vec![0, 1])];

        for ((nums, target), expected) in test_cases {
            assert_eq!(S::solve(nums, target), expected)
        }
    }
}
