function DoAjaxCall(parameter, datatype, data) {
    jQuery.ajax({
        type: 'POST',
        url: "ProductList.ashx" + parameter,
        data: data,
        dataType: datatype,
        success: function(data, textStatus) {
            try {
                var jsonData = eval(data);
                if (jsonData.IsSucess) {
                    eval(jsonData.CallBack + '(jsonData.ResponseData, jsonData.Message)');
                }
                else {
                    alert(jsonData.Message + jsonData.IsSucess);
                }
            }
            catch (err) {
                alert(err);
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            alert("Error:" + errorThrown +" and "+jqXHR+" and "+textStatus);
        }
    });
}

$(document).ready(function() { FillListing(); });



function SaveProducts(mode) {
    var Param = "name=" + document.getElementById("txtName").value + "&unit=" + document.getElementById("txtUnit").value + "&Qty=" + document.getElementById("txtQty").value + "&ver=" + document.getElementById("txtVer").value;

    var ProductID = $("#txtId").val();

    if (ProductID == 0) {
        DoAjaxCall("?method=Insert&callbackmethod=InsertProductSucess&" + Param, "json", "");
    }
    if (ProductID != 0 && (mode == undefined)) {
        DoAjaxCall("?method=Update&callbackmethod=UpdateProductSucess&" + Param + "&ProductID=" + ProductID, "json", "");
    }
    if (mode == 'asIs') {
        DoAjaxCall("?method=UpdateAsIs&callbackmethod=UpdateProductSucess&" + Param + "&ProductID=" + ProductID, "json", "");
    }
}
function InsertProductSucess(data, message) {
    FillListing();
    alert(message);
    ClearValue();
}

function ClearValue() {
    $("#txtName").val("");
    $("#txtUnit").val("");
    $("#txtQty").val("");
    $("#txtId").val("");
    $("#txtVer").val("");
}

function UpdateProductSucess(data, message) {
    if (data == true) {
        FillListing();
        alert(message);
        //ProductID = 0;
        ClearValue();
        $("#errorMsg").css('display', 'none');
    } else {
        $("#errorMsg").css('display', 'block');
    }
}

function FillListing() {
    DoAjaxCall("?method=getproducts&callbackmethod=FillListingSucess", 'json', "");
}

function FillListingSucess(data, message) {
    var str = " <table border='1' cellpadding='2' cellspacing='0' width='500px'><tr><td colspan='5' style='background-color: Gray' align='center'><b>Product Listing Page</b></td></tr><tr> <td>Product Name</td><td>Unit</td><td>Qty</td><td>Delete</td><td>Edit</td></tr>";

    for (var i = 0; i < data.length; i++) {
        str += "<tr><td>" + data[i].Name + "</td>";
        str += "<td>" + data[i].Unit + "</td>";
        str += "<td>" + data[i].Qty + "</td>";
        str += "<td><a href='javascript:void(0)' onclick='DeleteProduct(" + data[i].ProductID + ")'>Delete</a></td>";
        str += "<td><a href='javascript:void(0)' onclick='EditProduct(" + data[i].ProductID + ")'>Edit</a></td></tr>";
    }
    str += "</table>";
    $('#ListingData').html(str);
}


function DeleteProduct(ProductID) {
    DoAjaxCall("?method=delete&callbackmethod=DeleteSucess&param=" + ProductID, "json", "");

}

function DeleteSucess(data, message) {
    FillListing();
    alert(message);
}

function EditProduct(ProductID) {
    DoAjaxCall("?method=getbyid&callbackmethod=EditSucess&param=" + ProductID, "json", "");
}

function EditSucess(data, message) {
    $("#txtName").val(data.Name);
    $("#txtUnit").val(data.Unit);
    $("#txtQty").val(data.Qty);
    $("#txtVer").val(bin2string(data.TimeStamp));
    $("#txtId").val(data.ProductID);
}

function bin2string(array) {
    var result = "";
    for (var i = 0; i < array.length; ++i) {
        result += (String.fromCharCode(array[i]));
    }
    return result;
}
function pack(bytes) {
    var str = "";
    for (var i = 0; i < bytes.length; i += 2) {
        var char = bytes[i] << 8;
        if (bytes[i + 1])
            char |= bytes[i + 1];
        str += String.fromCharCode(char);
    }
    return str;
}