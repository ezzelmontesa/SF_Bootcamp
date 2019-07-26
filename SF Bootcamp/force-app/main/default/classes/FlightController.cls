public with sharing class FlightController {
    public static Booking__c bookingDetails;
    public static Flight__c flightDetails;
    public static Contact passengerDetails;
    
    public FlightController(){
        bookingDetails = new Booking__c();
        flightDetails = new Flight__c();
        passengerDetails = new Contact();
    }
    
    @AuraEnabled
    public static List<Flight__c> getFlights(){
        return [SELECT ID, Flight_Number__c, Departure_Date__c, Departure_Time__c, Arrival_Time__c, Seats_Available__c, Flight_From__c, Flight_To__c, Depart_Arrive__c, Flight_Price__c
                  FROM Flight__c
                 WHERE Seats_Available__c != 0];
    }
    
    @AuraEnabled
    public static List<Flight__c> getFlightwithFilters(String origin, String destination, string departure){
        List<Flight__c> flightList = new List<Flight__c>();
        String searchQuery = 'SELECT ID, Flight_Number__c, Departure_Date__c, Departure_Time__c, Arrival_Time__c, Seats_Available__c, Flight_From__c, Flight_To__c, Depart_Arrive__c, Flight_Price__c FROM Flight__c ';
        flightList = Database.query(searchQuery + 'WHERE Flight_From__c = \'' + origin + '\' AND Flight_To__c = \'' + destination + '\' AND Departure_Date__c =' + departure);
        return flightList;
    }
    
    @AuraEnabled
    public static Flight__c getFlightSelected(String flightID){
        return [SELECT ID, Flight_Number__c, Departure_Date__c, Departure_Time__c, Arrival_Time__c, Seats_Available__c, Flight_From__c, Flight_To__c, Depart_Arrive__c, Flight_Price__c
                FROM Flight__c
                WHERE ID = :flightID];
    }
    
    
    
    @AuraEnabled
    public static String checkContact(String fName, String lName, String passEmail){
        String returnString = '';
        List<Contact> selectedContact = new List<Contact>();
        Booking__c finalBooking = new Booking__c();
        selectedContact = [SELECT ID, Contact.FirstName, Contact.LastName, Email
                           FROM Contact
                           WHERE Email = :passEmail];
        
        if(selectedContact.size() == 1){
            if(selectedContact[0].FirstName.toLowerCase() == fName.toLowerCase() && selectedContact[0].LastName.toLowerCase() == lName.toLowerCase()){
                returnString = selectedContact[0].ID;
            }else{
                try{
                    Contact updateContact = selectedContact[0];                    
                    updateContact.FirstName = capitalizedFirstLetter(fName);
                    updateContact.LastName = capitalizedFirstLetter(lName);
                    update updateContact;
                    
                }catch(DmlException e){
                    //System.debug('An unexpected error has occurred: ' + e.getMessage());
                    throw new AuraHandledException(e.getMessage());
                }
                
                returnString = selectedContact[0].ID;
            }
        }else if(selectedContact.size() == 0){
            try{
                Contact newContact = new Contact();
                newContact.FirstName = capitalizedFirstLetter(fName);
                newContact.LastName = capitalizedFirstLetter(lName);   
                newContact.Email = passEmail;
                
                insert newContact;
                returnString = newContact.ID;
                
            }catch(DmlException e){
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }                
        }
        
        return returnString;
    }
    
    @AuraEnabled
    public static String finalizeBooking(String passengerID, String flightID){
        String returnString = '';
        system.debug(passengerID + ' ' + flightID);
        try{
            Booking__c newBooking = new Booking__c();
            newBooking.Flight__c = flightID;
            newBooking.Passenger__c = passengerID;
            insert newBooking;
            returnString = newBooking.ID;            
        }catch(DmlException e){
            //System.debug('An unexpected error has occurred: ' + e.getMessage());            
            returnString = e.getMessage();
            throw new AuraHandledException(e.getMessage());
        }
        return returnString;
    }
    
    //for name capitalization
    private static String capitalizedFirstLetter(String stringName){
        String name = stringName;
        List<String> names = name.split(' ');
        for (Integer i = 0; i < names.size(); i++){
            names[i] = names[i].capitalize();
        }            
        name = String.join(names, ' ');
        
        return name;
    }
    
    @AuraEnabled
    public static void sendEmail(String bookingID){
        bookingDetails = [SELECT ID, Name, Flight__c, Passenger__c
                                      FROM Booking__c
                                     WHERE ID = :bookingID];
        flightDetails = [SELECT ID, Flight_Number__c, Flight_From__c, Flight_To__c, Departure_Date__c, Flight_Price__c
                                    FROM Flight__c
                                   WHERE ID = :bookingDetails.Flight__c];
        passengerDetails = [SELECT ID, FirstName, LastName, Email
                                     FROM Contact
                                    WHERE ID = :bookingDetails.Passenger__c];
        List<String> emailTo = new List<String>{passengerDetails.Email};
        String htmlMessage = '<p>Hi ' + passengerDetails.FirstName + '!</p></br> <p>Welcome to Deloitte Airlines! Here are your flight details.</p>';
        String htmlBody = '<table> <tr><td>Flight Number : </td><td>' + flightDetails.Flight_Number__c + '</td></tr><tr><td>Origin : </td><td>' + flightDetails.Flight_From__c + '</td></tr><tr><td>Destination : </td><td>' + flightDetails.Flight_To__c + '</td></tr><tr><td>Departure Date : </td><td>' + flightDetails.Departure_Date__c + '</td></tr><tr><td>Price : </td><td>' + flightDetails.Flight_Price__c + '</td></tr></table>';
        system.debug(htmlMessage + htmlBody);
        
        PageReference pdfDetails = Page.VFPageEmail_DeloitteAirlines;
        pdfDetails.getParameters().put('id', bookingID );
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('Booking#' + bookingDetails.Name + '.pdf');
        attach.setInline(false);
        attach.body = pdfDetails.getContent();
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailTo);
        mail.setSubject('Booking Number : ' + bookingDetails.Name);
        mail.setHtmlBody(htmlMessage + htmlBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    
    public Booking__c getBookingDetails(){
        return bookingDetails;
    }
    public Flight__c getFlightDetails(){
        return flightDetails;
    }
    public Contact getPassengerDetails(){
        return passengerDetails;
    }
    
}