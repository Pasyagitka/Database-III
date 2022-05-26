using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, MaxByteSize = 4000)]
public struct AddressType: INullable, IBinarySerialize
{
    public string Country;
    public string City;
    public string Street;
    public string House;

    public override string ToString()
    {
        return $"{Country}, г.{City}, ул.{Street}, дом {House}";
    }
    
    public bool IsNull
    {
        get
        {
            return _null;
        }
    }
    
    public static AddressType Null
    {
        get
        {
            AddressType h = new AddressType();
            h._null = true;
            return h;
        }
    }
    
    public static AddressType Parse(SqlString s)
    {
        if (s.IsNull)   return Null;
        AddressType u = new AddressType();
        string[] socurce = s.Value.Split(',');
        u.Country = Convert.ToString(socurce[0]);
        u.City = Convert.ToString(socurce[1]);
        u.Street = Convert.ToString(socurce[2]);
        u.House = Convert.ToString(socurce[3]);
        return u;
    }
    
    // Это метод-заполнитель
    public string Method1()
    {
        // Введите здесь код
        return string.Empty;
    }
    
    // Это статический метод заполнителя
    public static SqlString Method2()
    {
        // Введите здесь код
        return new SqlString("");
    }

    public void Read(BinaryReader r)
    {
        this.Country = r.ReadString();
    }

    public void Write(BinaryWriter w)
    {
        w.Write($"{Country},{City},{Street},{House}");
    }

    // Это поле элемента-заполнителя
    public int _var1;
 
    // Закрытый член
    private bool _null;
}