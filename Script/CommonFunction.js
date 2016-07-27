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

$(document).ready(function () {
    $(".hide").css('display', 'none');
    FillListing();
});



function SaveProducts(mode) {
    var Param = "name=" + $("#txtName").val() + "&unit=" + $("#txtUnit").val() + "&Qty=" + $("#txtQty").val() + "&ver=" + $("#txtVer").val();

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
    if (mode == 'setFromDB') {
        FillListing();
        ClearValue();
    } 
}

function saveValue(id) {
    var ProductID = $("#txtId").val();
    var value = $("#" + id).val();
    switch (id) {
        case "txtName":
            DoAjaxCall("?method=UpdateName&callbackmethod=UpdateProductSucess&" + "name=" + value + "&ProductID=" + ProductID, "json", "");
            break;
        case "txtUnit":
            DoAjaxCall("?method=UpdateUnit&callbackmethod=UpdateProductSucess&" + "unit=" + value + "&ProductID=" + ProductID, "json", "");
            break;
        case "txtQty":
            DoAjaxCall("?method=UpdateQuality&callbackmethod=UpdateProductSucess&" + "Qty=" + value + "&ProductID=" + ProductID, "json", "");
            break;

        default:
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
    $(".hide").css('display', 'none');
}

function UpdateProductSucess(data, message) {
    if (data == true) {
        FillListing();
        ClearValue();
    } else {
        $(".hide").css('display', 'block');
        GetNewProduct($("#txtId").val());
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

function GetNewProduct(ProductID) {
    DoAjaxCall("?method=getbyid&callbackmethod=EditNewSucess&param=" + ProductID, "json", "");
}

function EditNewSucess(data, message) {
    $("#txtNewName").val(data.Name);
    $("#txtNewUnit").val(data.Unit);
    $("#txtNewQty").val(data.Qty);
    $("#txtNewVer").val(data.TimeStampAsString);
    $("#txtNewId").val(data.ProductID);
}

function EditSucess(data, message) {
    $("#txtName").val(data.Name);
    $("#txtUnit").val(data.Unit);
    $("#txtQty").val(data.Qty);
    $("#txtVer").val(data.TimeStampAsString);
    $("#txtId").val(data.ProductID);
}
