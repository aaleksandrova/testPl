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
                <input  type="text" id="txtId" style="width: 250px" />
          </div>
        <div id="errorMsg" class="hide" style=" display: none;">
            <div style="color: red;">
                The record you attempted to edit was modified by another user after you got the original value.
            </div>
            <input type="button" id="saveAsIs" value="Save anyway" onclick="SaveProducts('asIs')" />
        </div>
    <table cellpadding="3" cellspacing="3" border="1" width="400px">
        <tr style="background-color: Gray"><td colspan="3" align="center"><b>Product Entry Form</b></td></tr>
        <tr><td>Product Name</td><td><input type="text" id="txtName" style="width: 250px" /></td><td><div class="hide"><input type="button" value="Save this value" onclick="saveValue('txtName')" /></div></td></tr>
        <tr><td>Unit</td><td><input type="text" id="txtUnit" style="width: 250px" /></td><td><div class="hide"><input type="button" value="Save this value" onclick="saveValue('txtUnit')" /></div></td></tr>
        <tr><td>Qty</td><td><input type="text" id="txtQty" style="width: 250px" /></td><td><div class="hide"><input type="button" value="Save this value" onclick="saveValue('txtQty')" /></div></td></tr>
        <tr><td colspan="3" align="center"><input type="button" id="butSave" value="Save" onclick="SaveProducts()" /></td></tr>
    </table>
    <br />
    <br />
           <div style="display: block;">
                <input  type="text" id="txtNewVer" style="width: 250px" />
                <input  type="text" id="txtNewId" style="width: 250px" />
          </div>
        <div id="newData" class="hide" style=" display: none;">
    <table cellpadding="2" cellspacing="2" border="1" width="400px">
        <tr style="background-color: red"><td colspan="2" align="center"><b>New data from DB</b></td></tr>
        <tr><td>Product Name</td><td><input type="text" id="txtNewName" style="width: 250px" /></td>/tr>
        <tr><td>Unit</td><td><input type="text" id="txtNewUnit" style="width: 250px" /></td></tr>
        <tr><td>Qty</td><td><input type="text" id="txtNewQty" style="width: 250px" /></td>></tr>
        <tr><td colspan="2" align="center"><input type="button" id="butNewSave" value="Save" onclick="SaveProducts('setFromDB')" /></td></tr>
    </table>
              </div>
    <br />
    <br />
    <div id="ListingData">
    </div>
    </form>
</body>
</html>
