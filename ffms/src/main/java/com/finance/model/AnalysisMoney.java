package com.finance.model;

public class AnalysisMoney {
private String linetime;  //时间
private int personmoney;  //家庭成员平均金额
private int avgmoney;     //所有用户的平均金额
public String getLinetime() {
	return linetime;
}
public void setLinetime(String linetime) {
	this.linetime = linetime;
}
public int getPersonmoney() {
	return personmoney;
}
public void setPersonmoney(int personmoney) {
	this.personmoney = personmoney;
}
public int getAvgmoney() {
	return avgmoney;
}
public void setAvgmoney(int avgmoney) {
	this.avgmoney = avgmoney;
}
public AnalysisMoney() {
	super();
	// TODO Auto-generated constructor stub
}
public AnalysisMoney(String linetime, int personmoney, int avgmoney) {
	super();
	this.linetime = linetime;
	this.personmoney = personmoney;
	this.avgmoney = avgmoney;
}
@Override
public String toString() {
	return "AnalysisMoney [linetime=" + linetime + ", personmoney="
			+ personmoney + ", avgmoney=" + avgmoney + "]";
}

}
