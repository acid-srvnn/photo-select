<!DOCTYPE html>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.servlet.http.*" %>
<html>
<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>Photo Viewer</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</head>
<body style="background-color: burlywood;">

    <%
        String saveNow = request.getParameter("save");
        
        String currentFileNumberStr = request.getParameter("curr");
        int currentFileNumber = 0;
        if(currentFileNumberStr==null){
            currentFileNumber=0;
        }else{
            currentFileNumber=Integer.parseInt(currentFileNumberStr);
        }
        
        int nearbyFileNumber[] = {0,0,0,0,0};
        String nearbyFileSrc[] = {"","","","",""};
        for(int i=-2;i<=2;i++){
            int n = currentFileNumber + i;
            if(n<0){
                n=0;
            }
            nearbyFileNumber[i+2] = n;
        }
        
        String currentFileSrc="";
        Object obj = request.getSession().getAttribute("fileslist");
        int totalFilesCount = 0;
        if(obj != null){
            ArrayList<String> fileslist = (ArrayList<String>)obj;
            totalFilesCount = fileslist.size();
            String fileNames[] = fileslist.get(currentFileNumber).split("\\\\");
            currentFileSrc="/photo/getimage?filename="+URLEncoder.encode(fileslist.get(currentFileNumber), "UTF-8");

            for(int i=-2;i<=2;i++){
                int n = nearbyFileNumber[i+2];
                String fileNames1[] = fileslist.get(n).split("\\\\");
                nearbyFileSrc[i+2]="/photo/getimage?filename="+URLEncoder.encode(fileslist.get(n), "UTF-8");
            }
            
            String destFolder = (String)request.getSession().getAttribute("dst");

            if(saveNow !=null && saveNow.equals("true")){
                File oldFile = new File(fileslist.get(currentFileNumber));
                if(oldFile.renameTo(new File(destFolder+"\\"+fileNames[fileNames.length-1])))
                {
                    // if file copied successfully then delete the original file
                    oldFile.delete();
                    System.out.println("File moved successfully "+fileslist.get(currentFileNumber));
                }
            }  
        }

        int srcFolderSize = 0;//new File((String)request.getSession().getAttribute("src")).listFiles().length;
        int dstFolderSize = new File((String)request.getSession().getAttribute("dst")).listFiles().length;
        
        
    %>

    <div class="container-fluid" style="text-align: center;">
        <div class="row justify-content-center">
          <div class="col-6">
            <span class="badge badge-info">srcFolder - <%=request.getSession().getAttribute("src")%></span>
            <!--span class="badge badge-primary"><%=srcFolderSize%> </span-->
            <a class="badge badge-primary" href="load.jsp">Load New Config</a>
          </div>
          <div class="col-6">
            <span class="badge badge-info">dstFolder - <%=request.getSession().getAttribute("dst")%></span>
            <span class="badge badge-primary"><%=dstFolderSize%> </span>
          </div>
        </div>

        <div class="row" style="margin-top: 0px;">
            <div class="col-12" style="text-align: center;">
                <span class="badge badge-success">Showing <%=currentFileNumber%> of <%=totalFilesCount%> </span>
                <span class="badge badge-primary"><%=currentFileSrc%></span>
            </div>
        </div>

        <div class="row" style="margin-top: 10px;">
            <div id='divimg' style="overflow-x:scroll; white-space: nowrap" class="col-md-12" tabindex="-1">
                <img src="<%=nearbyFileSrc[0]%>" height="700px"/>
                <img src="<%=nearbyFileSrc[1]%>" height="700px"/>
                <img id="mainimg" src='<%=currentFileSrc%>' height="800px" style="border: solid 10px green;"/>
                <img src="<%=nearbyFileSrc[3]%>" height="700px"/>
                <img src="<%=nearbyFileSrc[4]%>" height="700px"/>
            </div>
        </div>

        <!--div class="row justify-content-center">
            <%for(int i=0;i<5;i++){%>
                <div class="col-md-1">
                <img src="<%=nearbyFileSrc[i]%>" height="50px"/>
                </div>
            <%}%>
        </div-->

        <div class="row justify-content-center" style="margin-top: 10px;">
            <div class="col-md-1"><button id='btp' class="btn btn-info" onclick="javascript:goPrev()">Previous (a)</button></div>
            <div class="col-md-1"><button id='bts' class="btn btn-success" onclick="javascript:saveFile()">Select (s)</button></div>
            <div class="col-md-1"><button id='btn' class="btn btn-info" onclick="javascript:goNext()">Next (d)</button></div>
        </div>

      </div>    
    

    <script>
        function goNext(){
            var curr = <%=currentFileNumber%>;
            curr++;
            var url = window.location.href.split('?')[0];
            window.open(url+'?curr='+curr,"_self")
        }
        function goPrev(){
            var curr = <%=currentFileNumber%>;
            curr--;
            if(curr == -1){
                curr = 0;
            }
            var url = window.location.href.split('?')[0];
            window.open(url+'?curr='+curr,"_self");
        }
        function loadFiles(){
            var url = window.location.href.split('?')[0];
            window.open(url+'?load=true&src='+encodeURI(document.getElementById('src').value)+'&dst='+encodeURI(document.getElementById('dst').value),"_self");
        }
        function saveFile(){
            var curr = <%=currentFileNumber%>;
            var url = window.location.href.split('?')[0];
            window.open(url+'?curr='+curr+'&save=true',"_self")
        }

        document.addEventListener("keydown", function(event) {
            if(event.keyCode == "65"){
                document.getElementById("btp").click();
            }
            if(event.keyCode == "83"){
                document.getElementById("bts").click();
            }
            if(event.keyCode == "68"){
                document.getElementById("btn").click();
            }
        });
        
        $( document ).ready(function() {
            document.getElementById('mainimg').scrollIntoView({ inline: 'center' });
            $('#divimg').focus();
        });
    </script>
    
</body>
</html>