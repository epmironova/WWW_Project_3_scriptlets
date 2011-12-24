<%-- 
    Document   : index
    Created on : 2011-12-11, 23:31:18
    Author     : Eli
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="javax.servlet.*,java.io.File,javax.xml.parsers.*,java.util.*,org.w3c.dom.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div style="text-align:center">
        <h1>Shopping Cart</h1>
        <form name="countTotal" method="POST" >
        <table border="1" width="1" cellspacing="2" cellpadding="4" align="center">
            <thead>
                <tr style="background-color: rgb(245, 245, 245)">
                    <th>Item</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    //Here we take the data from the xml file and display it in a table
                    String path = application.getRealPath("/").concat("WEB-INF\\itemsPrices.xml");                 
                    File file = new File(path);
                    //File file = new File("C:\\Users\\Eli\\Documents\\NetBeansProjects\\ShoppingCart_scriptlets\\web\\WEB-INF\\itemsPrices.xml");
                    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                    DocumentBuilder db = dbf.newDocumentBuilder();
                    Document doc = db.parse(file);
                    doc.getDocumentElement().normalize();

                    NodeList itemLst = doc.getDocumentElement().getElementsByTagName("item");
                    
                    //Here we declare the total price of all selected items 
                    Double total=new Double(0);
                    
                    //Here we iterate through each item from the xml file to display its name and price in a new row, 
                    //so that we can add new items in the xml file without changing the code
                    for (int s = 0; s < itemLst.getLength(); s++) {
                        %>
                        <tr>
                            <%
                                Node item = itemLst.item(s);
                                Element itemElm = (Element) item;

                                NodeList nameItem = itemElm.getElementsByTagName("name");
                                String name=nameItem.item(0).getFirstChild().getNodeValue();
                                %>
                                <td><%=name%></td>
   
                                
                                <%
                                NodeList priceItem = itemElm.getElementsByTagName("price"); 
                                String price=priceItem.item(0).getFirstChild().getNodeValue();
                                %>
                                <td><%=price%></td>
  
                                
                                <% 
                                //If we don't have any cookie for it,
                                //the amount of the item will be 0
                                String amountCookie="0";
                                
                                //Here we take all cookies
                                Cookie[] cookies=request.getCookies();
                                
                                //If we have cookie for the amount of the item,we will find it
                                if(cookies!=null && cookies.length>0){
                                           for(int i=0;i<cookies.length;i++){
                                               Cookie amount=cookies[i];
                                               if(amount.getName().equals("quantity"+name)){
                                                   amountCookie=amount.getValue();
                                                   //out.print("Geted value for cookie:"+amountItem+"<br/>");
                                               }}}   
                                
                                //Here we take the amount of each item from the text input
                                String value = request.getParameter("quantity"+name);                               
                                //out.print("value is:"+value+"<br/>");                               

                                //If something happens, we will take the cookie                                                              
                                if(value==null && !amountCookie.equals("0")){
                                    session.setAttribute("qnt"+name, amountCookie);  
                                    //out.print("The seted attrubute is"+amountItem+"<br/>");
                                }
                                //If we start using the application or the input is not an integer, we will set 0
                                else              
                                    if(value==null || !value.matches("\\d+")){
                                        session.setAttribute("qnt"+name, "0");                                       
                                        //out.print("The seted attrubute is 0");
                                    } 
                                //If the input is an integer and if it is different from the cookie for it, we add new cookie
                                else 
                                    if (!value.equals(amountCookie)){
                                        session.setAttribute("qnt"+name, value);
                                        Cookie cookie=new Cookie("quantity"+name,value);
                                        cookie.setMaxAge(30*60);
                                        response.addCookie(cookie);
                                        //out.print("Added cookie and seted attribute is:"+cookie.getValue()+"<br/>");
                                    }
                               //else
                                        //out.print("No cookie was added this time + no attrubute is setted"+"<br/>");  
                                                            

                                String quantity=session.getAttribute("qnt"+name).toString();  
                                //out.print("The getted attribute is:"+quantity+"<br/>");
                                %>
                                
                                <td><input type="text" name=<%="quantity"+name%> size="10" value="<%
                                out.print(quantity);
                                //if(quantity.equals(amountItem)){
                                //out.print(amountItem);
                                //}                              
                                //else if(quantity.equals("0"))
                                 //       out.print(amountItem);
                               // else
                                   // out.print(quantity);                               
                                %>"/></td>
                                
                               
                                <td><input type="text" size="10" readonly="readonly" name=<%="total"+name%>                               
                                           <%                                                                                                                                                                                                                                                                                                                                                                 
                                           Double priceOfItem=Double.valueOf(price);                                            
                                           Double quantityOfItem=Double.valueOf(quantity);
                                           Double totalOfItem=priceOfItem*quantityOfItem;
                                           total+=totalOfItem;
                                           %> 
                                           value=<%=totalOfItem%>
                                           <%//}}%> 
                                          /></td>
                        </tr>
                        <%
                    }
                %>
                <tr>
                    <td>Total</td>
                    <td></td>
                    <td></td>
                    <td><input type="text" name="totalAll" size="10" readonly="readonly" value="<%=total%>"/></td>
                </tr>
            </tbody>
        </table>
                <input type="submit" value="Total" name="totalBtn" />
        </form>
                <a href="https://github.com/epmironova/WWW_Project_3_scriptlets" target="_blank">Report</a> 
                <a href="https://github.com/epmironova/WWW_Project_3_scriptlets/zipball/master" target="_blank">Code</a>
        </div>
    </body>
</html>
