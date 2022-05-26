using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PublishingCompany.Models
{

    public partial class Products
    {
        public Products()
        {
            this.Orders = new HashSet<Orders>();
        }

        public int id { get; set; }
        public string name { get; set; }
        public System.DateTime year { get; set; }
        public int productTypeId { get; set; }

        public virtual ICollection<Orders> Orders { get; set; }
        public virtual ProductTypes ProductTypes { get; set; }
    }
}
