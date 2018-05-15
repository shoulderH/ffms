package com.finance.service;

import java.util.List;
import java.util.Map;

import com.finance.vo.Security;
import com.finance.vo.Trade;

public interface TradeService {
	/**
	 * 查询流水账
	 * @param map
	 * @return
	 */
//	public List<Security> findTrade(Security security);
	
	/**
	 * 获取流水账记录数
	 * @param map
	 * @return
	 */
	public Long getTotalTrade(Map<String,Object> map);
	
	/**
	 * 更新用户
	 * @param trade
	 * @return
	 */
	public int updateTrade(Trade  trade);
	
	/**
	 * 添加流水账
	 * @param trade
	 * @return
	 */
	public int addTrade(Trade  trade);
	
	
	/**
	 * 删除流水账
	 * @param id
	 * @return
	 */
	public int deleteTrade(Integer id);
	/**
	 * 根据证券id号查询流水信息
	 * @param securityid
	 * @return
	 */
	public  List<Trade> findTradeBySecurityId(Map<String,Object> map);

}
