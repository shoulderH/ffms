package com.finance.dao;

import java.util.List;
import java.util.Map;

import com.finance.vo.Security;
import com.finance.vo.Trade;


public interface TradeDao {
	
	/**
	 * 查询收入
	 * @param map
	 * @return
	 */
//	public List<Security> findTrade(Security security);
	
	/**
	 * 获取收入记录数
	 * @param map
	 * @return
	 */
	public Long getTotalTrade(Map<String,Object> map);
	
	/**
	 * 更新收入
	 * @param tarde
	 * @return
	 */
	public int updateTrade(Trade  trade);
	
	/**
	 * 添加收入
	 * @param trade
	 * @return
	 */
	public int addTrade(Trade  trade);
	
	
	/**
	 * 删除收入
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
