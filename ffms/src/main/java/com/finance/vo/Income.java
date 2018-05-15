/*
 * Copyright (c) 2005, 2018, EVECOM Technology Co.,Ltd. All rights reserved.
 * EVECOM PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */
package com.finance.vo;

/**
 * 收入实体
 * 
 * @author Oli Hong
 * @created 2018年1月5日 上午10:52:29
 */
public class Income {
	private Integer id;
	private String incomer;
	private String source;
	private int money;
	private String incometime;
	private String starttime;// 搜索起始时间
	private String endtime;// 搜索截止时间
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	public String getIncomer() {
		return incomer;
	}

	public void setIncomer(String incomer) {
		this.incomer = incomer;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public int getMoney() {
		return money;
	}

	public void setMoney(int money) {
		this.money = money;
	}

	public String getIncometime() {
		return incometime;
	}

	public void setIncometime(String incometime) {
		this.incometime = incometime;
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

	public Income() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Income(String incomer, String source, int money, String incometime) {
		super();
		this.incomer = incomer;
		this.source = source;
		this.money = money;
		this.incometime = incometime;
	}

	@Override
	public String toString() {
		return "Income [incomer=" + incomer + ", source=" + source + ", money="
				+ money + ", incometime=" + incometime + "]";
	}

}
