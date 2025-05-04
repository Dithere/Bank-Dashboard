package cop;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jakarta.servlet.http.HttpSession;


public class dataimp implements data{
	user user =new user();
	String username=user.getUsername();
	
	@Override
	public boolean isValidUser(String username, String password) {
		// TODO Auto-generated method stub
		this.username=username;
		String lq="select * from user where username = ? and password = ?";
	    try(Connection con =DBUtil.getConnection()) {
	        PreparedStatement ps =con.prepareStatement(lq);
	        ps.setString(1, username);
	        ps.setString(2, password);
	        ResultSet rs = ps.executeQuery();
	        System.out.println("hfufcj");
	 
	        return rs.next();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	@Override
	public boolean addUser(user user) {
		this.username=username;
		// TODO Auto-generated method stub
		String query = "INSERT INTO user (username, password) VALUES (?, ?)";

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setString(1, user.getUsername());
            
            preparedStatement.setString(2, user.getPassword());

            int rowsAffected = preparedStatement.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean account_ex(String username) {
		// TODO Auto-generated method stub
		this.username=username;
		String query="select account_number from accounts where username = ?";
        try(Connection con =DBUtil.getConnection()) {
            PreparedStatement ps=con.prepareStatement(query);
            ps.setString(1, username);
            ResultSet rs =ps.executeQuery();
            if(rs.next()){
                return true;
                //true hai matlab account exists karta hai
                //rs.next matlab jab tak data hai
            }
            else{
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
	}

	@Override
	public long generateaccountnumber() {
		this.username=username;
		// TODO Auto-generated method stub
		try(Connection con =DBUtil.getConnection()) {
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery("select account_number from accounts order by account_number desc limit 1");
            if(rs.next()){
                long last_account_number = rs.getLong("account_number");
                return last_account_number+1;
            }
            else{
                return 10010001;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 10010001;
	}

	@Override
	public long getAccountNumber(String username) {
		this.username=username;
		// TODO Auto-generated method stub
		String query = "SELECT account_number from accounts WHERE username = ?";
        try(Connection con =DBUtil.getConnection()) {
            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, username);
            ResultSet resultSet = preparedStatement.executeQuery();
            if(resultSet.next()){
                return resultSet.getLong("account_number");
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        throw new RuntimeException("Account Number Doesn't Exist!");
	}
	@Override

	public long open_accounts(String username,Ac ac){
		this.username=username;
        if(!account_ex(username)){
            String aq ="insert into accounts(account_number,username,name,balance,pin) values(?,?,?,?,?)";
           
            
            try (Connection con =DBUtil.getConnection()){
                long account_number = generateaccountnumber();
                PreparedStatement ps = con.prepareStatement(aq);
                ps.setLong(1, account_number);
                ps.setString(2, username);
                ps.setString(3, ac.getname());
                ps.setDouble(4, ac.getAmt());
                ps.setString(5, ac.getPin());
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    return account_number;
                } else {
                    throw new RuntimeException("Account Creation failed!!");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        throw new RuntimeException("Account Already Exists!");
    }

	@Override
	public void credit(long account_number,amu amu) {
		// TODO Auto-generated method stub
		this.username=username;
	    try (Connection con =DBUtil.getConnection()){
            con.setAutoCommit(false);
            if(account_number!=0){
                PreparedStatement ps =con.prepareStatement("select * from accounts where account_number = ?");
                ps.setLong(1, account_number);
                
                ResultSet rs=ps.executeQuery();
                if(rs.next()){
                    double cb =rs.getDouble("balance");
                    String cq ="update accounts set balance =balance + ? where account_number = ?";
                    PreparedStatement ps1 = con.prepareStatement(cq);
                    ps1.setDouble(1, amu.getAmt());
                    ps1.setLong(2, account_number);
                    int rowsAffected =ps1.executeUpdate();
                    if(rowsAffected>0){
//                        System.out.println("RS."+amu.getAmt()+"CREDITED SUCCESFULLY");
                        con.commit();
                        con.setAutoCommit(true);
                    }
                    else{
//                        System.out.println("TRANSACTION FAILED!");
                        con.rollback();
                        con.setAutoCommit(true);
                    }

                }
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
		
	}
    public double getBalance(long account_number){
    	Ac ac=new Ac();
    	
    	this.username=username;
    	
        try(Connection con =DBUtil.getConnection()){
            PreparedStatement preparedStatement = con.prepareStatement("SELECT balance FROM accounts WHERE account_number = ?");
            preparedStatement.setLong(1, account_number);
            
            ResultSet resultSet = preparedStatement.executeQuery();
            if(resultSet.next()){
                return resultSet.getDouble("balance");
                
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
		return 0;
    }
    @Override
    public void debit(long account_number,amu amu) {
    	// TODO Auto-generated method stub
    	this.username=username;
        try (Connection con =DBUtil.getConnection()){
            con.setAutoCommit(false);
            if(account_number!=0){
                PreparedStatement ps =con.prepareStatement("select * from accounts where account_number = ?");
                ps.setLong(1, account_number);
                
                ResultSet rs=ps.executeQuery();
                if(rs.next()){
                    double cb =rs.getDouble("balance");
                    String cq ="update accounts set balance =balance - ? where account_number = ?";
                    PreparedStatement ps1 = con.prepareStatement(cq);
                    ps1.setDouble(1, amu.getAmt());
                    ps1.setLong(2, account_number);
                    int rowsAffected =ps1.executeUpdate();
                    if(rowsAffected>0){
//                        System.out.println("RS."+amu.getAmt()+"CREDITED SUCCESFULLY");
                        con.commit();
                        con.setAutoCommit(true);
                    }
                    else{
//                        System.out.println("TRANSACTION FAILED!");
                        con.rollback();
                        con.setAutoCommit(true);
                    }

                }
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    	
    }
    public void transfermoney(long sender_account_number,long receiver_account_number,double amount){
    	this.username=username;
        try (Connection con =DBUtil.getConnection()){
            con.setAutoCommit(false);
            if(sender_account_number !=0 && receiver_account_number !=0){
                PreparedStatement ps= con.prepareStatement("select * from accounts where account_number = ? ");
                ps.setLong(1, sender_account_number);
                
                ResultSet rs =ps.executeQuery();
                if (rs.next()) {
                    
                    if (amount<=getBalance(sender_account_number)){

                        // Write debit and credit queries
                        String debit_query = "UPDATE accounts SET balance = balance - ? WHERE account_number = ?";
                        String credit_query = "UPDATE accounts SET balance = balance + ? WHERE account_number = ?";

                        // Debit and Credit prepared Statements
                        PreparedStatement creditPreparedStatement = con.prepareStatement(credit_query);
                        PreparedStatement debitPreparedStatement = con.prepareStatement(debit_query);

                        // Set Values for debit and credit prepared statements
                        creditPreparedStatement.setDouble(1, amount);
                        creditPreparedStatement.setLong(2, receiver_account_number);
                        debitPreparedStatement.setDouble(1, amount);
                        debitPreparedStatement.setLong(2, sender_account_number);
                        int rowsAffected1 = debitPreparedStatement.executeUpdate();
                        int rowsAffected2 = creditPreparedStatement.executeUpdate();
                        if (rowsAffected1 > 0 && rowsAffected2 > 0) {
                            System.out.println("Transaction Successful!");
                            System.out.println("Rs."+amount+" Transferred Successfully");
                            con.commit();
                            con.setAutoCommit(true);
                            return;
                        } else {
                            System.out.println("Transaction Failed");
                            con.rollback();
                            con.setAutoCommit(true);
                        }
                    }else{
                        System.out.println("Insufficient Balance!");
                    }
                }else{
                    System.out.println("Invalid Security Pin!");
                }
            }else{
            	
                System.out.println("Invalid account number");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }


	

}

