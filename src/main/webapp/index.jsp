<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
     <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="description" content="Secure login page for Bank users. Access your account safely and easily.">
  <meta name="keywords" content="Bank, Login, Secure, Account, Finance">
  <meta name="author" content="Bank Inc.">

  <title>Bank - Secure Login</title>

  <link rel="icon" href="favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="styles.css"> <!-- Your external CSS if any -->
  

  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
    <link rel="stylesheet" href="style.css">
    
    
</head>
<body>

    <h1 class="glow">Login Into Bank</h1>
    

<style>
  h1.glow {
    text-align: center;
    margin-top: -10px;
    color: #00ffff !important;
    text-shadow: 0 0 5px #00ffff, 0 0 10px #00ffff;
  }
</style>
    



    <div id="box">
    
        <form action="login" method="post">
            <div class="mb-3">
            <label for="exampleInputEmail1" class="form-label" >Username</label>
            <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"name="username">
            <div id="emailHelp" class="form-text">We'll never share your information with anyone else.</div>
            </div>
            <div class="mb-3">
            <label for="exampleInputPassword1" class="form-label" >Password</label>
            <input type="password" class="form-control" id="exampleInputPassword1"name="password">
            </div>
            <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="exampleCheck1">
            <label class="form-check-label" for="exampleCheck1">Remember Me</label>
            </div>
            <button type="submit" class="btn btn-primary">Log In</button>
      </form>
    </div>
    <div id="ro">
        <a href="index2.jsp" id="co">Don't have an account?Register</a>
        <%-- Display error message if login fails --%>
        <% String error = request.getParameter("error");
            if (error != null && error.equals("1")) { %>
                <p style="color: red;">Invalid username or password. Please try again.</p>
        <% } %>
        
        <%-- Display error message if Register Successful --%>
        <% String rs = request.getParameter("registration");
            if (rs != null && rs.equals("success")) { %>
                <p style="color: green;">Your Registration is Successful. Please Login.</p>
        <% } %>
    </div>
</body>
</html>