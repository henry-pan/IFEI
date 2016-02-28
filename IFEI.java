import java.io.BufferedReader;
import java.io.IOException;
import java.io.FileReader;
import java.io.File;
import java.util.Scanner;
import static java.lang.System.*;

class IFEI{

    public static void main (String[] args) throws IOException{
    	//Reads from a text file
    	System.out.println(">>> Please load a game by typing in the name of the game file, without the file extension: ");
    	Scanner stdin = new Scanner (in);
    	String file= stdin.nextLine();
    	String fi=file+".txt";
    	File f= new File(fi);
    	if(!f.exists()){
    		System.out.println("\n============================");
    		System.out.println("| The file does not exist  |");
    		System.out.println("============================");
    		System.exit(0);
    	}
    	else{
    		String eq="===============================================================";
    		System.out.println("\n=" + eq.substring(0,(file + " loaded  |").length()) + "=");
    		System.out.println("| " +file + " loaded  |");
    		System.out.println("=" + eq.substring(0,(file + " loaded  |").length()) + "=");
    	}
    	FileReader readingFile= null;
        readingFile= new FileReader(fi);
        BufferedReader br = (new BufferedReader(readingFile));
        String line= null;
        
        dLinkedList insideRoom = new dLinkedList();
        while((line =br.readLine()) != null) {
            if (line.matches ("^\\s*$")) continue;
            int room=0;
            int path=0;
            //Makes new room.
            if (line.startsWith("[Room")){
            	room = Character.getNumericValue((line.substring(6)).charAt(0));
            	insideRoom.insert();
            	insideRoom.insertRoom(room);
            }
            //Gets paths from room (int destination, string option).
            else if (line.startsWith("[Path-to")){
            	path = Character.getNumericValue((line.substring(9)).charAt(0));
            	insideRoom.optionDesc(line.substring(line.lastIndexOf("]") + 2));
            	insideRoom.insertPath(path);
            }
            //Gets description from room.
            else if(line != null){
            	insideRoom.insertDescription(line);
            }
        }
        //Displays the first room.
        insideRoom.displayStart();
        boolean readFile= true;
        while(readFile == true){
            for (;;) {
                if (! stdin.hasNextLine()) break;
                String inputline = stdin.nextLine();
                if (inputline.matches ("^\\s*$")) continue;
                String command = inputline.toLowerCase();
                if (command.equals("exit")){
                	readFile =false;
                	System.out.println("\n>>> Are you sure you want to exit the game? Type 'exit' again to quit.");
                	if(((stdin.nextLine()).toLowerCase()).equals("exit")){
                		System.out.println("\n>>> Goodbye.");
                		break;
                	}else{
                		System.out.println("\n>>> Cancelled.");
                	}
                }
                //Displays every possible command, including reserved commands.
                else if (command.equals("help")){
                	System.out.println("\n================");
                	System.out.println("| Command List |");
                	System.out.println("================");
                	System.out.println("Help\nRepeat\nRestart\nExit");
                	insideRoom.displayOpts();
                }
                //Displays the first room of the game.
                else if(command.equals("restart")){
                	System.out.println("\n>>> Are you sure you want to restart the game? Type 'restart' again to quit.");
                	if(((stdin.nextLine()).toLowerCase()).equals("restart")){
                		System.out.println("\n================");
                		System.out.println("| Restarting...|");
                		System.out.println("================");
                		insideRoom.displayStart();
                	}else{
                		System.out.println("\n>>> Cancelled.");
                	}
                }
                //Displays the contents of the current room again.
                else if(command.equals("repeat")){
                	insideRoom.display();
                }
                //Checks if command is valid. And if it is, it goes to room destination.
                else{
                	insideRoom.dest(command);
                	insideRoom.display();
                }
            }
        }
    }
}
