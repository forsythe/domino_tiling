# Domino Tiling
Create a random maximum tiling of any `n` by `m` chessboard with `2x1` dominos. When `n*m` is even, the tiling will be perfect.

## Theory
Consider the chessboard's white and black squares. A domino must cover both a white and black square. Therefore if some perfect tiling exists, then the solution can be transformed into a graph as follows: each chess square becomes a vertex, and if a domino tile covers two adjacent tiles, the two vertices are connected. This would result in a bipartite (all edges have one white and one black vertex) and (maximally) matching graph.

Therefore, given any sized grid (or any shape for that matter), if we are able to solve the maximum cardinality matching problem in a bipartite graph, we can convert the solution into a domino tiling.

## Implementation
To solve the aforementioned graph problem, convert it into a max flow problem, and solve with Ford Fulkerson. Connect source node to all white tiles, and sink node to all black tiles. A white tile points to a black tile only if they are neighbors on the chess grid. Solve with all edges having capacity one. The utilized edges between nodes indicate that a domino will be placed there.

### Example
Consider a chessboard 2 rows deep and 4 columns wide. The white squares are {0, 1, 2, 3}, and the black squares are {4, 5, 6, 7}
```
+---+---+---+---+
| 0 | 4 | 1 | 5 |
+---+---+---+---+
| 5 | 2 | 7 | 3 |
+---+---+---+---+
```
Now assume we have two additional nodes, `8` the source and `9` the sink. Then the graph to find the Max flow for becomes the below. Note that all edges have capacity 1.
```
0: 4, 6
1: 4, 5, 7
2: 4, 6, 7
3: 5, 7
4: 9
5: 9
6: 9
7: 9
8: 0, 1, 2, 3
```
After running Ford-fulkerson (with a randomized DFS for interesting solutions--use BFS if you want a boring row-wise solution each time), we might find the following edges used. Note that edges involving source/sink node have been omitted because they're not useful for reconstructing the tiling.
```
0-4
2-6
1-7
3-5
```
Finally, this corresponds to the following tiling
```
+-----+---+---+
| 0 4 | 1 | 5 |
+-----+   |   |
| 5 2 | 7 | 3 |
+-----+---+---+
```

## Samples
`16x16`


## Further Reading
* https://stackoverflow.com/questions/4780201/maximum-number-of-dominoes-can-be-placed-inside-a-figure
* https://en.wikipedia.org/wiki/Matching_%28graph_theory%29#Maximum-cardinality_matching