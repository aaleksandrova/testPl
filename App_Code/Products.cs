using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Diagnostics.Eventing.Reader;

/// <summary>
/// Summary description for Products
/// </summary>
/// 
public class DbProducts
{
    SqlConnection _con = new SqlConnection(ConfigurationManager.ConnectionStrings[1].ConnectionString);

    public List<Product> GetProductDetails()
    {
        try
        {
            List<Product> _lstProducts = new List<Product>();
            Product _Product = null;
            if (_con.State != System.Data.ConnectionState.Open)
                _con.Open();
            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Select * From Products";
            SqlDataReader _Reader = _cmd.ExecuteReader();

            while (_Reader.Read())
            {

                _Product = new Product();
                _Product.ProductID = Convert.ToInt32(_Reader["ProductID"]);
                _Product.Name = _Reader["Name"].ToString();
                _Product.Unit = _Reader["Unit"].ToString();
                _Product.Qty = Convert.ToDecimal(_Reader["Qty"]);
                _lstProducts.Add(_Product);

            }
            return _lstProducts;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != System.Data.ConnectionState.Closed)
                _con.Close();
        }
    }

    public string InsertProduct(Product _P)
    {
        try
        {

            if (_con.State != System.Data.ConnectionState.Open)
                _con.Open();
            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Insert Into Products(Name,Unit,Qty)Values(@Name,@Unit,@Qty)";
            _cmd.Parameters.Add(new SqlParameter("@Name", _P.Name));
            _cmd.Parameters.Add(new SqlParameter("@Qty", _P.Qty));
            _cmd.Parameters.Add(new SqlParameter("@Unit", _P.Unit));

            if (_cmd.ExecuteNonQuery() > 0)
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
            if (_con.State != System.Data.ConnectionState.Closed)
                _con.Close();
        }
    }

    public bool UpdateProduct(Product _P)
    {
        try
        {
            var p = GetProductById(_P.ProductID);
            var c1 = p.TimeStamp.Equals(_P.TimeStamp);
            if (_con.State != System.Data.ConnectionState.Open)
                _con.Open();

           
            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Update Products set Name=@Name,Unit=@Unit,Qty=@Qty Where ProductID=@ProductID and TimeStamp = @TimeStamp";
                _cmd.Parameters.Add(new SqlParameter("@Name", _P.Name));
                _cmd.Parameters.Add(new SqlParameter("@Qty", _P.Qty));
                _cmd.Parameters.Add(new SqlParameter("@Unit", _P.Unit));
                _cmd.Parameters.Add(new SqlParameter("@ProductID", _P.ProductID));
                _cmd.Parameters.Add(new SqlParameter("@TimeStamp", _P.TimeStamp));
           
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
            if (_con.State != System.Data.ConnectionState.Closed)
                _con.Close();
        }
    }


    public bool UpdateProductAsIs(Product _P)
    {
        try
        {
            var p = GetProductById(_P.ProductID);
            var c1 = p.TimeStamp == _P.TimeStamp;
            if (_con.State != System.Data.ConnectionState.Open)
                _con.Open();


            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Update Products set Name=@Name,Unit=@Unit,Qty=@Qty Where ProductID=@ProductID";
            _cmd.Parameters.Add(new SqlParameter("@Name", _P.Name));
            _cmd.Parameters.Add(new SqlParameter("@Qty", _P.Qty));
            _cmd.Parameters.Add(new SqlParameter("@Unit", _P.Unit));
            _cmd.Parameters.Add(new SqlParameter("@ProductID", _P.ProductID));
            _cmd.Parameters.Add(new SqlParameter("@TimeStamp", _P.TimeStamp));

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
            if (_con.State != System.Data.ConnectionState.Closed)
                _con.Close();
        }
    }
    //public string UpdateProductOptimisticCuncurrency(Product _P)
    //{


    //    try
    //    {



    //        SqlDataAdapter adapter = new SqlDataAdapter(
    //"SELECT ProductID, Name FROM Products ORDER BY ProductID", _con);

    //        adapter.UpdateCommand = new SqlCommand("UPDATE Products " +
    //          "(ProductID, Name) VALUES(@ProductID, @Name) " +
    //          "WHERE ProductID = @oldProductID AND Name = " +
    //          "@oldName", _con);
    //        adapter.UpdateCommand.Parameters.Add(
    //          "@ProductID", SqlDbType.Int, 5, "ProductID");
    //        adapter.UpdateCommand.Parameters.Add(
    //          "@Name", SqlDbType.NVarChar, 30, "Name");


    //        SqlParameter parameter = adapter.UpdateCommand.Parameters.Add("@oldProductID", SqlDbType.Int, 5, "ProductID");
    //        parameter.SourceVersion = DataRowVersion.Original;
    //        parameter = adapter.UpdateCommand.Parameters.Add(
    //          "@oldName", SqlDbType.NVarChar, 30, "Name");
    //        parameter.SourceVersion = DataRowVersion.Original;

    //        adapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdated);

    //        DataSet dataSet = new DataSet();
    //        adapter.Fill(dataSet, "Products");

    //         Modify the DataSet contents.

    //        adapter.Update(dataSet, "Products");

    //        foreach (DataRow dataRow in dataSet.Tables["Products"].Rows)
    //        {
    //            if (dataRow.HasErrors)
    //                Console.WriteLine(dataRow[0] + "\n" + dataRow.RowError);
    //        }
    //        if (adapter.UpdateBatchSize > 0)
    //            return "Record Sucessfully Updated";
    //        else
    //            return "Record not Afftected to DataBase";
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    finally
    //    {
    //        if (_con.State != System.Data.ConnectionState.Closed)
    //            _con.Close();
    //    }
    //}

    //protected static void OnRowUpdated(object sender, SqlRowUpdatedEventArgs args)
    //{
    //    if (args.RecordsAffected == 0)
    //    {
    //        args.Row.RowError = "Optimistic Concurrency Violation Encountered";
    //        args.Status = UpdateStatus.SkipCurrentRow;
    //    }
    //}
    public string DeleteProduct(int ProductID)
    {
        try
        {

            if (_con.State != System.Data.ConnectionState.Open)
                _con.Open();
            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Delete From Products Where ProductID=@ProductID";
            _cmd.Parameters.Add(new SqlParameter("@ProductID", ProductID));
            if (_cmd.ExecuteNonQuery() > 0)
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
            if (_con.State != System.Data.ConnectionState.Closed)
                _con.Close();
        }
    }

    public Product GetProductById(int ProductID)
    {
        try
        {

            if (_con.State != System.Data.ConnectionState.Open)
                _con.Open();
            SqlCommand _cmd = _con.CreateCommand();
            _cmd.CommandText = "Select * From Products Where ProductID=@ProductID";
            _cmd.Parameters.Add(new SqlParameter("@ProductID", ProductID));
            SqlDataReader _Reader = _cmd.ExecuteReader();
            Product _Product = null;
            while (_Reader.Read())
            {
                _Product = new Product();
                _Product.ProductID = Convert.ToInt32(_Reader["ProductID"]);
                _Product.Name = _Reader["Name"].ToString();
                _Product.Qty = Convert.ToDecimal(_Reader["Qty"]);
                _Product.Unit = _Reader["Unit"].ToString();

                //var c = _Reader["TimeStamp"];
                //var t = new DateTime(1970, 1, 1, 0, 0, 0, 0).AddSeconds(Convert.ToInt64(_Reader["TimeStamp"])/1000);

                _Product.TimeStamp =(byte[])(_Reader["TimeStamp"]);
            }
            return _Product;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (_con.State != System.Data.ConnectionState.Closed)
                _con.Close();
        }
    }
}

public class Product
{
    private int _ProductID = 0;

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

    private decimal _Qty = 0;

    public decimal Qty
    {
        get { return _Qty; }
        set { _Qty = value; }
    }


    public Byte[] RowVersion { get; set; }

    public Byte[] TimeStamp { get; set; }
}
