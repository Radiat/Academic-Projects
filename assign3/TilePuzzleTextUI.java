import java.io.*;

/** The TilePuzzleTextUI class.
 * 
 *  This class provides a text-based user interface (UI)
 *  to the tile puzzle game. It contains no game-playing 
 *  knowledge. Its only role is to prompt the user for 
 *  moves, update the underlying tile puzzle, and update 
 *  the user on the result of the move and the current 
 *  status of the game.
 */
public class TilePuzzleTextUI {
  
  /** The reference to the underlying puzzle class,
   * which needs to be updated when a tile is selected. 
   */
  private TilePuzzle puzzle;
  
  /** The constructor for the text-based tile puzzle game.
   */
  public TilePuzzleTextUI(TilePuzzle puzzle) {
    this.puzzle = puzzle;
  }
  
  /** Start the tile puzzle game, and continue until the
   * player has reached a winning tile layout.
   */
  public void startGame() throws IOException {
    System.out.println();

    // continue playing the game until the winning condition has been reached
    while(!puzzle.hasWon()) {
      // display the current state of the tile puzzle game
      System.out.println(puzzle);
      System.out.println();

      // prompt the user for his/her move
      System.out.println("Please enter the number of the tile to move, followed by the Enter key.");
      System.out.print("> ");

      // read the specified move from the console
      BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
      String tileText = "";
      tileText = buffer.readLine();
      System.out.println();
      
      // determine what move the user specified
      int tileNum = Integer.parseInt(tileText);
      if (tileNum < 1 || tileNum > puzzle.maxTileValue()) {
        // display an error message if an invalid tile is specified
        System.out.println("Please specify a valid tile to move.");
      }
      else {
        // make the move
        boolean validMove = puzzle.moveTile(tileNum);
        if (!validMove) {
          // display an erorr message if the tile specified could not be moved
          System.out.println("Unable to move that tile. Please try again.");
        }
      }
    }
    System.out.println(puzzle);
    
    // pat the user on the back
    System.out.println("Congratulations! You solved the tile puzzle in " + puzzle.numTileMoves() + " moves!");
  }
  
  
}




