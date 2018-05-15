/**
 * 
 */
package com.finance.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;

import com.finance.service.IncomeService;
import com.finance.util.StringUtil;
import com.finance.vo.Income;

/**
 * @author HZX
 *
 */
public class IncomeServiceTest extends JUnitServiceBase {
	@Resource
	IncomeService incomeService;
	@Test
	public void getIncomeLine(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("incomer", "fj2");
		List<Income> lists=incomeService.getIncomeLine(map);
		System.out.println(lists.toString());
	}
	@Test
	public void deleteIncome(){
		Income income=new Income();
		income.setIncomer("fj2");
		income.setIncometime("2018-04-01 11:52:35");
		incomeService.deleteIncome(income);
		System.out.println("==");
	}
	@Test
	public void insertIncome(){
		Income income=new Income();
		income.setIncomer("fj2");
		income.setMoney(10);
		income.setSource("aaa");
		income.setIncometime("2018-04-17 12:10:40");
		int total=incomeService.addIncome(income);
		System.out.println("=="+total);
	}
	@Test
	public void updateIncome(){
		Income income=new Income();
		income.setIncomer("fj2");
		income.setMoney(20);
		income.setSource("bbb");
		income.setIncometime("2018-04-17 12:10:40");
		int total=incomeService.updateIncome(income);
		System.out.println("=="+total);
	}
	@Test
	public void findIncome(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("incomer", StringUtil.formatLike(""));
		map.put("source", StringUtil.formatLike(""));
		map.put("incometime", "");
		map.put("starttime", "");
		map.put("endtime", "");
		map.put("start", 0);
		map.put("size", 10);
		List<Income> lists=incomeService.findIncome(map);
		System.out.println("==="+lists.toString()+"====");
	}
	@Test
	public void IncometimeManage(){
		List<Income> incomers = incomeService.getIncomer();
		for(int i=0;i<incomers.size();i++){
			String name=incomers.get(i).getIncomer();
			System.out.println(name);
		}
	}
	@Test
	public void getSourceTypeTest(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("incomer", "fj1");
		map.put("starttime", "2018-04-02 05:39:57");
		List<String> lists=incomeService.getSourceType(map);
		System.out.println(lists);
	}
	
}
