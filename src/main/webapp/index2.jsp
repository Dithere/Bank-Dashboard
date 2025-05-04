<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1 class="glow">Register Into Bank</h1>
    

<style>
  h1.glow {
    text-align: center;
    margin-top: 40px;
    color: #00ffff !important;
    text-shadow: 0 0 5px #00ffff, 0 0 10px #00ffff;
  }
</style>
    <div id="box">
        <form action="register" method="post">
            <div class="mb-3">
            <label for="exampleInputEmail1" class="form-label" >Username</label>
            <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"name="username">
            <div id="emailHelp" class="form-text">We'll never share your information with anyone else.</div>
            </div>
            <div class="mb-3">
            <label for="exampleInputPassword1" class="form-label">Password</label>
            <input type="password" class="form-control" id="exampleInputPassword1" name="password">
            </div>
            <div class="mb-3">
                <label for="exampleInputPassword1" class="form-label" >Re-Enter Password</label>
                <input type="password" class="form-control" id="exampleInputPassword1"name="repassword">
            </div>
            <button type="submit" class="btn btn-primary">Register</button>
      </form>
    </div>
    <div id="ro">
        <a href="index.jsp" id="co">Already have an account?log in</a>
        <% String error = request.getParameter("error");
            if (error != null && error.equals("1")) { %>
                <p style="color: red;">Username Already exsist</p>
        <% } %>
        <% String error2 = request.getParameter("error");
            if (error != null && error.equals("2")) { %>
                <p style="color: red;">Password was incorrect</p>
        <% } %>
        
        <%-- Display error message if Register Successful --%>
        <% String rs = request.getParameter("registration");
            if (rs != null && rs.equals("success")) { %>
                <p style="color: green;">Your Registration is Successful. Please Login.</p>
        <% } %>
    </div>
</body>
</html>