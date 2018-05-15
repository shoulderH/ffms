/*
 * Copyright (c) 2005, 2018, EVECOM Technology Co.,Ltd. All rights reserved.
 * EVECOM PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */
package com.finance.vo;

import java.util.List;

/**
 * 用户实体
 * 
 * @author Oli Hong
 * @created 2018年1月2日 下午3:47:51
 */
public class User {
	/**
	 * 用户名（唯一）
	 */
	private String username;
	/**
	 * 密码
	 */
	private String password;
	/**
	 * 真实姓名
	 */
	private String truename;
	/**
	 * 邮箱
	 */
	private String email;
	/**
	 * 省份
	 */
	private String province;
	/**
	 * 城市
	 */
	private String city;
	/**
	 * 乡县
	 */
	private String county;
	/**
	 * 性别
	 */
	private String sex;
	/**
	 * 身份
	 */
	private String appellation;
	/**
	 * 管理员id号
	 */
	private Integer manageid;
	/**
	 * 是否注册
	 */
	private Integer isvalid;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getTruename() {
		return truename;
	}

	public void setTruename(String truename) {
		this.truename = truename;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCounty() {
		return county;
	}

	public void setCounty(String county) {
		this.county = county;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getAppellation() {
		return appellation;
	}

	public void setAppellation(String appellation) {
		this.appellation = appellation;
	}

	public User(String username, String password, String truename,
			String email, String province, String city, String county,
			String sex, String appellation, Integer manageid, Integer isvalid) {
		super();
		this.username = username;
		this.password = password;
		this.truename = truename;
		this.email = email;
		this.province = province;
		this.city = city;
		this.county = county;
		this.sex = sex;
		this.appellation = appellation;
		this.manageid = manageid;
		this.isvalid = isvalid;
	}

	public Integer getManageid() {
		return manageid;
	}

	public void setManageid(Integer manageid) {
		this.manageid = manageid;
	}

	public Integer getIsvalid() {
		return isvalid;
	}

	public void setIsvalid(Integer isvalid) {
		this.isvalid = isvalid;
	}

	

	public User() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return "User [username=" + username + ", password=" + password
				+ ", truename=" + truename + ", email=" + email + ", province="
				+ province + ", city=" + city + ", county=" + county + ", sex="
				+ sex + ", appellation=" + appellation + ", manageid="
				+ manageid + ", isvalid=" + isvalid + "]";
	}

}
