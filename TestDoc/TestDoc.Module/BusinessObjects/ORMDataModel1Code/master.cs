using System;
using DevExpress.Xpo;
using DevExpress.Xpo.Metadata;
using DevExpress.Data.Filtering;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
namespace TestDoc.Module.BusinessObjects.postgres
{

    public partial class master
    {
        public master(Session session) : base(session) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }

}
