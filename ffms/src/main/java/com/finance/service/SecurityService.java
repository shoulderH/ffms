package com.finance.service;

import java.util.List;
import java.util.Map;

import com.finance.vo.Security;

public interface SecurityService {
	/**
	 * 查询账户
	 * @param map
	 * @return
	 */
	public List<Security> findSecurity(Map<String,Object> map);
	
	/**
	 * 获取账户记录数
	 * @param map
	 * @return
	 */
	public Long getTotalSecurity(Map<String,Object> map);
	
	/**
	 * 更新账户
	 * @param security
	 * @return
	 */
	public int updateSecurity(Security security);
	
	/**
	 * 添加账户
	 * @param security
	 * @return
	 */
	public int addSecurity(Security security);
	
	
	/**
	 * 删除账户
	 * @param security
	 * @return
	 */
	public void deleteSecurity(Security security);
	/**
	 * 获得所有用户
	 * @return
	 */
	public List<Security> getAllSecurity();
	/**
	 * 根据证券的账号和用户名查看是否存在
	 * @param security
	 * @return
	 */
	public boolean getIsExistSecurity(Security security);
}
