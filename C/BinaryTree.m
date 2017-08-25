#import <stdlib.h>

struct Tree {
    float ranking;
    struct Tree *left;
    struct Tree *right;
    void *data;
};

unsigned int tracker, N;

typedef struct Tree BTree;

void addToTree(BTree *tree, float ranking, void *data) {
    if (tree == NULL) {
        tree = malloc(sizeof(BTree));
        tree->ranking = ranking;
        tree->data = data;
        tree->left = NULL;
        tree->right = NULL;
        return;
    }
    if (ranking > tree->ranking) { addToTree(tree->right, ranking, data); return; }
    addToTree(tree->left, ranking, data);
}

void _TopN(BTree *tree, void ***out) {
    if (tracker >= N) {return;}
    if (tree->right == NULL) {
        *out[tracker] = tree->data;
        tracker++;
    } 
    else { _TopN(tree->right, out); }
    if (tree->left != NULL) { _TopN(tree->left, out); }
}

void TopN(unsigned int n, BTree *tree, void ***out) {
    tracker = 0;
    N = n;
    _TopN(tree, out);
}