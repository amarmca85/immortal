using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using System.Text;
using System.Net;
using System.Security.Cryptography;

public partial class etendering : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {



    }

    private void RedirectAndPOST(Page page, string TranUrl, NameValueCollection data)
    {
        try
        {

            //Prepare the Posting form
            string strForm = PreparePOSTForm(TranUrl, data);
            //Add a literal control the specified page holding the Post Form, this is to submit the Posting form with the request.
            page.Controls.Add(new LiteralControl(strForm));



        }
        catch

        { }
    }

    private static String PreparePOSTForm(string url, NameValueCollection data)
    {
        try
        {
            //Set a name for the form
            string formID = "PostForm";

            //Build the form using the specified data to be posted.
            StringBuilder strForm = new StringBuilder();
            strForm.Append("<form id=\"" + formID + "\" name=\"" + formID + "\" action=\"" + url + "\" method=\"POST\">");
            foreach (string key in data)
            {
                strForm.Append("<input type=\"hidden\" name=\"" + key + "\" value=\"" + data[key] + "\">");
            }
            strForm.Append("</form>");

            //Build the JavaScript which will do the Posting operation.
            StringBuilder strScript = new StringBuilder();
            strScript.Append("<script language='javascript'>");
            strScript.Append("var v" + formID + " = document." + formID + ";");
            strScript.Append("v" + formID + ".submit();");
            strScript.Append("</script>");

            //Return the form and the script concatenated. (The order is important, Form then JavaScript)
            return strForm.ToString() + strScript.ToString();

        }
        catch (Exception)
        {

            throw;
        }
    }
    public Boolean AcceptAllCertifications(Object sender, System.Security.Cryptography.X509Certificates.X509Certificate certification, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors)
    {
        return true;
    }

    protected void Redirect_Click(object sender, EventArgs e)
    {

        //1. URL
        string TranUrl = "https://uat-etendering.axisbank.co.in/easypay2.0/frontend/api/payment";

        //2. method to generate Checksum value. //CID + RID + CRN  + AMT + "axis";

        String strCID = string.Empty;
        String strRID = string.Empty;
        String strCRN = string.Empty;
        String strAMT = string.Empty;

        strCID = "2881";
        strRID = "213851358";
        strCRN = "213851358";
        strAMT = "345";

        string StrCheckSumString = strCID + strRID + strCRN + strAMT + "axis";

        string Checksum = sha256_hash(StrCheckSumString);
        string PlainText = "CID=" + strCID + "&RID=" + strRID + "&CRN=" + strCRN + "&AMT=" + strAMT + "&VER=1.0&TYP=TEST&CNY=INR&RTU=http://localhost:50864/Default.aspx/&PPI=A01/2554-trid|A01/2554|05/21/2016 12:39:14&RE1=MN&RE2=&RE3=&RE4=&RE5=&CKS=" + Checksum;

        string encryptedstring = Encrypt(PlainText, "axisbank12345678");
        //Correct Value with checksum.
        //string encryptedstring = "VNr13VWGrjwB8PQG1DhFxLbqcYbyLkPd8QBbvtVv2hmSamkVvVMGf594mWXHVbFc4JRmWmqUlk8YLHO7Oe84zDk2tbnKLnFWBNrG3cENgSb47yBP1lclKjWOneOtU61T35EjX7lOQJzrWmnly9KZWQq78lGlKavaxkdmXpD3gL8g9iM/YTtl51B8IB4iU4I4zb7jKvSFBdMBZYjFqBDaMBwz8VDepxyBHH4NpemfOn1vyTVMHp7Y3V/ar0Lue8XLvOtx1CsYulC/zqCOQuqMaNo63fz5SsCstrQpGfxXIJkc6oenjsIARginBJjxxu5LfoEfV3odAM405n2J7XMAOw==";

        NameValueCollection data = new NameValueCollection();
        data.Add("i", encryptedstring);
        RedirectAndPOST(this.Page, TranUrl, data);

    }

    public static String sha256_hash(String value)
    {
        StringBuilder Sb = new StringBuilder();
        using (SHA256 hash = SHA256Managed.Create())
        {
            Encoding enc = Encoding.UTF8;
            Byte[] result = hash.ComputeHash(enc.GetBytes(value));
            foreach (Byte b in result)
                Sb.Append(b.ToString("x2"));
        }
        return Sb.ToString();
    }

    public string Encrypt(string input, string key)
    {
        byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
        byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(input);
        Aes kgen = Aes.Create("AES");
        kgen.Mode = CipherMode.ECB;
        //kgen.Padding = PaddingMode.None;
        kgen.Key = keyArray;
        ICryptoTransform cTransform = kgen.CreateEncryptor();
        byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
        return Convert.ToBase64String(resultArray, 0, resultArray.Length);
    }

}