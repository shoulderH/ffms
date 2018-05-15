package com.finance.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.finance.dao.SecurityDao;
import com.finance.vo.Security;
import com.finance.service.SecurityService;
import com.finance.util.DateUtil;

/**
 * 收入Service实现类
 * 
 * @author Administrator
 */
@Service("securityService")
public class SecurityServiceImpl implements SecurityService{
	@Resource
	private SecurityDao securityDao;

	
	public List<Security> findSecurity(Map<String, Object> map) {
		return securityDao.findSecurity(map);
	}

	
	public Long getTotalSecurity(Map<String, Object> map) {
		return securityDao.getTotalSecurity(map);
	}

	
	public int updateSecurity(Security security) {
//		security.setUpdatetime(DateUtil.getCurrentDateStr());
		return securityDao.updateSecurity(security);
	}

	
	public int addSecurity(Security security) {
//		security.setCreatetime(DateUtil.getCurrentDateStr());
		return securityDao.addSecurity(security);
	}

	
	public void deleteSecurity(Security security) {
		 securityDao.deleteSecurity(security);
	}

	
	public List<Security> getAllSecurity() {
		return securityDao.getAllSecurity();
	}


	public boolean getIsExistSecurity(Security security) {
		return securityDao.getIsExistSecurity(security);
	}

}
