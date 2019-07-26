global class myFirstSchedule implements Schedulable{

    global void execute(SchedulableContext sc){
        System.debug(UserInfo.getFirstName());
    }
}