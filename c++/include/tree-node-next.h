#ifndef LEET_CODE_TREE_NODE_NEXT_H
#define LEET_CODE_TREE_NODE_NEXT_H

// TreeNode with next right pointer (used in problems like #116, #117).
struct Node {
    int val;
    Node *left;
    Node *right;
    Node *next;
    Node() : val(0), left(nullptr), right(nullptr), next(nullptr) {}
    Node(int x) : val(x), left(nullptr), right(nullptr), next(nullptr) {}
    Node(int x, Node *left, Node *right, Node *next)
        : val(x), left(left), right(right), next(next) {}
};

#endif // LEET_CODE_TREE_NODE_NEXT_H
