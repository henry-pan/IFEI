//Doubly Linked List.
//Each node is a room. In each room there is a queue for the paths,
//and an array for the description of the room. 
import static java.lang.System.*;
public class dLinkedList {

    private class node {
    	boolean save;
        int room;
        int counter=0;
        node prev;
        node next;
        queuePath pathQ;
        private String[] roomDesc;
        int optc;
        public node(){
        	save = false;
            pathQ=new queuePath();
            optc=0;
            roomDesc=new String[50]; // The description can't be more than 50 lines.
        }
    }
    private boolean bookmark= false;
    private node first = null;
    private node current = null;
    private node last = null;
    private int counter=0;


//-------------------------Work on input file---------------------------    
    public void insert(){
        node n= new node();
        if(first==null){
            last=n;
            first=n;
            current=n;
        }else{
            node temp=last;
            last.next=n;
            n.prev=temp;
            last=n;
            current=n;
        }
        counter++;
    }
    
    public void insertRoom (int r){
        node n=current;
        n.room= r;        
    }
    
    public String opt= null;
    
    //Gets option description from file.
    public void optionDesc(String o){
        opt=o;
        node n=current;
        n.optc++;
    }
    
    //gets room of next destination and the option and inserts into queue
    public void insertPath(int dest){
        node n=current;
        n.pathQ.insert(opt, dest);
    }
    
    //inserts description of room into an array.
    public void insertDescription(String description){
        node n=current;
        if(current== null){
            System.out.println("Invalid");
        }else{
            n.roomDesc[n.counter]=description;
            n.counter++;
        }
    }


//---------------Work on client input-----------------------------------  
    
    //Goes to room given its number by traversing through the nodes.
    public void goToDest(int pos){
        node n=current;
        if(pos== 0){
            System.out.println("\n>>> Invalid command.");
        }else{
        	node temp=first;
            while(temp!=null){
                if(temp.room==pos){
                	break;
                }
                temp=temp.next;
            }
            if(temp==null){
                System.out.println("The path you want does not match any path from file");
            }        
        	current=temp;
        }
    }
    
    //sees if command is valid, and if it is, then calls goToDest on that room.
    public void dest(String com){
    	node p=current;
    	int d=p.pathQ.command(p.room,com);
    	goToDest(d);
    }
    
    //Adds bookmark to current room.
    public void save(){
    	if(bookmark==false){
    		node p=current;
    		p.save=true;
    		bookmark=true;
    		System.out.println("\nSaved!");
    		display();
    	}else{
    		System.out.println("You already have a saved room.");
    		System.out.println("To save this one instead type eject then save"); 
    	}
    }
    
    //Goes to room that you have saved.
    public void load(){
    	node temp=first;
        while(temp!=null){
            if(temp.save==true){
            	current= temp;
            	System.out.println("\n================");
                System.out.println("|  Loading...  |");
                System.out.println("================");
                break;
            }
            temp=temp.next;
        }
        if(temp ==null){
        	System.out.println("\nYou haven't saved your game yet");
        }
        display();
    }
    
    //Unloads the game so you can load another one
    public void eject(){
    	node temp=first;
        while(temp!=null){
            if(temp.save==true){
            	temp.save=false;
            	bookmark=false;
                break;
            }
            temp=temp.next;
        }
        if(temp ==null){
        	System.out.println("\nThere is no game saved");
        }else{
        	System.out.println("Ejected!");
        }
    }
    
    //Displays first room and its content: Description and Options.
    public void displayStart(){
        node p=first;
        current=first;
        System.out.print("\n");
        for(int i=0;i<p.counter;i++){
        	System.out.println(p.roomDesc[i]);
        }
        for(int i=0;i<p.optc;i++){
            p.pathQ.remove(i);
        } 
        System.out.print("\n");
    }
    
    //Displays description of current room and its options that the user can take.
    public void display(){
        node n=current;
        System.out.print("\n");
        for(int i=0;i<n.counter;i++){
        	System.out.println(n.roomDesc[i]);
        }
        for(int i=0;i<n.optc;i++){
            n.pathQ.remove(i);
        }
        System.out.print("\n");
    }
    
    //Displays options of current room without dash.
    public void displayOpts(){
    	node n=current;
    	for(int i=0;i<n.optc;i++){
            n.pathQ.remove2(i);
        }
    }
}
