using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void CLROrdersProc (DateTime  start_date, DateTime  end_date)
    {
        SqlCommand command = new SqlCommand();
        command.Connection = new SqlConnection("Context connection = true");
        command.Connection.Open();
        command.CommandText = @"select *, dbo.GetOrderTotalPrice(Orders.id)[TotalPrice] from Orders where Orders.orderDate between @start_date and @end_date";
        command.Parameters.AddWithValue("@start_date", start_date);
        command.Parameters.AddWithValue("@end_date", end_date);

        SqlContext.Pipe.ExecuteAndSend(command);
        command.Connection.Close();
    }
}
