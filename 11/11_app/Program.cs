using System;
using Microsoft.Data.Sqlite;

namespace _11_app
{
    class Program
    {
        static void Main(string[] args)
        {
            using (var connection = new SqliteConnection("Data Source=11.db"))
            {
                connection.Open();

                SqliteCommand command = new SqliteCommand();
                command.Connection = connection;
                command.CommandText = "INSERT INTO Comments (comment, odId) values  ('regegr', 10)";
                int number = command.ExecuteNonQuery();
                Console.WriteLine($"В таблицу Comments добавлено объектов: {number}");


                SqliteCommand command2 = new SqliteCommand("UPDATE Comments SET odId=2 WHERE id<5", connection);
                int number2 = command2.ExecuteNonQuery();
                Console.WriteLine($"Обновлено объектов: {number2}");


                SqliteCommand command3 = new SqliteCommand("DELETE  FROM Comments WHERE comment='regegr'", connection);
                int number3 = command3.ExecuteNonQuery();
                Console.WriteLine($"Удалено объектов: {number3}");


                using (var transaction = connection.BeginTransaction())
                {
                    var insertCmd = connection.CreateCommand();
                    int i = 5;
                    string sql = $"insert into Comments (comment, odId) values  ('----', {i})";

                    insertCmd.CommandText = sql;
                    insertCmd.ExecuteNonQuery();

                    i = 15;
                    insertCmd.ExecuteNonQuery();

                    i = 20;
                    insertCmd.ExecuteNonQuery();

                    transaction.Commit();
                }
            }
             Console.Read();
        }
    }
}
