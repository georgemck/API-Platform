<%@ page contentType="application/json" language="java" %><%@ page import="java.io.*" %><%@ page import="java.util.Arrays" %><%@ page import="java.util.Collections" %><%@ page import="java.util.Comparator" %><%@ include file="config.jsp" %><%
String transactionId = "";
String merchantTransactionId = "";
String transactionAuthCode = "";
String consumerId = "";

File directory = new File(application.getRealPath("/transactionData/")); 
File[] files = directory.listFiles();
if(files.length>0) {
    Arrays.sort(files, new Comparator<File>(){
        public int compare(File f1, File f2)
        {
            return Long.valueOf(f1.lastModified()).compareTo(f2.lastModified());
        } });
    Collections.reverse(Arrays.asList(files));
}

%>{"totalNumberOfTransactions":"<%=directory.listFiles().length%>","transactionList":[<%

if(directory.listFiles().length>0) {
    int i = 0;
    for(File imageFile : files){  
          String imageFileName = imageFile.getName(); 
            RandomAccessFile inFile1 = new RandomAccessFile(application.getRealPath("transactionData/" + imageFileName),"r");
            transactionId = inFile1.readLine();
            merchantTransactionId = inFile1.readLine();
            transactionAuthCode = inFile1.readLine();
            consumerId = inFile1.readLine();
            if(transactionId==null || transactionId.equalsIgnoreCase("null"))
                transactionId = "";
            if(transactionId.indexOf(194)!=-1)
                transactionId = transactionId.substring(0, transactionId.length()-2);
            if(merchantTransactionId==null || merchantTransactionId.equalsIgnoreCase("null"))
                merchantTransactionId = "";
            if(merchantTransactionId.indexOf(194)!=-1)
                merchantTransactionId = merchantTransactionId.substring(0, merchantTransactionId.length()-2);
            if(transactionAuthCode==null || transactionAuthCode.equalsIgnoreCase("null"))
                transactionAuthCode = "";
            if(transactionAuthCode.indexOf(194)!=-1)
                transactionAuthCode = transactionAuthCode.substring(0, transactionAuthCode.length()-2);
            if(consumerId==null || consumerId.equalsIgnoreCase("null"))
                consumerId = "";
            if(consumerId.indexOf(194)!=-1)
                consumerId = consumerId.substring(0, consumerId.length()-2);
            inFile1.close();
            if((i==directory.listFiles().length-1) || (i==4)) {
                  %>{"transactionId":"<%=transactionId%>","merchantTransactionId":"<%=merchantTransactionId%>","transactionAuthCode":"<%=transactionAuthCode%>","consumerId":"<%=consumerId%>"}]}<%
            } else {
                  %>{"transactionId":"<%=transactionId%>","merchantTransactionId":"<%=merchantTransactionId%>","transactionAuthCode":"<%=transactionAuthCode%>","consumerId":"<%=consumerId%>"},<%
            }
        i += 1;
        if(i==5)
            break;
    } 
} else {
        %>]}<%
}
%>
