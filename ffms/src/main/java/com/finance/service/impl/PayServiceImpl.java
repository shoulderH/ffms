package com.finance.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.finance.dao.PayDao;
import com.finance.vo.Pay;
import com.finance.service.PayService;
import com.finance.util.DateUtil;

/**
 * 支出Service实现类
 * 
 * @author Administrator
 */
@Service("payService")
public class PayServiceImpl implements PayService{
	@Resource
	private PayDao payDao;

	
	public List<Pay> findPay(Map<String, Object> map) {
		return payDao.findPay(map);
	}
	
	
	public List<Pay> getPayLine(Map<String,Object> map){
		return payDao.getPayLine(map);
	}

	
	public long getTotalPay(Map<String, Object> map) {
		return payDao.getTotalPay(map);
	}

	
	public int updatePay(Pay pay) {
//		pay.setUpdatetime(DateUtil.getCurrentDateStr());
		return payDao.updatePay(pay);
	}

	
	public int addPay(Pay pay) {
		return payDao.addPay(pay);
	}

	
	public void deletePay(Pay pay) {
		payDao.deletePay(pay);
	}
	
	
	public List<Pay> getPayer(){
		return payDao.getPayer();
	}


	public List<String> getSourceType(Map<String, Object> map) {
		return payDao.getSourceType(map);
	}


	public List<String> getTime() {
		return payDao.getTime();
	}


}
