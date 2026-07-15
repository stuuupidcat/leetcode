#include <cassert>
#include <unordered_map>
#include <vector>

using namespace std;

class Solution {
public:
    static vector<int> solve(vector<int> &nums, int target) {
        unordered_map<int, int> map;

        for (int i = 0; i < static_cast<int>(nums.size()); ++i) {
            map.insert(nums[i], i);
        }

        for (int i = 0; i < static_cast<int>(nums.size()); ++i) {
            int r = target - nums[i];

            if (auto it = map.find(r); it != map.end() && it->second != i) {
                return {i, it->second};
            }
        }
        return {};
    }
}