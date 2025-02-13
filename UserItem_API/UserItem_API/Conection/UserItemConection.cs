using System.Data;
using Microsoft.Data.SqlClient;

namespace UserItem_API.Conection
{
    public class UserItemConection
    {
        private static readonly string _connectionString = Properties.Resources.ConnectionString;

        public static object GetItmesByUser(String user)
        {

            string result = string.Empty;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_get_items_by_user", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@USER", SqlDbType.NVarChar) { Value = user });

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            result = reader.GetString(0);
                        }
                    }
                }
            }

            return (result);
        }

    }
}
