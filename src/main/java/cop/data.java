package cop;


public interface data {
	boolean addUser(user user);
	boolean isValidUser(String username, String password);
	boolean account_ex(String username);
	long generateaccountnumber();
	long getAccountNumber(String username);
	
	
	long open_accounts(String username, Ac ac);
	void credit(long account_number,amu amu);
double getBalance(long acc);
void debit(long account_number, amu amu);
void transfermoney(long sender_account_number,long receiver_account_number,double amount);
}
