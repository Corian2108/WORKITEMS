using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using UserItem_API.Business;
using UserItem_API.Entity;

namespace UserItem_API.Controllers
{
    public class HomeController : Controller
    {

        public IActionResult Index()
        {
            return View();
        }

        [HttpGet("user")]
        public IActionResult GetItmesByUser([FromQuery] string user)
        {
            object result = "[]";

            UserClass Username = new UserClass();
            Username.Username = user;

            result = UserItemBusiness.GetItmesByUser(Username).ToString();

            return Ok(result);
        }
    }
}
