package com.finance.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.finance.dao.IncomeDao;
import com.finance.vo.Income;
import com.finance.service.IncomeService;
import com.finance.util.DateUtil;

/**
 * 收入Service实现类
 * 
 * @author Administrator
 */
@Service("incomeService")
public class IncomeServiceImpl implements IncomeService{

	@Resource
	private IncomeDao incomeDao;
	
	public List<Income> findIncome(Map<String, Object> map) {
		return incomeDao.findIncome(map);
	}
	
	public List<Income> getIncomeLine(Map<String,Object> map){
		return incomeDao.getIncomeLine(map);
	}

	public Long getTotalIncome(Map<String, Object> map) {
		return incomeDao.getTotalIncome(map);
	}

	
	public int addIncome(Income income) {
//		income.setCreatetime(DateUtil.getCurrentDateStr());
		return incomeDao.addIncome(income);
	}

	public int updateIncome(Income income) {
//		income.setUpdatetime(DateUtil.getCurrentDateStr());
		return incomeDao.updateIncome(income);
	}

	public void deleteIncome(Income income) {
		 incomeDao.deleteIncome(income);
	}
	
	public List<Income> getIncomer(){
		return incomeDao.getIncomer();
	}

	public List<String> getSourceType(Map<String,Object> map) {
		return incomeDao.getSourceType(map);
	}

}
