using PublishingCompany.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.OracleClient;

namespace PublishingCompany
{
    class Program
    {
        static string _connectionString = ConfigurationManager.ConnectionStrings["PublishingCompanyEntities"].ConnectionString;

        public static void Loop()
        {
            string line;
            while ((line = Console.ReadLine()) != "q")
            {
                switch (line)
                {
                    case "1": {
                            Console.WriteLine("Add new client");
                            Clients newC = new Clients();
                            Console.WriteLine("Surname: "); newC.surname = Console.ReadLine();
                            Console.WriteLine("FirstName: "); newC.firstName = Console.ReadLine();
                            Console.WriteLine("Company: "); newC.company = Console.ReadLine();
                            Console.WriteLine("Email: "); newC.email = Console.ReadLine();
                            AddClient(newC);
                            break;
                        }
                    case "2":
                        {
                            Console.WriteLine("Update client");
                            Clients newC = new Clients();
                            Console.WriteLine("id: "); string clientUpdateId = Console.ReadLine();
                            Console.WriteLine("Surname: "); newC.surname = Console.ReadLine();
                            Console.WriteLine("FirstName: "); newC.firstName = Console.ReadLine();
                            Console.WriteLine("Company: "); newC.company = Console.ReadLine();
                            Console.WriteLine("Email: "); newC.email = Console.ReadLine();
                            UpdateClient(Int32.Parse(clientUpdateId), newC);
                            break;
                        }
                    case "3":
                        {
                            Console.WriteLine("Delete client");
                            Console.WriteLine("id: "); string clientUpdateId = Console.ReadLine();
                            DeleteClient(Int32.Parse(clientUpdateId));
                            break;

                        }
                    case "4":
                        {
                            Console.WriteLine("Add new product");
                            Products newC = new Products();
                            Console.WriteLine("name: "); newC.name = Console.ReadLine();
                            Console.WriteLine("year: "); newC.year = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine("productTypeId: "); newC.productTypeId = Int32.Parse(Console.ReadLine());
                            AddProduct(newC);
                            break;
                        }
                    case "5":
                        {
                            Console.WriteLine("Update product");
                            Products newC = new Products();
                            Console.WriteLine("id: "); string UpdateId = Console.ReadLine();
                            Console.WriteLine("name: "); newC.name = Console.ReadLine();
                            Console.WriteLine("year: "); newC.year = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine("productTypeId: "); newC.productTypeId = Int32.Parse(Console.ReadLine());
                            UpdateProduct(Int32.Parse(UpdateId), newC);
                            break;
                        }
                    case "6":
                        {
                            Console.WriteLine("Delete product");
                            Console.WriteLine("id: "); string id = Console.ReadLine();
                            DeleteClient(Int32.Parse(id));
                            break;

                        }
                    case "7":
                        {
                            Console.WriteLine("Add new order");
                            Orders newC = new Orders();
                            Console.WriteLine("orderDate: "); newC.orderDate = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine("publishingDate: "); newC.publishingDate = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine("copies: "); newC.copies = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("productId: "); newC.productId = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("redactorId: "); newC.redactorId = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("clientId: "); newC.clientId = Int32.Parse(Console.ReadLine());
                            AddOrder(newC);
                            break;
                        }
                    case "8":
                        {
                            Console.WriteLine("Update order");
                            Orders newC = new Orders();
                            Console.WriteLine("id: "); int UpdateId = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("orderDate: "); newC.orderDate = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine("publishingDate: "); newC.publishingDate = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine("copies: "); newC.copies = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("productId: "); newC.productId = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("redactorId: "); newC.redactorId = Int32.Parse(Console.ReadLine());
                            Console.WriteLine("clientId: "); newC.clientId = Int32.Parse(Console.ReadLine());
                            UpdateOrder(UpdateId, newC);
                            break;
                        }
                    case "9":
                        {
                            Console.WriteLine("Delete order");
                            Console.WriteLine("id: "); string id = Console.ReadLine();
                            DeleteOrder(Int32.Parse(id));
                            break;

                        }
                    case "10":
                        {
                            Console.WriteLine("Add new product type");
                            ProductTypes newC = new ProductTypes();
                            Console.WriteLine("type: "); newC.type = Console.ReadLine();
                            Console.WriteLine("pricePerPiece: "); newC.pricePerPiece = Int32.Parse(Console.ReadLine());
                            AddProductType(newC);
                            break;
                        }
                    case "11":
                        {
                            Console.WriteLine("Update product type");
                            Console.WriteLine("id: "); int UpdateId = Int32.Parse(Console.ReadLine());
                            ProductTypes newC = new ProductTypes();
                            Console.WriteLine("type: "); newC.type = Console.ReadLine();
                            Console.WriteLine("pricePerPiece: "); newC.pricePerPiece = Int32.Parse(Console.ReadLine());
                            UpdateProductType(UpdateId, newC);
                            break;
                        }
                    case "12":
                        {
                            Console.WriteLine("Delete product type");
                            Console.WriteLine("id: "); string id = Console.ReadLine();
                            DeleteProductType(Int32.Parse(id));
                            break;

                        }
                    case "13":
                        {
                            Console.WriteLine("Add new redactor");
                            Redactors newC = new Redactors();
                            Console.WriteLine("Surname: "); newC.surname = Console.ReadLine();
                            Console.WriteLine("FirstName: "); newC.firstName = Console.ReadLine();
                            AddRedactor(newC);
                            break;
                        }
                    case "14":
                        {
                            Console.WriteLine("Update redactor");
                            Console.WriteLine("id: "); int UpdateId = Int32.Parse(Console.ReadLine());
                            Redactors newC = new Redactors();
                            Console.WriteLine("Surname: "); newC.surname = Console.ReadLine();
                            Console.WriteLine("FirstName: "); newC.firstName = Console.ReadLine();
                            UpdateRedactor(UpdateId, newC);
                            break;
                        }
                    case "15":
                        {
                            Console.WriteLine("Delete redactor");
                            Console.WriteLine("id: "); string id = Console.ReadLine();
                            DeleteRedactor(Int32.Parse(id));
                            break;

                        }
                    default: break;
                }
            }
        }

