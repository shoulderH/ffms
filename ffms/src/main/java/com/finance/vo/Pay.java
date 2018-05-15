/*
 * Copyright (c) 2005, 2018, EVECOM Technology Co.,Ltd. All rights reserved.
 * EVECOM PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */
package com.finance.vo;

/**
 * 支出实体
 * 
 * @author Oli Hong
 * @created 2018年1月3日 上午10:52:11
 */
public class Pay {
	private Integer id;
	private String payer;
	private String source;
	private Integer money;
	private String paytime;
	private String starttime;// 搜索起始时间
	private String endtime;// 搜索截止时间

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getPayer() {
		return payer;
	}

	public void setPayer(String payer) {
		this.payer = payer;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public Integer getMoney() {
		return money;
	}

	public void setMoney(Integer money) {
		this.money = money;
	}

	public Pay() {
		super();
	}

	public String getPaytime() {
		return paytime;
	}

	public void setPaytime(String paytime) {
		this.paytime = paytime;
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

	public Pay(String payer, String source, Integer money, String paytime) {
		super();
		this.payer = payer;
		this.source = source;
		this.money = money;
		this.paytime = paytime;
	}

	@Override
	public String toString() {
		return "Pay [id=" + id + ", payer=" + payer + ", source=" + source
				+ ", money=" + money + ", paytime=" + paytime + ", starttime="
				+ starttime + ", endtime=" + endtime + "]";
	}



}
