package com.finance.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.finance.core.des.DESUtils;
import com.finance.model.IncomeAndPay;
import com.finance.service.IncomeService;
import com.finance.service.PayService;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;
import com.finance.vo.Income;
import com.finance.vo.PageBean;
import com.finance.vo.Pay;
import com.finance.vo.User;

/**
 * 系统管理员Controller层
 * @author HZX
 *
 */
@Controller
public class AdminController {
	@Resource
	private IncomeService incomeService;
	
	@Resource
	private UserService userService;
	
	@Resource
	private PayService payService;
	/**
	 * 地域财政经济
	 * @param map
	 * @param request
	 * @return
	 */
	@RequestMapping("/regionalFinance.do")
	public String regionalFinance(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		return "regionalFinance";
	}
	@RequestMapping("/getFinanceData.do")
	public String getFinanceData(HttpServletResponse response){
		System.out.println("======有到后台");
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
		JSONArray jsonArray = JSONArray.fromObject(incomeAndPayLists);
		ResponseUtil.write(response, jsonArray.toString());
		return null;
	}
	/**
	 * 家庭成员关系
	 * @param map
	 * @param request
	 * @return
	 */
	@SuppressWarnings("null")
	@RequestMapping("/relationFamily.do")
	public String relationFamily(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		Map<String, Object> manageMap = new HashMap<String, Object>();
		//获取所有的管理员信息
		List<User> manageList=userService.findManage(manageMap);
		map.addAttribute("manageLists",manageList );
		List<String> managelists=new ArrayList<String>();
		//只取出管理员的用户名
		for(int i=0;i<manageList.size();i++){
			managelists.add(manageList.get(i).getUsername());
		}
		map.addAttribute("magUsernameLists",managelists );
		return "relationFamily";
	}
	/**
	 * 分配管理员
	 * @param map
	 * @param request
	 * @return
	 */
	@RequestMapping("/distributeManage.do")
	public String distributeManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		return "distributeManage";
	}
	/**
	 * 管理员列表
	 * @param page
	 * @param rows
	 * @param s_user
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/managelist.do")
	public String list(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "rows", required = false) String rows, User s_user, HttpServletResponse response)
			throws Exception {
		PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
		Map<String, Object> map = new HashMap<String, Object>();
		//直接输出全部的管理员列表
		if(s_user.getUsername()!=null){
			map.put("username", StringUtil.formatLike(s_user.getUsername()));
			map.put("truename", StringUtil.formatLike(s_user.getTruename()));
			map.put("sex", s_user.getSex());
		}
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<User> manageList =null;
		try {
			 manageList = userService.findManage(map);
		} catch (Exception e) {
			System.out.println("查找失败");
		}
		for(int i = 0; i < manageList.size(); i++) {
			manageList.get(i).setPassword(DESUtils.getDecryptString(manageList.get(i).getPassword()));
        }
		JSONObject result = new JSONObject();
		JSONArray jsonArray = JSONArray.fromObject(manageList);
		result.put("rows", jsonArray);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/addmanage.do")
	public String addmanage(User user, HttpServletResponse response) throws Exception {
		user.setPassword(DESUtils.getEncryptString(user.getPassword()));
		int resultTotal=0;
		JSONObject result = new JSONObject();
		if(!userService.getUserIsExists(user)){
			try {
				user.setManageid(userService.getMaxManageID()+1);
				user.setAppellation("管理员");
				 resultTotal = userService.addManage(user);
			} catch (Exception e) {
				System.out.println("插入数据库失败");
			}
		}
		if (resultTotal > 0) { // 执行成功
			result.put("errres", true);
			result.put("errmsg", "数据保存成功！");
		} else {
			result.put("errres", false);
			result.put("errmsg", "数据保存失败");
		}
		ResponseUtil.write(response, result);
		return null;
	}
}
