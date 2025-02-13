using System.Text.Json;
using UserItem_API.Conection;
using UserItem_API.Entity;

namespace UserItem_API.Business
{
    public class UserItemBusiness
    {
        public static object GetItmesByUser(UserClass user)
        {

            object result = "[]";
            string jsonUser = JsonSerializer.Serialize(user);

            result = UserItemConection.GetItmesByUser(jsonUser).ToString();

            return result;
        }

    }
}
