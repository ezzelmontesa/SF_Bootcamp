public class myQueueableClass implements Queueable{
    
    public void execute(QueueableContext qc){
        System.debug('Hello World');
        //System.enqueueJob(new myQueuableClassAgain());
    }
}