using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Products
/// </summary>
/// 
public class DbProducts
{
    readonly SqlConnection _con = new SqlConnection(ConfigurationManager.ConnectionStrings[1].ConnectionString);

    public List<Product> GetProductDetails()
    {
        try
        {
            List<Product> lstProducts = new List<Product>();
            Product product = null;
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Select * From Products";
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {

                product = new Product();
                product.ProductID = Convert.ToInt32(reader["ProductID"]);
                product.Name = reader["Name"].ToString();
                product.Unit = reader["Unit"].ToString();
                product.Qty = Convert.ToDecimal(reader["Qty"]);
                if (reader["LockUser"] != null)
                product.LockUser = reader["LockUser"].ToString();
                if( reader["LockTime"].ToString()!=String.Empty)
                product.LockTime = DateTime.Parse(reader["LockTime"].ToString());

                lstProducts.Add(product);

            }
            return lstProducts;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public string InsertProduct(Product p)
    {
        try
        {

            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Insert Into Products(Name,Unit,Qty)Values(@Name,@Unit,@Qty)";
            cmd.Parameters.Add(new SqlParameter("@Name", p.Name));
            cmd.Parameters.Add(new SqlParameter("@Qty", p.Qty));
            cmd.Parameters.Add(new SqlParameter("@Unit", p.Unit));

            if (cmd.ExecuteNonQuery() > 0)
                return "Record Sucessfully Saved";
            else
                return "Record not Afftected to DataBase";
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public bool UpdateProduct(Product p)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();

            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Update Products set Name=@Name,Unit=@Unit,Qty=@Qty Where ProductID=@ProductID and TimeStamp = @TimeStamp";
            cmd.Parameters.Add(new SqlParameter("@Name", p.Name));
            cmd.Parameters.Add(new SqlParameter("@Qty", p.Qty));
            cmd.Parameters.Add(new SqlParameter("@Unit", p.Unit));
            cmd.Parameters.Add(new SqlParameter("@ProductID", p.ProductID));
            cmd.Parameters.Add(new SqlParameter("@TimeStamp", p.TimeStamp));

            if (cmd.ExecuteNonQuery() > 0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public bool UpdateProductAsIs(Product p)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();

            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Update Products set Name=@Name,Unit=@Unit,Qty=@Qty Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@Name", p.Name));
            cmd.Parameters.Add(new SqlParameter("@Qty", p.Qty));
            cmd.Parameters.Add(new SqlParameter("@Unit", p.Unit));
            cmd.Parameters.Add(new SqlParameter("@ProductID", p.ProductID));

            if (cmd.ExecuteNonQuery() > 0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }
    public bool UpdateProductPessimistic(Product p)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();

            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Update Products set Name=@Name,Unit=@Unit,Qty=@Qty,LockUser=@LockUser,LockTime=@LockTime Where ProductID=@ProductID";
            _cmd.Parameters.Add(new SqlParameter("@Name", p.Name));
            _cmd.Parameters.Add(new SqlParameter("@Qty", p.Qty));
            _cmd.Parameters.Add(new SqlParameter("@Unit", p.Unit));
            _cmd.Parameters.Add(new SqlParameter("@ProductID", p.ProductID));
            _cmd.Parameters.Add(new SqlParameter("@LockUser", null));
            _cmd.Parameters.Add(new SqlParameter("@LockTime", null));

            if (_cmd.ExecuteNonQuery() > 0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public bool UpdateName(Product p)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Update Products set Name=@Name Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@Name", p.Name));
            cmd.Parameters.Add(new SqlParameter("@ProductID", p.ProductID));

            if (cmd.ExecuteNonQuery() > 0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public bool UpdateQuality(Product p)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Update Products set Qty=@Qty Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@Qty", p.Qty));
            cmd.Parameters.Add(new SqlParameter("@ProductID", p.ProductID));

            if (cmd.ExecuteNonQuery() > 0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public bool UpdateUnit(Product p)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Update Products set Unit=@Unit Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@Unit", p.Unit));
            cmd.Parameters.Add(new SqlParameter("@ProductID", p.ProductID));

            if (cmd.ExecuteNonQuery() > 0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public string DeleteProduct(int productId)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Delete From Products Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@ProductID", productId));
            if (cmd.ExecuteNonQuery() > 0)
                return "Records Sucessfully Delete";
            else
                return "Records not Afftected to DataBase";
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }
    public string GetId()
    {
        return Guid.NewGuid().ToString();
    }

    public Product GetProductById(int productId)
    {
        try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Select * From Products Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@ProductID", productId));
            SqlDataReader _Reader = cmd.ExecuteReader();
            Product product = null;
            while (_Reader.Read())
            {
                product = new Product();
                product.ProductID = Convert.ToInt32(_Reader["ProductID"]);
                product.Name = _Reader["Name"].ToString();
                product.Qty = Convert.ToDecimal(_Reader["Qty"]);
                product.Unit = _Reader["Unit"].ToString();
                product.TimeStampAsString = Helpers.GetString((byte[])(_Reader["TimeStamp"]));
                product.TimeStamp = (byte[])(_Reader["TimeStamp"]);


                if (_Reader["LockUser"] != null)
                    product.LockUser = _Reader["LockUser"].ToString();
                if (_Reader["LockTime"].ToString() != String.Empty)
                    product.LockTime = DateTime.Parse(_Reader["LockTime"].ToString());
            }
            return product;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

    public int GetProductByIdBlock(int productId, string guid)
    {
       try
        {
            if (_con.State != ConnectionState.Open)
                _con.Open();
            SqlCommand cmd = _con.CreateCommand();
            cmd.CommandText = "Update Products set LockUser=@LockUser,LockTime=@LockTime Where ProductID=@ProductID";
            cmd.Parameters.Add(new SqlParameter("@ProductID", productId));
            cmd.Parameters.Add(new SqlParameter("@LockUser", guid));
            cmd.Parameters.Add(new SqlParameter("@LockTime", DateTime.Now));

            cmd.ExecuteNonQuery();
            
           return productId;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != ConnectionState.Closed)
                _con.Close();
        }
    }

}

public class Product
{
    private int _ProductID;

    public int ProductID
    {
        get { return _ProductID; }
        set { _ProductID = value; }
    }

    private string _Name = string.Empty;

    public string Name
    {
        get { return _Name; }
        set { _Name = value; }
    }

    private string _Unit = string.Empty;

    public string Unit
    {
        get { return _Unit; }
        set { _Unit = value; }
    }

    private decimal _Qty;

    public decimal Qty
    {
        get { return _Qty; }
        set { _Qty = value; }
    }

    public DateTime LockTime { get; set; }
    public string LockUser { get; set; }
    public Byte[] TimeStamp { get; set; }
    public string TimeStampAsString { get; set; }
}

public static class Helpers
{
    public static byte[] GetBytes(string str)
    {
        byte[] bytes = new byte[str.Length * sizeof(char)];
        Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
        return bytes;
    }

    public static string GetString(byte[] bytes)
    {
        char[] chars = new char[bytes.Length / sizeof(char)];
        Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
        return new string(chars);
    }
}
