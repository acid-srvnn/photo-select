<!DOCTYPE html>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.servlet.http.*" %>
<html>
<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>Photo Viewer - Load Configuration</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</head>
<body style="background-color: burlywood;">

    <div class="container-fluid" style="text-align: center;">
        <div class="row justify-content-center">
          <div class="col-6">
              <input id='src' type="text" placeholder="src folder" value="D:\temp\Media\WeddingPics\Album\Reception\Full" class="col-md-12">
          </div>
          <div class="col-6">
            <input id='dst' type="text" placeholder="dest folder" value="D:\temp\Media\WeddingPics\Album\Reception\Stage1Passed" class="col-md-12">
          </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-6">
                <button onclick="javascript:loadFiles()" class="btn btn-primary">Load Config</button>
            </div>
            <div class="col-6">
                <a class="btn btn-primary" href="index.jsp">View Photos</a>
            </div>
        </div>

    </div>

    

    <%
        String loadNow = request.getParameter("load");
        Boolean loadNowBool = loadNow !=null && loadNow.equals("true");
        if(loadNowBool){
            String srcFolder = request.getParameter("src");
            srcFolder = URLDecoder.decode(srcFolder, "UTF-8");
            String destFolder = request.getParameter("dst");
            destFolder = URLDecoder.decode(destFolder, "UTF-8");
            
            File path = new File(srcFolder);

            ArrayList<String> fileslist = new ArrayList<String>();

            File [] files = path.listFiles();
            for (int i = 0; i < files.length; i++){
                if (files[i].isFile()){ 
                    fileslist.add(files[i].getAbsolutePath());
                }
            }

            request.getSession().setAttribute("src",srcFolder);
            request.getSession().setAttribute("dst",destFolder);
            request.getSession().setAttribute("fileslist",fileslist);
        }
    %>

    <%if(loadNowBool){%>
        <br>
        Loaded <br>
        srcFolder - <%=request.getSession().getAttribute("src")%> <br>
        dstFolder - <%=request.getSession().getAttribute("dst")%> <br>
        Count - <%=((ArrayList<String>)request.getSession().getAttribute("fileslist")).size()%> <br>
    <%}%>

    <script>
        function loadFiles(){
            var url = window.location.href.split('?')[0];
            window.open(url+'?load=true&src='+encodeURI(document.getElementById('src').value)+'&dst='+encodeURI(document.getElementById('dst').value),"_self");
        }
    </script>
    
</body>
</html>