        public static void AddClient(Clients client)
        {
            //Clients client = new Clients { surname = "Fenik", firstName = "Melissa", company = "NEW", email = "fwfpo@gmail.com" };
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("AddClient", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("surname_", client.surname);
                    cmd.Parameters.AddWithValue("firstName_", client.firstName);
                    cmd.Parameters.AddWithValue("company_", client.company);
                    cmd.Parameters.AddWithValue("email_", client.email);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }
        public static void UpdateClient(int clientUpdateId, Clients client)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("UpdateClient", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", clientUpdateId);
                    cmd.Parameters.AddWithValue("@surname", client.surname);
                    cmd.Parameters.AddWithValue("@firstName", client.firstName);
                    cmd.Parameters.AddWithValue("@company", client.company);
                    cmd.Parameters.AddWithValue("@email", client.email);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }

        }
        public static void DeleteClient(int clientDeleteId)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("DeleteClient", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@clientId", clientDeleteId);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }


        public static void AddProduct(Products product)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("AddProduct", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@name", product.name);
                    cmd.Parameters.AddWithValue("@year", product.year);
                    cmd.Parameters.AddWithValue("@productTypeId", product.productTypeId);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read()) { }
                        ;
                    }
                }
                conn.Close();
            }

        }
        public static void UpdateProduct(int UpdateId, Products products)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("UpdateProduct", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", UpdateId);
                    cmd.Parameters.AddWithValue("@name", products.name);
                    cmd.Parameters.AddWithValue("@year", products.year);
                    cmd.Parameters.AddWithValue("@productTypeId", products.productTypeId);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read()) { }
                        ;
                    }
                }
                conn.Close();
            }

        }
        public static void DeleteProduct(int id)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("DeleteProduct", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@productId", id);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }


        public static void AddOrder(Orders order)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("AddOrder", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("orderDate_", order.orderDate);
                    cmd.Parameters.AddWithValue("publishingDate_", order.publishingDate);
                    cmd.Parameters.AddWithValue("copies_", order.copies);
                    cmd.Parameters.AddWithValue("productId_", order.productId);
                    cmd.Parameters.AddWithValue("redactorId_", order.redactorId);
                    cmd.Parameters.AddWithValue("clientId_", order.clientId);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read()) { }
                        ;
                    }
                }
                conn.Close();
            }
        }
        public static void UpdateOrder(int UpdateId, Orders order)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("UpdateOrder", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", UpdateId);
                    cmd.Parameters.AddWithValue("@orderDate", order.orderDate);
                    cmd.Parameters.AddWithValue("@publishingDate", order.publishingDate);
                    cmd.Parameters.AddWithValue("@copies", order.copies);
                    cmd.Parameters.AddWithValue("@productId", order.productId);
                    cmd.Parameters.AddWithValue("@redactorId", order.redactorId);
                    cmd.Parameters.AddWithValue("@clientId", order.clientId);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read()) { }
                        ;
                    }
                }

                conn.Close();
            }
        }
        public static void DeleteOrder(int id)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("DeleteOrder", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@orderId", id);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }


        public static void AddProductType(ProductTypes productTypes)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("AddProductType", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@type", productTypes.type);
                    cmd.Parameters.AddWithValue("@pricePerPiece", productTypes.pricePerPiece);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read()) { }
                        ;
                    }
                }
                conn.Close();
            }
        }
        public static void UpdateProductType(int UpdateId, ProductTypes productTypes)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("UpdateProductType", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", UpdateId);
                    cmd.Parameters.AddWithValue("@type", productTypes.type);
                    cmd.Parameters.AddWithValue("@pricePerPiece", productTypes.pricePerPiece);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read()) { }
                        ;
                    }
                }
                conn.Close();
            }
        }
        public static void DeleteProductType(int id)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("DeleteProductType", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }

        public static void AddRedactor(Redactors redactor)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("AddRedactor", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@surname", redactor.surname);
                    cmd.Parameters.AddWithValue("@firstName", redactor.firstName);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }
        public static void UpdateRedactor(int UpdateId, Redactors redactor)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("UpdateRedactor", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", UpdateId);
                    cmd.Parameters.AddWithValue("@surname", redactor.surname);
                    cmd.Parameters.AddWithValue("@firstName", redactor.firstName);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }
        public static void DeleteRedactor(int id)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand("DeleteRedactor", conn) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                        }
                        ;
                    }
                }
                conn.Close();
            }
        }




        static void Main(string[] args)
        {
            List<Orders> orders = new List<Orders>();

            var getAllOrders = "select * from Orders";
            var getAllProducts = "select * from Products";
           // var addProductQuery = "begin AddOrder('15-02-2002', '16-02-2020', 11, 1, 1, 1); end;";


            using (OracleConnection conn = new OracleConnection(_connectionString))
            {
                conn.Open();
                Console.WriteLine("Orders:");
                DbCommand command = new OracleCommand(getAllOrders, conn);
                using (var reader0 = command.ExecuteReader())
                {
                    while (reader0.Read())
                    {
                        Console.WriteLine(String.Format("{0} {1} {2} {3} {4} {5}", reader0[0], reader0[1], reader0[2], reader0[3], reader0[4],reader0[5]));
                    }
                    ;
                }


                Console.WriteLine("\nProducts:");
                DbCommand command2 = new OracleCommand(getAllProducts, conn);
                using (var reader2 = command2.ExecuteReader())
                {
                    while (reader2.Read())
                    {
                        Console.WriteLine(String.Format("{0} {1} {2}", reader2[0], reader2[1], reader2[2]));
                    }
                    ;
                }

                using (DbCommand cmd = new OracleCommand("GetOrderTotalPrice", conn) { CommandType = CommandType.StoredProcedure })
                {
                    OracleParameter startParam = new OracleParameter("orderId_", Oracle.ManagedDataAccess.Client.OracleDbType.Int32);
                    startParam.Value = 5;
                    cmd.Parameters.Add(startParam);

                    OracleParameter returnValue = new OracleParameter("result_", Oracle.ManagedDataAccess.Client.OracleDbType.Int32);
                    returnValue.Direction = ParameterDirection.ReturnValue;
                    cmd.Parameters.Add(returnValue);

                    var reader7 = cmd.ExecuteNonQuery();
                    Console.WriteLine("Function call result: " + reader7);
                }


                Console.WriteLine("\nAdd new order");
                Orders newC = new Orders();
                Console.WriteLine("orderDate: "); newC.orderDate = DateTime.Parse(Console.ReadLine());
                Console.WriteLine("publishingDate: "); newC.publishingDate = DateTime.Parse(Console.ReadLine());
                Console.WriteLine("copies: "); newC.copies = Int32.Parse(Console.ReadLine());
                Console.WriteLine("productId: "); newC.productId = Int32.Parse(Console.ReadLine());
                Console.WriteLine("redactorId: "); newC.redactorId = Int32.Parse(Console.ReadLine());
                Console.WriteLine("clientId: "); newC.clientId = Int32.Parse(Console.ReadLine());
                AddOrder(newC);

                Console.WriteLine("\nOrders:");
                DbCommand command6 = new OracleCommand(getAllOrders, conn);
                using (var reader0 = command6.ExecuteReader())
                {
                    while (reader0.Read())
                    {
                        Console.WriteLine(String.Format("{0} {1} {2} {3} {4} {5}", reader0[0], reader0[1], reader0[2], reader0[3], reader0[4], reader0[5]));
                    }
                    ;
                }
            }
            Console.ReadLine();
        }

    }
}
