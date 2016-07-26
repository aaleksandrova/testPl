<%@ WebHandler Language="C#" Class="ProductList" %>

using System;
using System.Text;
using System.Web;

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
            case "delete":
                context.Response.Write(Delete());
                break;
        }
    }

    public string GetDetails()
    {
        JsonResponse _response = new JsonResponse();
        System.Web.Script.Serialization.JavaScriptSerializer jSearializer =
                       new System.Web.Script.Serialization.JavaScriptSerializer();
        try
        {
            System.Collections.Generic.List<Product> _Products = _DbProducts.GetProductDetails();
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

    public string GetById()
    {
        JsonResponse _response = new JsonResponse();
        System.Web.Script.Serialization.JavaScriptSerializer jSearializer =
                     new System.Web.Script.Serialization.JavaScriptSerializer();
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

    public string Insert(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        System.Web.Script.Serialization.JavaScriptSerializer jSearializer =
                     new System.Web.Script.Serialization.JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"].ToString();
            _P.Unit = context.Request.Params["unit"].ToString();
            _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"].ToString());
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

    //public string UpdateOpt(HttpContext context)
    //{
    //    JsonResponse _response = new JsonResponse();
    //    System.Web.Script.Serialization.JavaScriptSerializer jSearializer =
    //        new System.Web.Script.Serialization.JavaScriptSerializer();
    //    try
    //    {
    //        Product _P = new Product();
    //        _P.Name = context.Request.Params["name"].ToString();
    //        _P.Unit = context.Request.Params["unit"].ToString();
    //        _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"].ToString());
    //        _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"].ToString());
    //        _response.IsSucess = true;
    //        _response.Message = "SucessFully Updated";
    //        _response.CallBack = CallBackMethodName;
    //        _response.ResponseData = _DbProducts.UpdateProductOptimisticCuncurrency(_P);
    //    }
    //    catch (Exception ex)
    //    {
    //        _response.Message = ex.Message;
    //        _response.IsSucess = false;
    //    }
    //    return jSearializer.Serialize(_response);
    //}

    public string Update(HttpContext context)
    {
        JsonResponse _response = new JsonResponse();
        System.Web.Script.Serialization.JavaScriptSerializer jSearializer =
                     new System.Web.Script.Serialization.JavaScriptSerializer();
        try
        {
            Product _P = new Product();
            _P.Name = context.Request.Params["name"].ToString();
            _P.Unit = context.Request.Params["unit"].ToString();
            _P.Qty = Convert.ToDecimal(context.Request.Params["Qty"].ToString());
            _P.ProductID = Convert.ToInt32(context.Request.Params["ProductID"].ToString());
            _P.TimeStamp = Encoding.ASCII.GetBytes(context.Request.Params["ver"]);

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

    public string Delete()
    {
        JsonResponse _response = new JsonResponse();
        System.Web.Script.Serialization.JavaScriptSerializer jSearializer =
                     new System.Web.Script.Serialization.JavaScriptSerializer();
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

