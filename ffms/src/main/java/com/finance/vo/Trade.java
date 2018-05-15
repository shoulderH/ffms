/*
 * Copyright (c) 2005, 2018, EVECOM Technology Co.,Ltd. All rights reserved.
 * EVECOM PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */
package com.finance.vo;

/**
 * 持有证券流水实体
 * @author Oli Hong
 * @created 2018年1月3日 上午10:51:49
 */
public class Trade {
private int tradeid;
private int securityid;
private int price;
private int number;
private int money;
private String source;
private String tradetime;
private String securitynumber; //证券账号
private String starttime;// 搜索起始时间
private String endtime;// 搜索截止时间

public int getTradeid() {
	return tradeid;
}
public void setTradeid(int tradeid) {
	this.tradeid = tradeid;
}
public int getSecurityid() {
	return securityid;
}
public void setSecurityid(int securityid) {
	this.securityid = securityid;
}
public int getPrice() {
	return price;
}
public void setPrice(int price) {
	this.price = price;
}
public int getNumber() {
	return number;
}
public void setNumber(int number) {
	this.number = number;
}
public int getMoney() {
	return money;
}
public void setMoney(int money) {
	this.money = money;
}
public String getSource() {
	return source;
}
public void setSource(String source) {
	this.source = source;
}


public String getTradetime() {
	return tradetime;
}
public void setTradetime(String tradetime) {
	this.tradetime = tradetime;
}
public String getStarttime() {
	return starttime;
}
public void setStarttime(String starttime) {
	this.starttime = starttime;
}
public String getEndtime() {
	return endtime;
}
public void setEndtime(String endtime) {
	this.endtime = endtime;
}


public String getSecuritynumber() {
	return securitynumber;
}
public void setSecuritynumber(String securitynumber) {
	this.securitynumber = securitynumber;
}
public Trade() {
	super();
	// TODO Auto-generated constructor stub
}

public Trade(int tradeid, int securityid, int price, int number, int money,
		String source, String tradetime, String starttime, String endtime) {
	super();
	this.tradeid = tradeid;
	this.securityid = securityid;
	this.price = price;
	this.number = number;
	this.money = money;
	this.source = source;
	this.tradetime = tradetime;
	this.starttime = starttime;
	this.endtime = endtime;
}

public Trade(int tradeid, int price, int number, int money, String source,
		String tradetime, String securitynumber) {
	super();
	this.tradeid = tradeid;
	this.price = price;
	this.number = number;
	this.money = money;
	this.source = source;
	this.tradetime = tradetime;
	this.securitynumber = securitynumber;
}
@Override
public String toString() {
	return "Trade [tradeid=" + tradeid + ", securityid=" + securityid
			+ ", price=" + price + ", number=" + number + ", money=" + money
			+ ", source=" + source + ", tradeyime=" + tradetime + "]";
}


}
