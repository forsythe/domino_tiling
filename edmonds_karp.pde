/*
* Adapted from https://iq.opengenus.org/edmonds-karp-algorithm-for-maximum-flow/
 */
import java.util.LinkedList;
import java.util.ArrayList;
import java.lang.Exception;
static class FordFulkerson {
  static boolean randomizedDfs(int N, int rGraph[][], int s, int t, int parent[]) {
    boolean visited[] = new boolean[N];
    List<Integer> stack = new ArrayList<Integer>();
    stack.add(s);
    parent[s]=-1;
    // Standard dfs Loop
    while (stack.size()!=0)
    {
      int u = stack.remove((int)(Math.random()*stack.size())); //random element
      if (visited[u])
        continue;
      visited[u] = true;

      for (int v=0; v<N; v++)
      {
        if (!visited[v] && rGraph[u][v] > 0)
        {
          stack.add(v);
          parent[v] = u;
        }
      }
    }
    /*
     * If we reached sink in BFS starting from source, then
     * return true, else false
     */
    return (visited[t]);
  }

  static boolean bfs(int N, int rGraph[][], int s, int t, int parent[]) {
    /* 
     * Create a visited array and mark all vertices as not
     * visited
     */
    boolean visited[] = new boolean[N];

    /* 
     * Create a queue, enqueue source vertex and mark
     * source vertex as visited
     */
    LinkedList<Integer> queue = new LinkedList<Integer>();
    queue.add(s);
    visited[s] = true;
    parent[s]=-1;
    // Standard BFS Loop
    while (queue.size()!=0)
    {
      int u = queue.poll();
      for (int v=0; v<N; v++)
      {
        if (!visited[v] && rGraph[u][v] > 0)
        {
          queue.add(v);
          parent[v] = u;
          visited[v] = true;
        }
      }
    }
    /*
     * If we reached sink in BFS starting from source, then
     * return true, else false
     */
    return (visited[t]);
  }
  // Returns the residual graph
  static int[][] solve(int N, int graph[][], int s, int t)
  {
    /* 
     * Create a residual graph and fill the residual graph
     * with given capacities in the original graph as
     * residual capacities in residual graph
     */
    /*
     * Residual graph where rGraph[i][j] indicates
     * residual capacity of edge from i to j (if there
     * is an edge. If rGraph[i][j] is 0, then there is
     * not)
     */
    int rGraph[][] = new int[N][N];
    for (int u = 0; u < N; u++)
      for (int v = 0; v < N; v++)
        rGraph[u][v] = graph[u][v];
    // This array is filled by BFS and to store path
    int parent[] = new int[N];
    int max_flow = 0;  // There is no flow initially
    /* 
     * Augment the flow while there is path from source
     * to sink
     */

    //using bfs will yield a nice row solution, but randomizedDfs will be more random
    while (randomizedDfs(N, rGraph, s, t, parent))
    {
      /* 
       *Find minimum residual capacity of the edhes
       * along the path filled by BFS. Or we can say
       * find the maximum flow through the path found.
       */
      int pathFlow = Integer.MAX_VALUE;
      for (int v=t; v!=s; v=parent[v])
      {
        int u = parent[v];
        pathFlow = Math.min(pathFlow, rGraph[u][v]);
      }
      /* 
       * update residual capacities of the edges and
       * reverse edges along the path
       */
      for (int v=t; v != s; v=parent[v])
      {
        int u = parent[v];
        rGraph[u][v] -= pathFlow;
        rGraph[v][u] += pathFlow;
      }
      // Add path flow to overall flow
      max_flow += pathFlow;
    }
    // Return the residual graph
    System.out.println("max flow = " + max_flow);
    return rGraph;
  }
}