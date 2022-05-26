using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PublishingCompany.Models
{
    public partial class Orders
    {
        public int id { get; set; }
        public System.DateTime orderDate { get; set; }
        public System.DateTime publishingDate { get; set; }
        public int copies { get; set; }
        public int productId { get; set; }
        public int redactorId { get; set; }
        public int clientId { get; set; }

        public virtual Clients Clients { get; set; }
        public virtual Products Products { get; set; }
        public virtual Redactors Redactors { get; set; }

        public override string ToString()
        {
            return string.Format("id: {0},  orderDate: {1},  publishingDate: {2},  copies: {3},  productId: {4},  redactorId: {5},  clientId: {6}", id, orderDate, publishingDate, copies, productId, redactorId, clientId);
        }
    }
}
