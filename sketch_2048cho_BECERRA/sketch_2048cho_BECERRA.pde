Cell[][] pila;
Grid cuadricula;
static int puntos;
void setup() {
  size(800, 600);
  background(0);
  textSize(30);
  fill(255, 0, 0);
  text("Presiona 'r' para resetear", 120, 580);
  textSize(20);
  text("Yanni Becerra Camacho", 180, 535);
  textSize(20);
  String s="Utiliza las flechas del teclado para acumular la mayor cantidad de puntos:)";
  text(s, 520, 250,280, 310);
  textSize(60);
  text("2048cho", 40, 70);
  pila = new Cell[4][4];
  cuadricula = new Grid();
  puntos = 0;
  cuadricula.spawn();
  cuadricula.spawn();
}

void draw() {
  //volver a dibujar la cuadrícula
  fill(205, 193, 197);
  rect(100, 100, 400, 400);
  for (int i = 100; i<=500; i+=100) {
    smooth();
    strokeWeight(3);
    line(100, i, 500, i);
    line(i, 100, i, 500);
  }
  fill(0);
  strokeWeight(2);
  rect(430, 20, 130, 30);
  fill(255);
  textSize(25);
  text("Puntos: " + puntos, 340, 45);

  //dibujar las celdas que tienen un valor numérico
  for (Cell c : cuadricula.getCellsOcupadas (true)) {
    c.drawTile();
    //Comprobar si el jugador ganó
    println("R: " + c.row + " C: " + c.col + " " + c.merge);
    if (c.numero == 2048) {
      fill(0, 255, 255);
      textSize(100);
      text("GANASTE :D", 80, 300);
    }
  }

  //mover mosaicos cuando se presiona la tecla de flecha y la cuadrícula no está llena
  if (cuadricula.getCellsOcupadas(true).size() <= 16 && (keyCode == UP || keyCode == DOWN|| keyCode == LEFT || keyCode == RIGHT) ) {
    cuadricula.moveTiles();
  }

  //Comprobar si el jugador perdio
  if (cuadricula.getCellsOcupadas(true).size() >= 16) {
    if (cuadricula.checarPerder()) {
      fill(0, 255, 255);
      textSize(80);
      text("MAMASTE8(", 60, 300);
    }
  }

}

public class Grid {
  int startCoor = 100;
  int endCoor = 500;
  int loop = 0;
  boolean puedenSpawnear = false;

  public Grid() {
    //dibuja el límite y las líneas de la cuadrícula
    rect(startCoor, startCoor, 400, 400);
    for (int i = startCoor; i<=endCoor; i+=100) {
      smooth();
      strokeWeight(3);
      line(startCoor, i, endCoor, i);
      line(i, startCoor, i, endCoor);
    }
    //crea la cuadrícula de 4x4 de objetos de celda
    int x = startCoor;
    int y = startCoor;
    for (int r = 0; r<pila.length; r++) {
      for (int c = 0; c<pila[0].length; c++) {
        pila[r][c] = new Cell(x, y, r, c);
        x += 100;
      }
      y += 100;
      x = startCoor;
    }
  }

  
  //obtiene las celdas que tienen un valor numérico de abajo hacia arriba o de arriba hacia abajo
  public ArrayList<Cell> getCellsOcupadas(boolean botToUp) {
    ArrayList<Cell> cList = new ArrayList<Cell>();
    if (botToUp) {
      for (int r = pila.length-1; r>=0; r--) {
        for (int c = pila[0].length-1; c>=0; c--) {
          if (pila[r][c].tieneNumero) {
            cList.add(pila[r][c]);
          }
        }
      }
    } else {
      for (int r = 0; r<pila.length; r++) {
        for (int c =0; c<pila[0].length; c++) {
          if (pila[r][c].tieneNumero) {
            cList.add(pila[r][c]);
          }
        }
      }
    }
    return cList;
  }
  

  //agrega un mosaico de 2 o 4 a la cuadrícula
  public void spawn() {
    int i = 0;
    while (i < 1) {
      int r = (int)random(0, 4);
      int c = (int)random(0, 4);
      if (!pila[r][c].tieneNumero) {
        pila[r][c].tieneNumero = true;
        pila[r][c].numero *= (int)random(0, 2) + 1;
        i++;
      }
    }
  }
  
