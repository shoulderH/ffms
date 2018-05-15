/**
 * 
 */
package com.finance.model;

/**
 * @author HZX
 *
 */
public class IncomeAndPay {
private String c_anystring;   //可为省份或者称谓
private int c_incomemoney;
private int c_paymoney;
private int c_totalmoney;

public String getC_anystring() {
	return c_anystring;
}
public void setC_anystring(String c_anystring) {
	this.c_anystring = c_anystring;
}
public int getC_incomemoney() {
	return c_incomemoney;
}
public void setC_incomemoney(int c_incomemoney) {
	this.c_incomemoney = c_incomemoney;
}
public int getC_paymoney() {
	return c_paymoney;
}
public void setC_paymoney(int c_paymoney) {
	this.c_paymoney = c_paymoney;
}
public int getC_totalmoney() {
	return c_totalmoney;
}
public void setC_totalmoney(int c_totalmoney) {
	this.c_totalmoney = c_totalmoney;
}
public IncomeAndPay() {
	super();
	// TODO Auto-generated constructor stub
}
public IncomeAndPay(String c_anystring, int c_incomemoney, int c_paymoney,
		int c_totalmoney) {
	super();
	this.c_anystring = c_anystring;
	this.c_incomemoney = c_incomemoney;
	this.c_paymoney = c_paymoney;
	this.c_totalmoney = c_totalmoney;
}
@Override
public String toString() {
	return "IncomeAndPay [c_anystring=" + c_anystring + ", c_incomemoney="
			+ c_incomemoney + ", c_paymoney=" + c_paymoney + ", c_totalmoney="
			+ c_totalmoney + "]";
}



}
