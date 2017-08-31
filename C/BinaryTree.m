#import <stdlib.h>

// See ThingsTooLongForTheComments.md for a description

struct Tree {
    float ranking;
    struct Tree *left;
    struct Tree *right;
    unsigned int data;
};

unsigned int tracker, N;

typedef struct Tree BTree;

void addToTree(BTree *tree, float ranking, unsigned int data) {
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

void _TopN(BTree *tree, unsigned int **out) {
    if (tracker >= N) {return;}
    if (tree->right == NULL) {
        *out[tracker] = tree->data;
        tracker++;
    } 
    else { _TopN(tree->right, out); }
    if (tree->left != NULL) { _TopN(tree->left, out); }
}

void topN(unsigned int n, BTree *tree, unsigned int **out) {
    tracker = 0;
    N = n;
    _TopN(tree, out);
}

void deleteTree(BTree *tree) {
    if (tree->right != NULL) { deleteTree(tree->right); }
    if (tree->left  != NULL) { deleteTree(tree->left ); }
    free(tree);
}