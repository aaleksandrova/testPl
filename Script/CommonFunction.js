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
    getUserId();
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

function SaveProductPessimistic() {
    var param = "name=" + $("#pName").val() + "&unit=" + $("pUnit").val() + "&Qty=" + $("#pQty").val();
    var productId = $("#txtId").val();

    if (productId == 0) {
        DoAjaxCall("?method=Insert&callbackmethod=InsertProductSucess&" + param, "json", "");
    }
    else {
        DoAjaxCall("?method=UpdatePessimistic&callbackmethod=UpdateProductSucess&" + Param + "&ProductID=" + ProductID, "json", "");
    }
}

function getUserId() {
    DoAjaxCall("?method=GetUserId&callbackmethod=IdSucess", "json", "");
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
    $("#pName").val("");
    $("#pUnit").val("");
    $("#pQty").val("");
    $("#pId").val("");
    $("#pVer").val("");
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
    DoAjaxCall("?method=getproducts&callbackmethod=FillListingSucess2", 'json', "");
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

function FillListingSucess2(data, message) {
    var str = " <table border='1' cellpadding='2' cellspacing='0' width='500px'><tr><td colspan='7' style='background-color: Gray' align='center'><b>Product Listing Page</b></td></tr><tr> <td>Product Name</td><td>Unit</td><td>Qty</td><td>LockTime</td><td>LockUser</td><td>Delete</td><td>Edit</td></tr>";

    for (var i = 0; i < data.length; i++) {
        str += "<tr><td>" + data[i].Name + "</td>";
        str += "<td>" + data[i].Unit + "</td>";
        str += "<td>" + data[i].Qty + "</td>";
        str += data[i].LockTime == "/Date(-62135596800000)/" ? "<td></td>" : "<td>" + data[i].LockTime + "</td>";
        str += data[i].LockUser == null ? "<td></td>" : "<td>" + data[i].LockUser + "</td>";
        str += "<td><a href='javascript:void(0)' onclick='DeleteProduct(" + data[i].ProductID + ")'>Delete</a></td>";
        var par = "\'" + data[i].ProductID.toString() + "\'" + ", " + "\'" + data[i].LockUser+ "\'";
        str += "<td><a href='javascript:void(0)' onclick='EditProductBlock(" +  data[i].ProductID + ")'>Edit</a></td></tr>";
    }
    str += "</table>";
    $('#ListingData2').html(str);
}

function DeleteProduct(productId) {
    DoAjaxCall("?method=delete&callbackmethod=DeleteSucess&param=" + productId, "json", "");
}

function DeleteSucess(data, message) {
    FillListing();
    alert(message);
}

function EditProduct(productId) {
    DoAjaxCall("?method=getbyid&callbackmethod=EditSucess&param=" + productId, "json", "");
}


function EditProductBlock(productId, lockUser) {
    var param = "guid=" + $("#userId").val();
    if (lockUser == null) {
        DoAjaxCall("?method=getbyidBlock&callbackmethod=EditSucessBlock&" + param + "&ProductID=" + productId, "json", "");
    }
    else {
        alert("BLOCKED");
    }
}

function GetNewProduct(productId) {
    DoAjaxCall("?method=getbyid&callbackmethod=EditNewSucess&param=" + productId, "json", "");
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

function EditSucessBlock(data, message) {
    DoAjaxCall("?method=getbyid&callbackmethod=SetProd&param=" + data, "json", "");
}

function SetProd(data, message) {
    $("#pName").val(data.Name);
    $("#pUnit").val(data.Unit);
    $("#pQty").val(data.Qty);
    $("#pVer").val(data.TimeStampAsString);
    $("#pId").val(data.ProductID);
}

function IdSucess(data, message) {
    $("#userId").val(data);
}
