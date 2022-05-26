using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PublishingCompany.Models
{
    public partial class Redactors
    {
        public Redactors()
        {
            this.Orders = new HashSet<Orders>();
        }

        public int id { get; set; }
        public string surname { get; set; }
        public string firstName { get; set; }

        public virtual ICollection<Orders> Orders { get; set; }
    }
}
