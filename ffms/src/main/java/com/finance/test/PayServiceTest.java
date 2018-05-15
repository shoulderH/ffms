package com.finance.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;

import com.finance.service.PayService;
import com.finance.service.UserService;
import com.finance.test.JUnitServiceBase;
import com.finance.vo.Pay;

public class PayServiceTest extends JUnitServiceBase {
	@Resource
	private PayService payService;
	@Test
	public void addPay(){
		Pay pay=new Pay("fj1", "3", 3, "3");
		payService.addPay(pay);
	}
	@Test
	public void getPayLine(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("payer", "fj1");
		map.put("starttime", "2018-04-01 12:00:00");
		map.put("endtime", "2018-04-20 12:00:00");
		List<Pay> lists=payService.getPayLine(map);
		if(lists!=null){
//			System.out.println(lists.toString());
			for(Pay pay:lists){
				System.out.println(pay.toString());
			}
		}
	}
	
	@Test
	public void getSourceTypeTest(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("payer", "fj1");
		List<String> lists=payService.getSourceType(map);
		System.out.println(lists);
	}
	@Test
	public void getTimeTest(){
		List<String> lists=payService.getTime();
		System.out.println(lists);
	}
}
