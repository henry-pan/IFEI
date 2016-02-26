class queuePath{
    private Path[] array;
    private int front;
    private int rear;
    private int counter;
    public queuePath(){
        array= new Path[20];
        front=0;
        rear=-1;
        counter=0;
    }
    
	private class Path{
        private String p;
        private int t;
        public Path(String path, int destination){
            p=path;
            t=destination;
        }
        public void display(){
            System.out.println(p);
        } 
        public String pathDesc(){
        	return p;
        }  
        public int dest(){
            return t;
        }
    }
    
    public void insert(String path, int dest){
        if(rear==19){
            rear=-1;
        }
        array[++rear]= new Path(path,dest);
        counter++;
    }
    
	public void remove(int pos){
        array[pos].display();
    }
	
	//will return destination room, or 0 if command not found.
	public int command(int pos, String com){
		int result=0;
		for(int i=0; i <counter;i++){
			if(array[i]== null){
				break;
			}else if((array[i].pathDesc().toLowerCase()).equals(com)){
				result=array[i].t;
				break;
			}
		}
		return result;
	}
}
