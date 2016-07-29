<%@ WebHandler Language="C#" Class="ProductList" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;

public class ProductList : IHttpHandler
{
    string _methodName = string.Empty;
    string _callBackMethodName = string.Empty;
    object _parameter = string.Empty;
    readonly DbProducts _DbProducts = new DbProducts();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/x-javascript";
        _methodName = context.Request.Params["method"];
        _parameter = context.Request.Params["param"];
        _callBackMethodName = context.Request.Params["callbackmethod"];

        switch (_methodName.ToLower())
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
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            var id = _DbProducts.GetId();
            response.IsSucess = true;
            response.Message = string.Empty;
            response.CallBack = _callBackMethodName;
            response.ResponseData = id;
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string GetDetails()
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                       new JavaScriptSerializer();
        try
        {
            List<Product> products = _DbProducts.GetProductDetails();
            response.IsSucess = true;
            response.Message = string.Empty;
            response.CallBack = _callBackMethodName;
            response.ResponseData = products;
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string GetById()
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product _Products = _DbProducts.GetProductById(Convert.ToInt32(_parameter));
            response.IsSucess = true;
            response.Message = string.Empty;
            response.CallBack = _callBackMethodName;
            response.ResponseData = _Products;

        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);

    }
    public string GetByIdBlock(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
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
                response.IsSucess = true;
                response.Message = string.Empty;
                response.CallBack = _callBackMethodName;
                response.ResponseData = productId;
            }
            else
            {
                response.IsSucess = false;
                response.Message = String.Format("BLOCKED BY {0} {1}", product.LockUser, product.LockTime);
                response.CallBack = _callBackMethodName;
                response.ResponseData = productID;
            }
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);

    }

    public string Insert(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["name"];
            p.Unit = context.Request.Params["unit"];
            p.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            response.IsSucess = true;
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.InsertProduct(p);
            response.Message = "SucessFully Saved";
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string Update(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["name"];
            p.Unit = context.Request.Params["unit"];
            p.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            p.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);
            p.TimeStamp = Helpers.GetBytes(context.Request.Params["ver"]);

            response.IsSucess = true;
            response.Message = "SucessFully Updated";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.UpdateProduct(p);
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string UpdateAsIs(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["name"];
            p.Unit = context.Request.Params["unit"];
            p.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            p.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            response.IsSucess = true;
            response.Message = "SucessFully Updated";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.UpdateProductAsIs(p);
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string UpdatePessimistic(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["name"];
            p.Unit = context.Request.Params["unit"];
            p.Qty = Convert.ToDecimal(context.Request.Params["Qty"]);
            p.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            response.IsSucess = true;
            response.Message = "SucessFully Updated";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.UpdateProductPessimistic(p);
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string UpdateName(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["name"];
            p.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            response.IsSucess = true;
            response.Message = "SucessFully Updated";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.UpdateName(p);
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string UpdateQuality(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["Qty"];
            p.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            response.IsSucess = true;
            response.Message = "SucessFully Updated";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.UpdateName(p);
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string UpdateUnit(HttpContext context)
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            Product p = new Product();
            p.Name = context.Request.Params["unit"];
            p.ProductID = Convert.ToInt32(context.Request.Params["ProductID"]);

            response.IsSucess = true;
            response.Message = "SucessFully Updated";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.UpdateName(p);
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public string Delete()
    {
        JsonResponse response = new JsonResponse();
        JavaScriptSerializer jSearializer =
                     new JavaScriptSerializer();
        try
        {
            response.IsSucess = true;
            response.Message = "Record Sucessfully Deleted";
            response.CallBack = _callBackMethodName;
            response.ResponseData = _DbProducts.DeleteProduct(Convert.ToInt32(_parameter));
        }
        catch (Exception ex)
        {
            response.Message = ex.Message;
            response.IsSucess = false;
        }
        return jSearializer.Serialize(response);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}

