<%@ WebHandler Language="C#" Class="ProductList" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;

public class ProductList : IHttpHandler
{
    string MethodName = string.Empty;
    string CallBackMethodName = string.Empty;
    object Parameter = string.Empty;
    DbProducts _DbProducts = new DbProducts();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/x-javascript";
        MethodName = context.Request.Params["method"];
        Parameter = context.Request.Params["param"];
        CallBackMethodName = context.Request.Params["callbackmethod"];

        switch (MethodName.ToLower())
        {
            case "getproducts":
                context.Response.Write(GetDetails());
                break;
            case "getbyid":
                context.Response.Write(GetById());
                break;
            case "insert":
                context.Response.Write(Insert(context));
                break;
            case "update":
                context.Response.Write(Update(context));
                break;
            case "updateasis":
                context.Response.Write(UpdateAsIs(context));
                break;
            case "updatename":
                context.Response.Write(UpdateName(context));
                break;
            case "updatequality":
                context.Response.Write(UpdateQuality(context));
                break;
            case "updateunit":
                context.Response.Write(UpdateUnit(context));
                break;
            case "delete":
                context.Response.Write(Delete());
                break;

            case "getuserid":
                context.Response.Write(GetId());
                break;
            case "getbyidblock":
                context.Response.Write(GetByIdBlock(context));
                break;
            case "updatepessimistic":
                context.Response.Write(UpdatePessimistic(context));
                break;
        }
    }

    public string GetId()
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            var id = _DbProducts.GetId();
            _response.IsSucess = true;
            _response.Message = string.Empty;
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = id;
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    public string GetDetails()
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                       new JavaScriptSerializer();
        try
        {
            List<Product> products = _DbProducts.GetProductDetails();
            _response.IsSucess = true;
            _response.Message = string.Empty;
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = products;
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }

    public string GetById()
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _Products = _DbProducts.GetProductById(Convert.ToInt32(Parameter));
            _response.IsSucess = true;
            _response.Message = string.Empty;
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _Products;

        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);

    }
    public string GetByIdBlock(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            var guid = context.Request.Params["guid"];
            var productID = Convert.ToInt32(context.Request.Params["ProductID"]);
            
            var product = _DbProducts.GetProductById(productID);
            if (product.LockUser == String.Empty)
            {
                int productId = _DbProducts.GetProductByIdBlock(productID, guid);
                _response.IsSucess = true;
                _response.Message = string.Empty;
                _response.CallBack = CallBackMethodName;
                _response.ResponseData = productId;
            }
            else
            {
                _response.IsSucess = false;
                _response.Message = String.Format("BLOCKED BY {0} {1}" , product.LockUser, product.LockTime) ;
                _response.CallBack = CallBackMethodName;
                _response.ResponseData = productID;

            }
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);

    }

    public string Insert(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"];
            _P.Unit = context.Request.Params["unit"];
            _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            _response.IsSucess = true;
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.InsertProduct(_P);
            _response.Message = "SucessFully Saved";
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }

    public string Update(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"];
            _P.Unit = context.Request.Params["unit"];
            _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);
            _P.TimeStamp = Helpers.GetBytes(context.Request.Params["ver"]);

            _response.IsSucess = true;
            _response.Message = "SucessFully Updated";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.UpdateProduct(_P);
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    
    public string UpdateAsIs(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"];
            _P.Unit = context.Request.Params["unit"];
            _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            _response.IsSucess = true;
            _response.Message = "SucessFully Updated";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.UpdateProductAsIs(_P);
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    public string UpdatePessimistic(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"];
            _P.Unit = context.Request.Params["unit"];
            _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            _response.IsSucess = true;
            _response.Message = "SucessFully Updated";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.UpdateProductPessimistic(_P);
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    
    public string UpdateName(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"];
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            _response.IsSucess = true;
            _response.Message = "SucessFully Updated";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.UpdateName(_P);
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    
    public string UpdateQuality(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["Qty"];
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            _response.IsSucess = true;
            _response.Message = "SucessFully Updated";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.UpdateName(_P);
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    
    public string UpdateUnit(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["unit"];
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            _response.IsSucess = true;
            _response.Message = "SucessFully Updated";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.UpdateName(_P);
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }
    
    public string Delete()
    {
        JsonResponse _response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            _response.IsSucess = true;
            _response.Message = "Record Sucessfully Deleted";
            _response.CallBack = CallBackMethodName;
            _response.ResponseData = _DbProducts.DeleteProduct(Convert.ToInt32(Parameter));
        }
        catch (Exception ex)
        {
            _response.Message = ex.Message;
            _response.IsSucess = false;
        }
        return jSearializer.Serialize(_response);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}

