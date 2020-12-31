import java.util.Map;
import java.util.Random;
import java.util.List;

class Edge {
  public int r1, r2, c1, c2;
  public Edge(int r1, int c1, int r2, int c2) {
    this.r1=r1;
    this.c1=c1;
    this.r2=r2;
    this.c2=c2;
  }
}

int GRID_SIZE = 10;
int NUM_ROWS = 20;
int NUM_COLS = 80;
List<Edge> edges = new ArrayList();

void printArr(int[][] arr) {
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[0].length; j++) {
      System.out.print(arr[i][j] + " " );
    }
    System.out.println();
  }
}

/**
 *Assumption: a and b have same dimensions, and are 1s or 0s, by finding unset bits
 */
List<Pair> findUnsetBits(int[][] a, int[][] b, int max_name) {
  List<Pair> ans = new ArrayList();
  for (int i = 0; i < Math.min(a.length, max_name); i++) {
    for (int j = 0; j < Math.min(a[0].length, max_name); j++) {
      if (a[i][j] == 1 && b[i][j]==0) {
        ans.add(new Pair(i, j));
      }
    }
  }
  return ans;
}

void calculateTiling() {
  edges.clear();
  int N = (NUM_ROWS*NUM_COLS)+2;//+2 to account for source and sink
  int[][] adjMtx = new int[N][N]; 
  int src = NUM_ROWS*NUM_COLS;
  int sink = src+1;

  int white_tile_name = 0; //max ceil(NUM_ROWS*NUM_COLS/2)-1, at which point we can use said value +1 for black tiles
  int min_black_tile_name = (int)Math.ceil(NUM_ROWS*NUM_COLS/2.0);
  int black_tile_name = min_black_tile_name;
  Pair[] nameToPair = new Pair[N];
  int[][] names = new int[NUM_ROWS][NUM_COLS];
  List<Integer> whiteTiles = new ArrayList();

  for (int r = 0; r < NUM_ROWS; r++) {
    //System.out.println("\nr= "+r);
    //process white tiles on row
    for (int c = (r%2==0?0:1); c < NUM_COLS; c+=2) {
      //System.out.println("c= " + c);
      //System.out.println("white_tile_name = " + white_tile_name);

      adjMtx[src][white_tile_name] = 1; //source must connect to all white tiles
      nameToPair[white_tile_name] = new Pair(r, c);
      names[r][c] = white_tile_name;
      whiteTiles.add(white_tile_name);
      white_tile_name++;
    }
    //process black tiles on row
    for (int c = (r%2==0?1:0); c < NUM_COLS; c+=2) {
      //System.out.println("c= " + c);
      //System.out.println("black_tile_name = " + black_tile_name);

      adjMtx[black_tile_name][sink] = 1; //all black tiles flow to sink
      nameToPair[black_tile_name] = new Pair(r, c);
      names[r][c] = black_tile_name;
      black_tile_name++;
    }
  }
  //connect all white tiles to possible black tile neighbors
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      int cur = names[r][c];
      //System.out.println("at (r,c)=(" + r + ", " + c + ") = " + cur);
      if (cur >= min_black_tile_name) { //skip black tiles
        continue;
      }
      //System.out.println("white tile");
      if (r+1<NUM_ROWS) {
        int down = names[r+1][c];
        adjMtx[cur][down] = 1;
      }
      if (c+1<NUM_COLS) {
        int right = names[r][c+1];
        adjMtx[cur][right]=1;
      }
      if (r>0) {
        int up = names[r-1][c];
        adjMtx[cur][up] = 1;
      }
      if (c>0) {
        int left=names[r][c-1];
        adjMtx[cur][left]=1;
      }
    }
    //System.out.println();
  }
  //printArr(adjMtx);
  int[][] residuals = FordFulkerson.solve(N, adjMtx, src, sink);
  List<Pair> pairsOfNames = findUnsetBits(adjMtx, residuals, NUM_ROWS*NUM_COLS);

  for (Pair edge : pairsOfNames) {
    Pair from = nameToPair[edge.r]; //overloading "r" to mean source
    Pair to = nameToPair[edge.c]; //overloading "c" to mean dest
    edges.add(new Edge(from.r, from.c, to.r, to.c));
  }
}

void setup() {
  surface.setResizable(true);
  surface.setSize(NUM_COLS*GRID_SIZE, NUM_ROWS*GRID_SIZE);
  background(0);
  rectMode(CENTER);
  stroke(255);
  fill(55);
  calculateTiling();
}


void draw() {
  for (Edge e : edges) {
    boolean isVertical = e.c1==e.c2;
    rect(
      GRID_SIZE*(0.5+(e.c1+e.c2)/2.0), //x
      GRID_SIZE*(0.5+(e.r1+e.r2)/2.0), //y
      (isVertical? 0.9*GRID_SIZE:1.9*GRID_SIZE), //width
      (isVertical?1.9*GRID_SIZE:0.9*GRID_SIZE)); //height
  }
}

void mouseClicked() {
  calculateTiling();
  background(0);
}