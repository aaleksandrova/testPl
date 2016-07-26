<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script type="text/javascript" src="Script/jquery-1.2.6.js"></script>

    <script type="text/javascript" src="Script/CommonFunction.js"></script>

</head>
<body>
    <asp:Label runat="server" ID="lblTime"></asp:Label>
    <form id="form1" action="" method="post"> 
         <div style="display: block;">
                <input  type="text" id="txtVer" style="width: 250px" />
          </div>
    <table cellpadding="2" cellspacing="2" border="1" width="400px">
        <tr style="background-color: Gray">
            <td colspan="2" align="center">
                <b>Product Entry Form</b>
            </td>
        </tr>
        <tr>
            <td>
                Product Name
            </td>
            <td>
                <input type="text" id="txtName" style="width: 250px" />
            </td>
        </tr>
        <tr>
            <td>
                Unit
            </td>
            <td>
                <input type="text" id="txtUnit" style="width: 250px" />
            </td>
        </tr>
        <tr>
            <td>
                Qty
            </td>
            <td>
                <input type="text" id="txtQty" style="width: 250px" />
            </td>
        </tr>
      
        <tr>
            <td colspan="2" align="center">
                <input type="button" id="butSave" value="Save" onclick="SaveProducts()" />
            </td>
        </tr>
    </table>
    <br />
    <br />
    <div id="ListingData">
    </div>
    </form>
</body>
</html>
