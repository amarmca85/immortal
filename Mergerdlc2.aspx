﻿<%--<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mergerdlc.aspx.cs" Inherits="Mergerdlc" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="Microsoft.Reporting.WebForms" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Printing" %>
<%@ Import Namespace="PSEBONLINE" %>
<%@ Import Namespace="PSEBONLINE.AbstractLayer" %>
<%@ Import Namespace="iTextSharp.text" %>
<%@ Import Namespace="iTextSharp.text.pdf" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<%--<meta http-equiv="refresh" content="50002" />--%>
<meta http-equiv="refresh" content="6000;URL='http://registration.pseb.ac.in/Mergerdlc.aspx'" />
    <title>Punjab School Education Board</title>
     <%--<link href="Assets/Styles/css/main.css" rel="stylesheet" type="text/css" />
    <link href="Assets/Styles/css/menu.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript" type="text/javascript" src="common.js"></script>
    <script language="javascript" type="text/javascript" src="punjabi.js"></script>
    <link rel="stylesheet" href="stylesheet.css" type="text/css" charset="utf-8" />--%>

   <script runat="server">
       string PType = "";
       string schlcode = "";
       string plot = "";
       string pclass = "";
       string pClassName = "";
       string reportType = "PDF";
       string mimeType;
       string encoding;
       string fileNameExtension = ".pdf";
       // static string addpath = @"D:\Report\";
       static string AppPath = ConfigurationManager.AppSettings["Upload"].ToString();//UploadPath
       static string addrptpath = "Report/";
       //The DeviceInfo settings should be changed based on the reportType
       //http://msdn2.microsoft.com/en-us/library/ms155397.aspx
       string deviceInfo =
        "<DeviceInfo>" +
            "  <OutputFormat>PDF</OutputFormat>" +
            "  <PageWidth>8.27in</PageWidth>" +
            "  <PageHeight>12.69in</PageHeight>" +
            "  <MarginTop>0.2in</MarginTop>" +
            "  <MarginLeft>0.2in</MarginLeft>" +
            "  <MarginRight>0.2in</MarginRight>" +
            "  <MarginBottom>0.2in</MarginBottom>" +
            "</DeviceInfo>";

       Warning[] warnings;
       string[] streams;
       byte[] renderedBytes;
       byte[] file1;
       byte[] file2;
       byte[] file3;
       byte[] file4;
       byte[] file5;
       byte[] file6;
       byte[] file7;
       byte[] file8;
       byte[] file9;
       byte[] file10;
       byte[] file11;
       byte[] file12;
       byte[] file13;
       byte[] file14;
       byte[] file15;
       byte[] file16;
       byte[] file17;
       byte[] file18;
       byte[] file19;
       byte[] file20;
       byte[] file21;
       byte[] file22;
       byte[] file23;
       byte[] file24;
       byte[] file25;
       string rptpath = "";
       string qry = "";
       string qry1 = "";
       PdfReader reader = null;
       SqlDataReader sqlrdr = null;
       string chkqry1 = "", chkqry2 = "";
       DataSet chkds1, chkds2;
       ReportDB objRDB = new ReportDB();

       protected void Page_Load(object sender, EventArgs e)
       {
           if (!IsPostBack)
           {
               {
                   DataSet objds = new DataSet();
                   //0013194, 0024742
                   string qryregdate = "select  distinct top 500  a.schl,printlotnew as lot,a.class,[Type],Challandt,case when a.class='2' then 'Matric' else 'Senior' end as ClassName from exammasterregular2017 a inner join SchoolMaster b "
                                       +" on a.schl=b.schl where  PrintStatus is null and  challanverify=1 and dist not in (010,020,030,045,050,100,110,120,160,165,175) order by schl asc";
                   //string qryregdate = "select distinct schl,printlotnew as lot,class,[Type] from exammasterregular2017 where PrintStatus is null and challanverify=1 and schl='0024742'";
                   // string qryregdate = "select distinct top 1 schl,printlotnew as lot,class,[Type] from exammasterregular2017 where PrintStatus is null and challanverify=1 and type='OPEN'";
                   //string qryregdate = "select distinct top 1 schl,printlotnew as lot,class,[Type] from exammasterregular2017 where PrintStatus is null and challanverify=1";
                   objds = objRDB.GetDataByQuery(qryregdate);
                   if (objds != null && objds.Tables.Count > 0)
                   {
                       if (objds.Tables[0].Rows.Count > 0)
                       {
                           for (int t = 0; t < objds.Tables[0].Rows.Count; t++)
                           {
                               string Filepath = "";
                               schlcode = objds.Tables[0].Rows[t]["schl"].ToString().Trim();
                               plot = objds.Tables[0].Rows[t]["lot"].ToString().Trim();
                               pclass = objds.Tables[0].Rows[t]["class"].ToString().Trim();
                               PType = objds.Tables[0].Rows[t]["Type"].ToString().Trim();
                               pClassName = objds.Tables[0].Rows[t]["ClassName"].ToString().Trim();

                               // Local 
                               // Filepath = "~/Upload/ExamPDF/" + schlcode + "_" + plot + "_" + pClassName + "_" + PType + ".pdf";
                               // string FilepathExist = Path.Combine(Server.MapPath("~/Upload/ExamPDF"));
                               // Server
                               Filepath = AppPath + "/ExamPDF/" + schlcode + "_" + plot + "_" + pClassName + "_" + PType + ".pdf";
                               string FilepathExist = AppPath + "/ExamPDF/";
                               string saveFilePath = "Upload/ExamPDF/" + schlcode + "_" + plot + "_" + pClassName + "_" + PType + ".pdf";
                               if (!Directory.Exists(FilepathExist))
                               {
                                   Directory.CreateDirectory(FilepathExist);
                               }
                               //Matric
                               if (pclass == "2" && PType == "REG")// Matric Reg
                               { BindReportMR(schlcode, plot, pclass, Filepath); }
                               else if (pclass == "2" && PType == "OPEN") // Matric OPEN
                               { BindReportMO(schlcode, plot, pclass, Filepath); }
                               //Senior
                               else if (pclass == "4" && PType == "REG") // Senior REG
                               { BindReport(schlcode, plot, pclass, Filepath); }
                               else if (pclass == "4" && PType == "OPEN") // Senior OPEN
                               { BindReportSO(schlcode, plot, pclass, Filepath); }


                               int OutResult = UpdateExamPDFStatus(schlcode, plot, pclass, PType, saveFilePath);
                               if (OutResult == 1)
                               {

                               }
                           }
                       }
                       //Response.Redirect("thanks.aspx?"+schlcode);
                   }

               }
           }
       }

       public int UpdateExamPDFStatus(string schlcode, string plot,string pclass,string PType,string Filepath)
       {
           int result;
           try
           {
               using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["myConn"].ToString()))
               {
                   SqlCommand cmd = new SqlCommand("UpdateExamPDFStatus", con);
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.Parameters.AddWithValue("@schlcode", schlcode);
                   cmd.Parameters.AddWithValue("@plot", plot);
                   cmd.Parameters.AddWithValue("@pclass", pclass);
                   cmd.Parameters.AddWithValue("@PType", PType);
                   cmd.Parameters.AddWithValue("@Filepath", Filepath);
                   cmd.Parameters.Add("@Outstatus", SqlDbType.Int).Direction = ParameterDirection.Output;
                   con.Open();
                   result = cmd.ExecuteNonQuery();
                   result = (int)cmd.Parameters["@Outstatus"].Value;
                   return result;
               }
           }
           catch (Exception ex)
           {
               return result = -1;
           }
       }


       // Senior Regular
       public void BindReport(string SCHL, string lot1, string pClass,string Filepath)
       {
           if (File.Exists(Server.MapPath(Filepath)))
           {
               File.Delete(Server.MapPath(Filepath));
           }
           int pageOffset = 0;
           ArrayList master = new ArrayList();
           int f = 0;
           Document document = null;
           PdfCopy writer = null;
           try
           {
               string SET1 = string.Empty;
               string SET2 = string.Empty;
               DataSet ds1 = new DataSet();
               SqlDataAdapter ad = new SqlDataAdapter();
               using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["myConn"].ToString()))
               {
                   SqlCommand cmd = new SqlCommand("ExamReportSPFinalSeniorMerge", con);//GetCalculateFeeBySchoolSPNew
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.Parameters.AddWithValue("@SCHL", SCHL);
                   cmd.Parameters.AddWithValue("@lot", lot1);
                   cmd.Parameters.AddWithValue("@Class", pClass);
                   ad.SelectCommand = cmd;
                   ad.Fill(ds1);
                   con.Open();
                   if (ds1.Tables[2].Rows.Count > 0)
                   {
                       // rptpath = "~/RPTReports/ SeniorExamReport.rdlc";
                       file1 = RenderReport(rptpath, ds1);
                       reader = new PdfReader(file1);
                       reader.ConsolidateNamedDestinations();
                       // we retrieve the total number of pages
                       int n = reader.NumberOfPages;
                       pageOffset += n;

                       if (f == 0)
                       {
                           // step 1: creation of a document-object
                           document = new Document(reader.GetPageSizeWithRotation(1));
                           // step 2: we create a writer that listens to the document
                           // writer = new PdfCopy(document, new FileStream(Server.MapPath("~/pdf/" + schlcode + ".pdf"), FileMode.Create));
                           //// writer = new PdfCopy(document, new FileStream(Server.MapPath(Filepath), FileMode.Create));
                           writer = new PdfCopy(document, new FileStream(Filepath, FileMode.Create));
                           // step 3: we open the document
                           document.Open();
                       }
                       // step 4: we add content
                       for (int i = 0; i < n;)
                       {
                           ++i;
                           if (writer != null)
                           {
                               PdfImportedPage page = writer.GetImportedPage(reader, i);
                               writer.AddPage(page);
                           }
                       }
                       PRAcroForm form = reader.AcroForm;
                       if (form != null && writer != null)
                       {
                           writer.CopyAcroForm(reader);
                       }
                       f++;

                   }
               }
           }
           catch (Exception ex)
           {

           }
           finally
           {
               if (document != null)
               {
                   document.Close();
                   document.Dispose();
               }


           }
       }

       void SubReportMatricSubject(object sender, SubreportProcessingEventArgs e)
       {
           string CanId = e.Parameters["CANDID"].Values[0].ToString();
           DataSet ds = GetSubjectById(CanId);
           ds.Tables[0].TableName = "MatricSubjectDataset";
           ReportDataSource datasource2 = new ReportDataSource("MatricSubjectDataset", ds.Tables[0]);
           e.DataSources.Add(datasource2);
       }
       private DataSet GetSubjectById(string Canid)
       {
           try
           {
               string qry = "SELECT * From tblSeniorSubjects where candid='" + Canid + "' order by SUB_SEQ asc";
               DataSet ds2 = objRDB.GetDataByQuery(qry);
               ds2.Tables[0].TableName = "MatricSubjectDataset";
               return ds2;
           }
           catch
           {
               return null;
           }
       }

       private byte[] RenderReport(string rptpath, DataSet ds2)
       {
           byte[] arr;
           ReportViewer1.Reset();
           //// ReportViewer1.LocalReport.ReportPath = rptpath;
           ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/RPTReports/SeniorExamReport.rdlc");
           LocalReport localReport = new LocalReport();
           // localReport.ReportPath = Server.MapPath(rptpath);
           localReport.ReportPath =  Server.MapPath("~/RPTReports/SeniorExamReport.rdlc");
           //SqlCommand scommand2 = new SqlCommand(qry);
           //DataSet ds2 = DataManager2.getDataSet(scommand2);
           ds2.Tables[0].TableName = "Regdata";
           ReportViewer1.Visible = true;
           //  ReportDataSource datasource2 = new ReportDataSource("Regdata", ds2.Tables[0]);
           ReportDataSource datasource = new ReportDataSource("ExamReportDataSet", ds2.Tables[0]);
           ReportDataSource datasource1 = new ReportDataSource("SubjectwiseCountOfStudent", ds2.Tables[1]);
           ReportDataSource datasource2 = new ReportDataSource("SubjectwiseCountMatricExam", ds2.Tables[2]);
           ReportDataSource datasource4 = new ReportDataSource("ChallanDetails", ds2.Tables[3]);
           ReportViewer1.LocalReport.EnableExternalImages = true;
           string imagePath = new Uri(Server.MapPath("~/Upload/")).AbsoluteUri;
           ReportParameter parameter = new ReportParameter("ImgPath", imagePath);
           ReportViewer1.LocalReport.SetParameters(parameter);
           ReportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SubReportMatricSubject);
           ReportViewer1.LocalReport.DataSources.Clear();
           ReportViewer1.LocalReport.DataSources.Add(datasource);
           ReportViewer1.LocalReport.DataSources.Add(datasource1);
           ReportViewer1.LocalReport.DataSources.Add(datasource2);
           ReportViewer1.LocalReport.DataSources.Add(datasource4);
           arr = ReportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
           ReportViewer1.LocalReport.Refresh();
           return arr;
           //    RenderReport(Request.QueryString["Schlid"].ToString());

       }



       // Senior OPEN
       public void BindReportSO(string SCHL, string lot1, string pClass,string Filepath)
       {
           if (File.Exists(Server.MapPath(Filepath)))
           {
               File.Delete(Server.MapPath(Filepath));
           }
           int pageOffset = 0;
           ArrayList master = new ArrayList();
           int f = 0;
           Document document = null;
           PdfCopy writer = null;
           try
           {
               string SET1 = string.Empty;
               string SET2 = string.Empty;
               DataSet ds1 = new DataSet();
               SqlDataAdapter ad = new SqlDataAdapter();
               using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["myConn"].ToString()))
               {
                   SqlCommand cmd = new SqlCommand("ExamReportSPFinalOPENMerge", con);//GetCalculateFeeBySchoolSPNew
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.Parameters.AddWithValue("@SCHL", SCHL);
                   cmd.Parameters.AddWithValue("@lot", lot1);
                   cmd.Parameters.AddWithValue("@Class", pClass);
                   ad.SelectCommand = cmd;
                   ad.Fill(ds1);
                   con.Open();
                   if (ds1.Tables[2].Rows.Count > 0)
                   {
                       // rptpath = "~/RPTReports/ SeniorExamReport.rdlc";
                       file1 = RenderReportSO(rptpath, ds1);
                       reader = new PdfReader(file1);
                       reader.ConsolidateNamedDestinations();
                       // we retrieve the total number of pages
                       int n = reader.NumberOfPages;
                       pageOffset += n;

                       if (f == 0)
                       {
                           // step 1: creation of a document-object
                           document = new Document(reader.GetPageSizeWithRotation(1));
                           // step 2: we create a writer that listens to the document
                           //writer = new PdfCopy(document, new FileStream(Server.MapPath(Filepath), FileMode.Create));
                           writer = new PdfCopy(document, new FileStream(Filepath, FileMode.Create));
                           // step 3: we open the document
                           document.Open();
                       }
                       // step 4: we add content
                       for (int i = 0; i < n;)
                       {
                           ++i;
                           if (writer != null)
                           {
                               PdfImportedPage page = writer.GetImportedPage(reader, i);
                               writer.AddPage(page);
                           }
                       }
                       PRAcroForm form = reader.AcroForm;
                       if (form != null && writer != null)
                       {
                           writer.CopyAcroForm(reader);
                       }
                       f++;

                   }
               }
           }
           catch (Exception ex)
           {

           }
           finally
           {
               if (document != null)
               {
                   document.Close();
                   document.Dispose();
               }


           }
       }

       private byte[] RenderReportSO(string rptpath, DataSet ds2)
       {
           byte[] arr;
           ReportViewer1.Reset();
           //// ReportViewer1.LocalReport.ReportPath = rptpath;          
           ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/RPTReports/SeniorExamReportOpen.rdlc");
           LocalReport localReport = new LocalReport();
           // localReport.ReportPath = Server.MapPath(rptpath);
           localReport.ReportPath =  Server.MapPath("~/RPTReports/SeniorExamReportOpen.rdlc");
           //SqlCommand scommand2 = new SqlCommand(qry);
           //DataSet ds2 = DataManager2.getDataSet(scommand2);
           ds2.Tables[0].TableName = "Regdata";
           ReportViewer1.Visible = true;
           //  ReportDataSource datasource2 = new ReportDataSource("Regdata", ds2.Tables[0]);
           ReportDataSource datasource = new ReportDataSource("ExamReportDataSet", ds2.Tables[0]);
           ReportDataSource datasource1 = new ReportDataSource("SubjectwiseCountOfStudent", ds2.Tables[1]);
           ReportDataSource datasource2 = new ReportDataSource("SubjectwiseCountMatricExam", ds2.Tables[2]);
           ReportDataSource datasource4 = new ReportDataSource("ChallanDetails", ds2.Tables[3]);
           ReportViewer1.LocalReport.EnableExternalImages = true;
           string imagePath = new Uri(Server.MapPath("~/Upload/")).AbsoluteUri;
           ReportParameter parameter = new ReportParameter("ImgPath", imagePath);
           ReportViewer1.LocalReport.SetParameters(parameter);
           ReportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SubReportMatricSubjectSO);
           ReportViewer1.LocalReport.DataSources.Clear();
           ReportViewer1.LocalReport.DataSources.Add(datasource);
           ReportViewer1.LocalReport.DataSources.Add(datasource1);
           ReportViewer1.LocalReport.DataSources.Add(datasource2);
           ReportViewer1.LocalReport.DataSources.Add(datasource4);
           arr = ReportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
           ReportViewer1.LocalReport.Refresh();
           return arr;
           //    RenderReport(Request.QueryString["Schlid"].ToString());

       }

       void SubReportMatricSubjectSO(object sender, SubreportProcessingEventArgs e)
       {
           string CanId = e.Parameters["CANDID"].Values[0].ToString(); //CANDID

           DataSet ds=GetSubjectByIdSO(CanId);
           ds.Tables[0].TableName="MatricSubjectDataset";
           ReportDataSource datasource2 = new ReportDataSource("MatricSubjectDataset", ds.Tables[0]);
           e.DataSources.Add(datasource2);
       }
       private DataSet GetSubjectByIdSO(string Canid)
       {
           try
           {
               string qry = "SELECT * From tblsubjectOPEN where APPNO='" + Canid + "'  order by SUB_SEQ asc";
               DataSet ds2 = objRDB.GetDataByQuery(qry);
               ds2.Tables[0].TableName = "MatricSubjectDataset";
               return ds2;
           }
           catch
           {
               return null;
           }
       }


       // Matric Regular
       public void BindReportMR(string SCHL, string lot1, string pClass,string Filepath)
       {
           if (File.Exists(Server.MapPath(Filepath)))
           {
               File.Delete(Server.MapPath(Filepath));
           }
           int pageOffset = 0;
           ArrayList master = new ArrayList();
           int f = 0;
           Document document = null;
           PdfCopy writer = null;
           try
           {
               string SET1 = string.Empty;
               string SET2 = string.Empty;
               DataSet ds1 = new DataSet();
               SqlDataAdapter ad = new SqlDataAdapter();
               using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["myConn"].ToString()))
               {
                   SqlCommand cmd = new SqlCommand("ExamReportSPFinalMerge", con);//GetCalculateFeeBySchoolSPNew
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.Parameters.AddWithValue("@SCHL", SCHL);
                   cmd.Parameters.AddWithValue("@lot", lot1);
                   cmd.Parameters.AddWithValue("@Class", pClass);
                   ad.SelectCommand = cmd;
                   ad.Fill(ds1);
                   con.Open();
                   if (ds1.Tables[2].Rows.Count > 0)
                   {
                       // rptpath = "~/RPTReports/ SeniorExamReport.rdlc";
                       file1 = RenderReportMR(rptpath, ds1);
                       reader = new PdfReader(file1);
                       reader.ConsolidateNamedDestinations();
                       // we retrieve the total number of pages
                       int n = reader.NumberOfPages;
                       pageOffset += n;

                       if (f == 0)
                       {
                           // step 1: creation of a document-object
                           document = new Document(reader.GetPageSizeWithRotation(1));
                           // step 2: we create a writer that listens to the document
                           //writer = new PdfCopy(document, new FileStream(Server.MapPath(Filepath), FileMode.Create));
                           writer = new PdfCopy(document, new FileStream(Filepath, FileMode.Create));
                           // step 3: we open the document
                           document.Open();
                       }
                       // step 4: we add content
                       for (int i = 0; i < n;)
                       {
                           ++i;
                           if (writer != null)
                           {
                               PdfImportedPage page = writer.GetImportedPage(reader, i);
                               writer.AddPage(page);
                           }
                       }
                       PRAcroForm form = reader.AcroForm;
                       if (form != null && writer != null)
                       {
                           writer.CopyAcroForm(reader);
                       }
                       f++;

                   }
               }
           }
           catch (Exception ex)
           {

           }
           finally
           {
               if (document != null)
               {
                   document.Close();
                   document.Dispose();
               }


           }
       }

       private byte[] RenderReportMR(string rptpath, DataSet ds2)
       {
           byte[] arr;
           ReportViewer1.Reset();
           //// ReportViewer1.LocalReport.ReportPath = rptpath;
           ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/RPTReports/ExamReport1.rdlc");
           LocalReport localReport = new LocalReport();
           // localReport.ReportPath = Server.MapPath(rptpath);
           localReport.ReportPath =  Server.MapPath("~/RPTReports/ExamReport1.rdlc");
           //SqlCommand scommand2 = new SqlCommand(qry);
           //DataSet ds2 = DataManager2.getDataSet(scommand2);
           ds2.Tables[0].TableName = "Regdata";
           ReportViewer1.Visible = true;
           //  ReportDataSource datasource2 = new ReportDataSource("Regdata", ds2.Tables[0]);
           ReportDataSource datasource = new ReportDataSource("ExamReportDataSet", ds2.Tables[0]);
           ReportDataSource datasource1 = new ReportDataSource("SubjectwiseCountOfStudent", ds2.Tables[1]);
           ReportDataSource datasource2 = new ReportDataSource("SubjectwiseCountMatricExam", ds2.Tables[2]);
           ReportDataSource datasource4 = new ReportDataSource("ChallanDetails", ds2.Tables[3]);
           ReportViewer1.LocalReport.EnableExternalImages = true;
           string imagePath = new Uri(Server.MapPath("~/Upload/")).AbsoluteUri;
           ReportParameter parameter = new ReportParameter("ImgPath", imagePath);
           ReportViewer1.LocalReport.SetParameters(parameter);
           ReportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SubReportMatricSubjectMR);
           ReportViewer1.LocalReport.DataSources.Clear();
           ReportViewer1.LocalReport.DataSources.Add(datasource);
           ReportViewer1.LocalReport.DataSources.Add(datasource1);
           ReportViewer1.LocalReport.DataSources.Add(datasource2);
           ReportViewer1.LocalReport.DataSources.Add(datasource4);
           arr = ReportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
           ReportViewer1.LocalReport.Refresh();
           return arr;
           //    RenderReport(Request.QueryString["Schlid"].ToString());

       }

       void SubReportMatricSubjectMR(object sender, SubreportProcessingEventArgs e)
       {
           string CanId = e.Parameters["CANDID"].Values[0].ToString();

           DataSet ds=GetSubjectByIdMR(CanId);
           ds.Tables[0].TableName="MatricSubjectDataset";
           ReportDataSource datasource2 = new ReportDataSource("MatricSubjectDataset", ds.Tables[0]);
           e.DataSources.Add(datasource2);
       }

       private DataSet GetSubjectByIdMR(string Canid)
       {
           try
           {
               string qry = "SELECT * From tblMatricSubjects where candid='" + Canid + "'  order by SUB_SEQ asc";
               DataSet ds2 = objRDB.GetDataByQuery(qry);
               ds2.Tables[0].TableName = "MatricSubjectDataset";
               return ds2;
           }
           catch
           {
               return null;
           }
       }

       // MATRIC OPEN
       public void BindReportMO(string SCHL, string lot1, string pClass,string Filepath)
       {
           if (File.Exists(Server.MapPath(Filepath)))
           {
               File.Delete(Server.MapPath(Filepath));
           }
           int pageOffset = 0;
           ArrayList master = new ArrayList();
           int f = 0;
           Document document = null;
           PdfCopy writer = null;
           try
           {
               string SET1 = string.Empty;
               string SET2 = string.Empty;
               DataSet ds1 = new DataSet();
               SqlDataAdapter ad = new SqlDataAdapter();
               using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["myConn"].ToString()))
               {
                   SqlCommand cmd = new SqlCommand("ExamReportSPFinalOPENMerge", con);//GetCalculateFeeBySchoolSPNew
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.Parameters.AddWithValue("@SCHL", SCHL);
                   cmd.Parameters.AddWithValue("@lot", lot1);
                   cmd.Parameters.AddWithValue("@Class", pClass);
                   ad.SelectCommand = cmd;
                   ad.Fill(ds1);
                   con.Open();
                   if (ds1.Tables[2].Rows.Count > 0)
                   {
                       // rptpath = "~/RPTReports/ SeniorExamReport.rdlc";
                       file1 = RenderReportMO(rptpath, ds1);
                       reader = new PdfReader(file1);
                       reader.ConsolidateNamedDestinations();
                       // we retrieve the total number of pages
                       int n = reader.NumberOfPages;
                       pageOffset += n;

                       if (f == 0)
                       {
                           // step 1: creation of a document-object
                           document = new Document(reader.GetPageSizeWithRotation(1));
                           // step 2: we create a writer that listens to the document
                           //writer = new PdfCopy(document, new FileStream(Server.MapPath(Filepath), FileMode.Create));
                           writer = new PdfCopy(document, new FileStream(Filepath, FileMode.Create));
                           // step 3: we open the document
                           document.Open();
                       }
                       // step 4: we add content
                       for (int i = 0; i < n;)
                       {
                           ++i;
                           if (writer != null)
                           {
                               PdfImportedPage page = writer.GetImportedPage(reader, i);
                               writer.AddPage(page);
                           }
                       }
                       PRAcroForm form = reader.AcroForm;
                       if (form != null && writer != null)
                       {
                           writer.CopyAcroForm(reader);
                       }
                       f++;

                   }
               }
           }
           catch (Exception ex)
           {

           }
           finally
           {
               if (document != null)
               {
                   document.Close();
                   document.Dispose();
               }


           }
       }

       private byte[] RenderReportMO(string rptpath, DataSet ds2)
       {
           byte[] arr;
           ReportViewer1.Reset();
           //// ReportViewer1.LocalReport.ReportPath = rptpath;          
           ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/RPTReports/ExamReport1Open.rdlc");
           LocalReport localReport = new LocalReport();
           // localReport.ReportPath = Server.MapPath(rptpath);
           localReport.ReportPath =  Server.MapPath("~/RPTReports/ExamReport1Open.rdlc");
           //SqlCommand scommand2 = new SqlCommand(qry);
           //DataSet ds2 = DataManager2.getDataSet(scommand2);
           ds2.Tables[0].TableName = "Regdata";
           ReportViewer1.Visible = true;
           //  ReportDataSource datasource2 = new ReportDataSource("Regdata", ds2.Tables[0]);
           ReportDataSource datasource = new ReportDataSource("ExamReportDataSet", ds2.Tables[0]);
           ReportDataSource datasource1 = new ReportDataSource("SubjectwiseCountOfStudent", ds2.Tables[1]);
           ReportDataSource datasource2 = new ReportDataSource("SubjectwiseCountMatricExam", ds2.Tables[2]);
           ReportDataSource datasource4 = new ReportDataSource("ChallanDetails", ds2.Tables[3]);
           ReportViewer1.LocalReport.EnableExternalImages = true;
           string imagePath = new Uri(Server.MapPath("~/Upload/")).AbsoluteUri;
           ReportParameter parameter = new ReportParameter("ImgPath", imagePath);
           ReportViewer1.LocalReport.SetParameters(parameter);
           ReportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SubReportMatricSubjectMO);
           ReportViewer1.LocalReport.DataSources.Clear();
           ReportViewer1.LocalReport.DataSources.Add(datasource);
           ReportViewer1.LocalReport.DataSources.Add(datasource1);
           ReportViewer1.LocalReport.DataSources.Add(datasource2);
           ReportViewer1.LocalReport.DataSources.Add(datasource4);
           arr = ReportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
           ReportViewer1.LocalReport.Refresh();
           return arr;
           //    RenderReport(Request.QueryString["Schlid"].ToString());

       }

       void SubReportMatricSubjectMO(object sender, SubreportProcessingEventArgs e)
       {
           string CanId = e.Parameters["CANDID"].Values[0].ToString();// CANDID
           DataSet ds=GetSubjectByIdMO(CanId);
           ds.Tables[0].TableName="MatricSubjectDataset";
           ReportDataSource datasource2 = new ReportDataSource("MatricSubjectDataset", ds.Tables[0]);
           e.DataSources.Add(datasource2);
       }
       private DataSet GetSubjectByIdMO(string Canid)
       {
           try
           {
               string qry = "SELECT * From tblsubjectOPEN where APPNO='" + Canid + "'  order by SUB_SEQ asc";
               DataSet ds2 = objRDB.GetDataByQuery(qry);
               ds2.Tables[0].TableName = "MatricSubjectDataset";
               return ds2;
           }
           catch
           {
               return null;
           }
       }



       private void Export()
       {
           //Clear the response stream and write the bytes to the outputstream
           //Set content-disposition to "attachment" so that user is prompted to take an action
           //on the file (open or save)
           //Response.Clear();
           Response.ContentType = mimeType;
           Response.ContentType = "PDF";
           //Response.AddHeader("filename","FormReport.pdf");
           Response.AddHeader("content-disposition", "attachment; filename=FinalReport12." + fileNameExtension);
           Response.BinaryWrite(renderedBytes);
           Response.End();
       }



      </script>
</head>
<body>
     <form id="form1" runat="server">



<div>
        <center>
            <a href="onlineregistration.aspx" class="submitanc">Back </a>&nbsp;&nbsp;
            
            <a href="PB/PNBAM3BT.ttf" class="submitanc">If any thing Not readable Click Here to
                Download Font</a>
        </center>
    </div>
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <table align="center" width="100%">
        <tr>
        <td>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px"
        Font-Names="pnb-ttamarenbold" Font-Size="8pt" InteractiveDeviceInfos="(Collection)"
         WaitMessageFont-Size="14pt" ShowExportControls="False">
            <LocalReport ReportPath="RPTReports/SeniorExamReport.rdlc">
                <%--~/RPTReports/SeniorExamReport.rdlc--%>
            </LocalReport>
        </rsweb:ReportViewer>
        </td>
        </tr>
        </table>
    </div>
    </form>
</body>
</html>
