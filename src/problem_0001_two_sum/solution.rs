use std::collections::HashMap;

pub struct Solution;

// ------------------------------------------------------ snip ------------------------------------------------------ //

impl Solution {
    pub fn solve(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut map: HashMap<i32, usize> = HashMap::new();
        for (index, num) in nums.iter().enumerate() {
            map.insert(*num, index);
        }
        for (index, num) in nums.iter().enumerate() {
            let r = target - num;
            if let Some(r_index) = map.get(&r)
                && *r_index != index
            {
                return vec![index as i32, *r_index as i32];
            }
        }
        vec![]
    }
}

// ------------------------------------------------------ snip ------------------------------------------------------ //

impl super::Solution for Solution {
    fn solve(nums: Vec<i32>, target: i32) -> Vec<i32> {
        Self::solve(nums, target)
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_solution() {
        super::super::tests::run::<super::Solution>();
    }
}
