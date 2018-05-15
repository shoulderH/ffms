/**
 * 
 */
package com.finance.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;

import com.finance.service.IncomeService;
import com.finance.service.SecurityService;
import com.finance.util.StringUtil;
import com.finance.vo.Income;
import com.finance.vo.Security;

/**
 * @author HZX
 *
 */
public class SecurityServiceTest extends JUnitServiceBase {
	@Resource
	SecurityService securityService;
	@Test
	public void deleteIncome(){
		Security security=new Security();
		security.setSecuritynumber("777");
		security.setSecuritypassword("777");
		security.setUsername("fj1");
		securityService.deleteSecurity(security);
		System.out.println("==");
	}
	@Test
	public void getIsExistSecurity(){
		Security security=new Security();
		security.setSecuritynumber("111");
		security.setUsername("fj1");
		boolean bl=securityService.getIsExistSecurity(security);
		System.out.println(bl);
	}
	
}
