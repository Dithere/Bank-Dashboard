<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Bank Dashboard</title>
  <link rel="stylesheet" href="st.css" />
  <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
</head>
<body>
  <div class="container">
    <h1 class="glow">Bank - Dashboard</h1>
    
    <div class="tabs">
      <button class="tab-btn" onclick="openTab('ca')">Check Account No</button>
      <button class="tab-btn" onclick="openTab('add')">Add Money</button>
      <button class="tab-btn" onclick="openTab('transfer')">Transfer Money</button>
      <button class="tab-btn" onclick="openTab('withdraw')">Withdraw</button>
      <button class="tab-btn" onclick="openTab('balance')">Check Balance</button>
    </div>

    

    <div class="tab-content" id="add" style="display:none;">
      <h2>Add Money</h2>
      <form action="addmoney" method="post">
        <input type="number" placeholder="Amount ₹" required name="amt">
        <button type="submit" name="add"onclick="alert('ADDED SUCCESFULL!')">Add Funds</button>
      </form>
    </div>

    <div class="tab-content" id="transfer" style="display:none;">
      <h2>Transfer Money</h2>
      <form action="trans" method="post">
        <input type="text" placeholder="Recipient Account No." required name="rac">
        <input type="number" placeholder="Amount ₹" required name="amt">
        <button type="submit"onclick="alert('TRANSFER SUCCESFULL!')">Transfer</button>
      </form>
    </div>

    <div class="tab-content" id="withdraw" style="display:none;">
      <h2>Withdraw Money</h2>
      <form action="cutmoney" method="post">
        <input type="number" placeholder="Amount ₹" required name="amt">
        <button type="submit"onclick="alert('WITHDRAW SUCCESFULL!')">Withdraw</button>
      </form>
    </div>

    <div class="tab-content" id="balance" style="display:none;">
      <h2>Check Balance</h2>
      <form action="cb" method="post">
      <p class="balance">₹<%= request.getAttribute("bal") %></p>
      <button onclick="alert('CHECK NOW!')">Refresh</button>
      </form>
    </div>
  </div>
  <div class="tab-content" id="ca" style="display:none;">
      <h2>Check Account No.</h2>
      <form action="ca" method="post">
      <p class="balance"><%= request.getAttribute("balo") %></p>
      <button onclick="alert('CHECK NOW!')">Check Now</button>
      </form>
    </div>
  </div>

  <script src="script.js"></script>
</body>
</html>
