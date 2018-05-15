package com.finance.dao;

import java.util.List;
import java.util.Map;

import com.finance.vo.Pay;

public interface PayDao {
	/**
	 * 查询支出
	 * @param map
	 * @return
	 */
	public List<Pay> findPay(Map<String, Object> map);
	
	/**
	 * 报表生成获得支出曲线数据
	 * @param map
	 * @return
	 */
	public List<Pay> getPayLine(Map<String,Object> map);

	/**
	 * 获取支出记录数
	 * @param map
	 * @return
	 */
	public long getTotalPay(Map<String, Object> map);
	
	/**
	 * 更新支出
	 * @param pay
	 * @return
	 */
	public int updatePay(Pay pay);
	
	/**
	 * 添加支出
	 * @param pay
	 * @return
	 */
	public int addPay(Pay pay);
	
	/**
	 * 删除支出
	 * @param id
	 * @return
	 */
	public void deletePay(Pay pay);
	
	/**
	 * 获得所有支出人
	 * @return
	 */
	public List<Pay> getPayer();
	/**
	 * 获取该用户支出的所有类型
	 * @param map
	 * @return
	 */
	public List<String> getSourceType(Map<String,Object> map);
	/**
	 * 获取格式化后的时间集合
	 * @return
	 */
	public List<String> getTime();

}
