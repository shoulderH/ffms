package com.finance.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.finance.dao.SecurityDao;
import com.finance.service.SecurityService;
import com.finance.service.TradeService;
import com.finance.vo.Security;
import com.finance.vo.Trade;

public class TradeTest extends JUnitServiceBase {
	@Resource
	TradeService tradeService;
	@Resource
	SecurityService securityService;
	
	
	
	
	@Test
	public void findTradeBySecurityId(){
		Map<String, Object> mapSecurity = new HashMap<String, Object>();
//		mapSecurity.put("securitynumber", "111");
//		mapSecurity.put("securitypassword", "1111");
		mapSecurity.put("username", "fj6");
		List<Security> listSecurity=securityService.findSecurity(mapSecurity);
		System.out.println("这边先打出："+listSecurity.toString());
		
//		map.put("starttime","2018-04-09 18:59:14");
//		map.put("endtime", "2018-04-12 19:00:33");
		for(int i=0;i<listSecurity.size();i++){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("securityid", listSecurity.get(i).getId());
			List<Trade> lists=tradeService.findTradeBySecurityId(map);
			System.out.println("=============="+lists.toString());
		}
	}
	@Test
	public void findTradeBySecurityIdTest(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("securityid", 22);
		List<Trade> lists=tradeService.findTradeBySecurityId(map);
		System.out.println("=============="+lists.toString());
	}
	@Test
	public void updateTradeTest(){
		Trade trade=new Trade();
		trade.setTradeid(1);
		trade.setNumber(2);
		trade.setPrice(2);
		trade.setMoney(4);
		int i=tradeService.updateTrade(trade);
		System.out.println(i);
	}

	@Test
	public void addTradeTest(){
		Trade trade=new Trade();
		trade.setSecurityid(1);
		trade.setNumber(2);
		trade.setPrice(2);
		trade.setMoney(4);
		trade.setSource("买入");
		trade.setTradetime("2018-04-22 13:33:16");
		int i=tradeService.addTrade(trade);
		System.out.println(i);
	}
}
