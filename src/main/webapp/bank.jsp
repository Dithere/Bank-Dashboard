<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Bank Dashboard</title>
  <link rel="stylesheet" href="styles.css" />
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
  <div class="container">

    <div class="card-container">
      
      <div class="card">
        <h2>Open Account</h2>
        <form action="open" method="post">
          <input type="text" placeholder="Full Name" required name="name"/>
          <input type="number" placeholder="Initial Ammount" required name="ammount"/>
          <input type="password" placeholder="Pin" required name="pin"/>

          <button type="submit">Open Account</button>
        </form>
      </div>

    </div>
  </div>
</body>
</html>
