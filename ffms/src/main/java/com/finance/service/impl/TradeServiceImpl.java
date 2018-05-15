package com.finance.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.finance.dao.TradeDao;
import com.finance.vo.Security;
import com.finance.vo.Trade;
import com.finance.service.TradeService;
import com.finance.util.DateUtil;

/**
 * 收入Service实现类
 * 
 * @author Administrator
 */
@Service("tradeService")
public class TradeServiceImpl implements TradeService{

	@Resource
	private TradeDao tradeDao;
	
	
//	public List<Security> findTrade(Security security) {
//		return tradeDao.findTrade(security);
//	}

	
	public Long getTotalTrade(Map<String, Object> map) {
		return tradeDao.getTotalTrade(map);
	}

	
	
	public int addTrade(Trade trade) {
		trade.setMoney(trade.getPrice()*trade.getNumber());
//		trade.setCreatetime(DateUtil.getCurrentDateStr());
		return tradeDao.addTrade(trade);
	}

	
	public int updateTrade(Trade trade) {
		trade.setMoney(trade.getPrice()*trade.getNumber());
//		trade.setUpdatetime(DateUtil.getCurrentDateStr());
		return tradeDao.updateTrade(trade);
	}

	
	public int deleteTrade(Integer id) {
		return tradeDao.deleteTrade(id);
	}



	public List<Trade> findTradeBySecurityId(Map<String,Object> map) {
		return tradeDao.findTradeBySecurityId(map);
	}


	

}
