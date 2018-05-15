/**
 * 
 */
package com.finance.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.junit.Test;

import com.finance.model.IncomeAndPay;
import com.finance.service.IncomeService;
import com.finance.service.PayService;
import com.finance.service.UserService;
import com.finance.util.StringUtil;
import com.finance.vo.Income;
import com.finance.vo.Pay;
import com.finance.vo.User;

/**
 * @author HZX
 *
 */
public class UserServiceTest extends JUnitServiceBase {
	@Resource
	private UserService userService;
	@Resource
	private IncomeService incomeService;
	@Resource
	private PayService payService;
	@Test
	public void getUserByName(){
		User user=userService.getUserByName("fj2");
		if(user==null||user.equals("")){
			System.out.println("为空");
		}else{
			System.out.println(user.toString());
		}
	}
	@Test
	public void addSignTest(){
		User user=new User();
		user.setUsername("zz");
		user.setPassword("zz");
		user.setProvince("21");
		user.setCity("21");
		user.setCounty("21");
		user.setSex("女");
		int total=userService.addSign(user);
		System.out.println(total);
	}
	@Test
	public void ExistUser(){
		User user=new User();
		user.setUsername("fj2");
		boolean bl=userService.getUserIsExists(user);
		System.out.println(bl);
	}
	@Test
	public void updateUser(){
		User user=new User();
		user.setUsername("fj1");
		user.setPassword("12313");
		user.setTruename("林佩");
		user.setEmail("4848@qq.com");
		user.setProvince("河南");
		user.setCity("周口");
		user.setCounty("扶沟县");
		user.setSex("男");
		user.setAppellation("");
		user.setManageid(null);
		user.setIsvalid(null);
		int count=userService.updateUser(user);
		System.out.println(count);
	}
	@Test
	public void findUserTest(){
		Map<String, Object> map = new HashMap<String, Object>();
		//模糊匹配
//		map.put("username", "%fj1%");
//		map.put("truename", null);
//		map.put("appellation", null);
//		map.put("sex", "");
//		map.put("manageid", 1);
//		map.put("start", 0);
//		map.put("size", 10);
		map.put("province", "福建");
		List<User> userList = userService.findUser(map);
		System.out.println(userList.toString());
	}
	@Test
	public void deleteUser(){
		userService.deleteUser("fj7");
		System.out.println("==");
	}
	
	@Test
	public void findManageTest(){
		Map<String, Object> map = new HashMap<String, Object>();
		//模糊匹配
//		map.put("username", StringUtil.formatLike("fj6"));
//		map.put("truename", StringUtil.formatLike(""));
//		map.put("appellation", "管理员");
//		map.put("sex", "");
//		map.put("manageid", null);
//		map.put("start", 0);
//		map.put("size", 10);
		List<User> manageList = userService.findManage(map);
		System.out.println(manageList.toString());
	}
	@Test
	public void getMaxMangeID(){
		int maxManageID=userService.getMaxManageID();
		System.out.println(maxManageID);
	}
	@Test
	public void addManageTest(){
		User user=new User();
		user.setUsername("zz");
		user.setPassword("zz");
		user.setSex("女");
		user.setTruename("zz");
		user.setEmail("123123@qq.com");
		user.setAppellation("管理员");
		user.setManageid(4);
		int total=userService.addManage(user);
		System.out.println(total);
	}
	@Test
	public void getRelationTest(){
		List<User> user=userService.getRelation(1);
		System.out.println(user.toString());
	}
	@Test
	public void getProvinceTest(){
		List<String> lists=userService.getProvince();
		System.out.println(lists.toString());
	}
	@Test
	public void getDataTest(){
		List<IncomeAndPay> incomeAndPayLists=new ArrayList<IncomeAndPay>();
		//获取存在的所有省份
		List<String> provinceList=userService.getProvince();
		for(int i=0;i<provinceList.size();i++){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("province", provinceList.get(i));
			//每个省份对应的所有人的用户信息
			List<User> userList = userService.findUser(map);
			int totalIncomeMoney=0;
			int totalPayMoney=0;
			//每个省份对应的所有人的姓名 userLists.get(i).getUsername()
			for(int j=0;j<userList.size();j++){
				Map<String, Object> incomemap = new HashMap<String, Object>();
				incomemap.put("incomer", userList.get(j).getUsername());
				//获取该用户名收入的所有信息
				List<Income> incomeList=incomeService.findIncome(incomemap);
				for(int m=0;m<incomeList.size();m++){
					totalIncomeMoney+=incomeList.get(m).getMoney();
				}
				
				Map<String, Object> paymap = new HashMap<String, Object>();
				paymap.put("payer", userList.get(j).getUsername());
				//获取该用户名支出的所有信息
				List<Pay> payList=payService.findPay(paymap);
				for(int m=0;m<payList.size();m++){
					totalPayMoney-=payList.get(m).getMoney();
				}
			}
			IncomeAndPay incomeandpay=new IncomeAndPay();
			incomeandpay.setC_anystring(map.get("province").toString());
			incomeandpay.setC_incomemoney(totalIncomeMoney);
			incomeandpay.setC_paymoney(totalPayMoney);
			incomeandpay.setC_totalmoney(totalIncomeMoney+totalPayMoney);
			incomeAndPayLists.add(incomeandpay);
		}
		System.out.println("==============="+incomeAndPayLists.toString());
	}
	
	
	@Test
	public void getFamilyBriefTest(){
		List<IncomeAndPay> incomeAndPayLists=new ArrayList<IncomeAndPay>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("manageid", 1);
		List<User> userList=userService.findUser(map);
		for(int i=0;i<userList.size();i++){
			Map<String, Object> incomemap = new HashMap<String, Object>();
			incomemap.put("incomer", userList.get(i).getUsername());
			List<Income> incomeList=incomeService.findIncome(map);
			int totalIncomeMoney=0;
			int totalPayMoney=0;
			for(int m=0;m<incomeList.size();m++){
				totalIncomeMoney+=incomeList.get(m).getMoney();
			}
			Map<String, Object> paymap = new HashMap<String, Object>();
			paymap.put("payer", userList.get(i).getUsername());
			List<Pay> payList=payService.findPay(paymap);
			for(int m=0;m<payList.size();m++){
				totalPayMoney+=payList.get(m).getMoney();
			}
			
			
			IncomeAndPay incomeandpay=new IncomeAndPay();
			incomeandpay.setC_anystring(userList.get(i).getAppellation());
			incomeandpay.setC_incomemoney(totalIncomeMoney);
			incomeandpay.setC_paymoney(totalPayMoney);
			incomeandpay.setC_totalmoney(totalIncomeMoney-totalPayMoney);
			incomeAndPayLists.add(incomeandpay);
		}
		System.out.println("==============="+incomeAndPayLists.toString());
	}
	@Test
	public void getCountsTest(){
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("manageid", 1);
		int counts=userService.getCounts(map);
		System.out.println(counts);
	}
}