  //mueve las fichas en función de las teclas de flecha
  public void moveTiles() {
    if ((keyCode == UP || keyCode == LEFT)) {
      if (loop < 10 && keyCode != 0) {
        for (Cell c : getCellsOcupadas (false)) {
          if (keyCode == UP  && c.yCoor > 100 && c.row !=0) {//comprueba si la clave y la nueva posición del mosaico son válidas
            if (!pila[c.row-1][c.col].tieneNumero) {//mueve mosaico si la celda de arriba no tiene valor numérico
              c.yCoor -= 100;
              if (c.yCoor%100 == 0) {//la posición del mosaico cambia cuando el mosaico se mueve a otra ubicación de celda
                c.cambiarCell(c.row-1, c.col);
              }
              puedenSpawnear = true;
            } else if (c.yCoor%100 == 0 && pila[c.row-1][c.col].numero == c.numero && c.merge) {//fusiona el mosaico si el mosaico de arriba tiene el mismo número
              c.merge = false;
              pila[c.row-1][c.col].merge = false;
              c.yCoor -= 100;
              c.numero *= 2;
              puntos += c.numero;
              c.cambiarCell(c.row-1, c.col);
              puedenSpawnear = true;
            }
          } else if (keyCode == LEFT && c.xCoor > 100 && c.col !=0) {
            if (!pila[c.row][c.col-1].tieneNumero) {
              c.xCoor -= 100;
              if (c.xCoor%100 == 0) {
                c.cambiarCell(c.row, c.col-1);
              }
              puedenSpawnear = true;
            } else if (c.xCoor%100 == 0 && pila[c.row][c.col-1].numero == c.numero && c.merge) {
              c.merge = false;
              pila[c.row][c.col-1].merge = false;
              c.xCoor -= 100;
              c.numero *= 2;
              puntos += c.numero;
              c.cambiarCell(c.row, c.col-1);
              puedenSpawnear = true;
            }
          }
        }
      } else {//restablece el bucle, el código clave, el estado de fusión de la celda y genera un mosaico
        loop = -1;
        keyCode = 0;
        for (Cell c : getCellsOcupadas (false)) {
          c.merge = true;
        }
        if (getCellsOcupadas(false).size() < 16 && puedenSpawnear) {
          cuadricula.spawn();
        }
        puedenSpawnear = false;
      }
      loop++;
    } else if ((keyCode == RIGHT || keyCode == DOWN)) {
      if (loop < 10 && keyCode != 0) {
        for (Cell c : getCellsOcupadas (true)) { 
          if (keyCode == RIGHT && c.xCoor < 400 && c.col !=3) {
            if (!pila[c.row][c.col+1].tieneNumero) {
              c.xCoor += 100;
              if (c.xCoor%100 == 0) {
                c.cambiarCell(c.row, c.col+1);
              }
              puedenSpawnear = true;
            } else if (c.xCoor%100 == 0 && pila[c.row][c.col+1].numero == c.numero && c.merge) {
              c.merge = false;
              pila[c.row][c.col+1].merge = false;
              c.xCoor += 100;
              c.numero *= 2;
              puntos += c.numero;
              c.cambiarCell(c.row, c.col+1);
              puedenSpawnear = true;
            }
          } else if (keyCode == DOWN && c.yCoor < 400 && c.row != 3) {
            if (!pila[c.row+1][c.col].tieneNumero) {
              c.yCoor += 100;
              if (c.yCoor%100 == 0) {
                c.cambiarCell(c.row+1, c.col);
              }
              puedenSpawnear = true;
            } else if (c.yCoor%100 == 0 && pila[c.row+1][c.col].numero == c.numero && c.merge) {
              c.merge = false;
              pila[c.row+1][c.col].merge = false;
              c.yCoor += 100;
              c.numero *= 2;
              puntos += c.numero;
              c.cambiarCell(c.row+1, c.col);
              puedenSpawnear = true;
            }
          }
        }
      } else {
        loop = -1;
        keyCode = 0;
        for (Cell c : getCellsOcupadas (true)) {
          c.merge = true;
        }
        if (getCellsOcupadas(true).size() < 16 && puedenSpawnear) {
          cuadricula.spawn();
        }
        puedenSpawnear = false;
      }
      loop++;
    }
  }


  //comprueba si la celda aún puede fusionarse/mover
  public boolean checkLoseHelper(int rp, int cp) {
    if (getCellsOcupadas(true).size() >= 16) {
      for (int r = rp- 1; r <= rp + 1; r++) {
        for (int c = cp - 1; c <= cp + 1; c++) {
          if (r>=0 && r<=3 && c>=0 && c<=3  && (rp != r || cp != c) && (rp == r || cp == c)) {
            if (pila[rp][cp].numero == pila[r][c].numero) {
              return false;
            }
          }
        }
      }
      return true;
    }
    return false;
  }

  //si la celda aún puede moverse/fusionarse, el jugador aún no ha perdido
  public boolean checarPerder() {
    for (int r = 0; r<pila.length; r++) {
      for (int c = 0; c<pila[0].length; c++) {
        if (!cuadricula.checkLoseHelper(r, c)) {
          return false;
        }
      }
    }
    return true;
  }
}

public class Cell {

  boolean tieneNumero = false;
  int numero;
  int xCoor, yCoor, row, col;
  boolean merge = true;

  public Cell(int x, int y, int r, int c) {
    numero = 2;
    xCoor = x;
    yCoor = y;
    row = r;
    col = c;
  }

  //actualiza la posición de una celda cuando la celda se está moviendo
  public void cambiarCell(int r, int c) {
    pila[r][c].merge = this.merge;
    this.tieneNumero = false;
    if (this.row == r) {
      this.xCoor -= 100 * (c-this.col);
    } else if (this.col == c) {
      this.yCoor -= 100 * (r-this.row);
    }
    pila[r][c].numero = this.numero;
    this.numero = 2;
    pila[r][c].tieneNumero = true;
  }

  //el mosaico se dibuja en función de su valor numérico
  public void drawTile() {
    if (numero < 9) {
      fill(40*numero+30, numero*5, numero*25);
      rect(xCoor, yCoor, 100, 100);
      textSize(45);
      fill(255);
      text("" + numero, xCoor+35, yCoor+65);
    } else if (numero < 128) {
      fill(numero%7*35, 0, numero/7*7);
      rect(xCoor, yCoor, 100, 100);
      textSize(45);
      fill(255);
      text("" + numero, xCoor+25, yCoor+65);
    } else if (numero < 1024) {
      fill((numero%6+25)*6, numero/30, numero%10*35);
      rect(xCoor, yCoor, 100, 100);
      textSize(40);
      fill(255);
      text("" + numero, xCoor+15, yCoor+65);
    } else {
      fill(numero%10*25, 60, 180);
      rect(xCoor, yCoor, 100, 100);
      textSize(35);
      fill(255);
      text("" + numero, xCoor+5, yCoor+65);
    }
  }
}


//reinicia el juego si se presiona r
void keyPressed() {
  if (key == 'r') {
    setup();
  }
}
