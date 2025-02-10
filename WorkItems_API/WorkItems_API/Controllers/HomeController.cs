using Microsoft.AspNetCore.Mvc;
using System.Data;
using Microsoft.Data.SqlClient;


namespace WorkItems_API.Controllers
{

    [Route("api/workitems")]
    [ApiController]
    public class HomeController : Controller
    {

        private readonly string _connectionString = Properties.Resources.ConnectionString;
        
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public IActionResult GetAllWorkItems()
        {
            using SqlConnection conn = new SqlConnection(_connectionString);
            using SqlCommand cmd = new SqlCommand("SELECT * FROM WorkItems", conn);
            conn.Open();
            using SqlDataReader reader = cmd.ExecuteReader();
            var result = new List<object>();
            while (reader.Read())
            {
                result.Add(new
                {
                    Id = reader["Id"],
                    Title = reader["Title"],
                    AssignedUser = reader["AssignedUser"],
                    DueDate = reader["DueDate"],
                    Priority = reader["Priority"],
                    Status = reader["Status"]
                });
            }
            return Ok(result);
        }


        [HttpPost("assign")]
        public IActionResult AssignWorkItems()
        {
            using SqlConnection conn = new SqlConnection(_connectionString);
            using SqlCommand cmd = new SqlCommand("AssignWorkItems", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            conn.Open();
            cmd.ExecuteNonQuery();
            return Ok("Items asignados correctamente");
        }
    }
}
