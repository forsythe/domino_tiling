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

int size = 25;
int rows = 20;
int cols = 20;
boolean[][] taken = new boolean[rows][cols];
Random rd = new Random(); // creating Random object
List<Edge> edges = new ArrayList();

void randomize() {
  edges.clear();
  for (int d = 0; d < rows+cols-1; d++) {
    //System.out.println("d="+d);
    int r = Math.min(d, rows-1);
    int c = d - r;

    while ( r >= 0 && c < cols ) {
      //System.out.print("("+r+","+c+")");
      if (taken[r][c]) {
        r--;
        c++;
        continue;
      }

      //Either connect down or right, or forced to go down/right
      boolean bottomAvailable = r+1<rows && !taken[r+1][c];
      boolean rightAvailable = c+1<cols && !taken[r][c+1];
      String action = "";
      if (bottomAvailable && !rightAvailable) {
        action = "down";
      } else if (!bottomAvailable && rightAvailable) {
        action = "right";
      } else if (bottomAvailable && rightAvailable) {
        if (rd.nextBoolean()) { //true? then go down, else go right
          action = "down";
        } else {
          action = "right";
        }
      }

      switch(action) {
      case "down":
        taken[r+1][c] = true;
        edges.add(new Edge(r, c, r+1, c));
        break;
      case "right":
        taken[r][c+1] = true;
        edges.add(new Edge(r, c+1, r, c));
        break;
      };

      taken[r--][c++] = true;
    }
    //System.out.println();
  }
}

void setup() {
  randomize();
  surface.setResizable(true);
  surface.setSize(cols*size, rows*size);
  rectMode(CENTER);
  stroke(255);
  fill(55);
}


void draw() {
  background(0);
  for (Edge e : edges) {
    boolean isVertical = e.c1==e.c2;
    rect(
      size*(0.5+(e.c1+e.c2)/2.0), //x
      size*(0.5+(e.r1+e.r2)/2.0), //y
      0.9*(isVertical? size:2*size), //width
      0.9*(isVertical?2*size:size)); //height
  }
}

void mouseClicked() {
  randomize();
}