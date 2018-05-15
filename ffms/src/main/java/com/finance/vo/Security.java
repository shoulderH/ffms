/*
 * Copyright (c) 2005, 2018, EVECOM Technology Co.,Ltd. All rights reserved.
 * EVECOM PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */
package com.finance.vo;

import java.util.List;

/**
 * 持有证券
 * 
 * @author Oli Hong
 * @created 2018年4月3日 上午11:06:05
 */
public class Security {
	private int id;
	private String securitynumber;
	private String securitypassword;
	private String username;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
    	
	public void setSecuritynumber(String securitynumber) {
		this.securitynumber = securitynumber;
	}
	public String getSecuritynumber() {
		return securitynumber;
	}
	public String getSecuritypassword() {
		return securitypassword;
	}
	public void setSecuritypassword(String securitypassword) {
		this.securitypassword = securitypassword;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	
	
	
	public Security() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Security(int id, String securitynumber, String securitypassword,
			String username) {
		super();
		this.id = id;
		this.securitynumber = securitynumber;
		this.securitypassword = securitypassword;
		this.username = username;
	}
	@Override
	public String toString() {
		return "Security [id=" + id + ", securitynumber=" + securitynumber
				+ ", securitypassword=" + securitypassword + ", username="
				+ username + "]";
	}
	


}
