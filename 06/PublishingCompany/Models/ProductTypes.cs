using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PublishingCompany.Models
{
    public partial class ProductTypes
    {
        public ProductTypes()
        {
            this.Products = new HashSet<Products>();
        }

        public int id { get; set; }
        public string type { get; set; }
        public int pricePerPiece { get; set; }

        public virtual ICollection<Products> Products { get; set; }
    }
}
