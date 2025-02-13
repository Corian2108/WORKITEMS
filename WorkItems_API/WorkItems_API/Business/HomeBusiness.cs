using WorkItems_API.Conection;

namespace WorkItems_API.Business
{
    public class HomeBusiness
    {

        public static object AssignWorkItems()
        {
            object result = "[]";

            result = HomeConection.AssignWorkItems().ToString();

            return result;
        }

    }
}
