using System.Data;
using Microsoft.Data.SqlClient;


namespace WorkItems_API.Conection
{
    public class HomeConection
    {

        private static readonly string _connectionString = Properties.Resources.ConnectionString;

        public static object AssignWorkItems()
        {

            using SqlConnection conn = new SqlConnection(_connectionString);
            using SqlCommand cmd = new SqlCommand("AssignWorkItems", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            conn.Open();
            cmd.ExecuteNonQuery();
            return ("Items asignados correctamente");
        }
    }
}
