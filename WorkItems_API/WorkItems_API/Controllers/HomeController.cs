using Microsoft.AspNetCore.Mvc;
using WorkItems_API.Business;


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

        [HttpPost("assign")]
        public IActionResult AssignWorkItems()
        {
            object result = "[]";

            result = HomeBusiness.AssignWorkItems().ToString();

            return Ok(result);
        }
    }
}
