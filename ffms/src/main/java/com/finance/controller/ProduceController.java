package com.finance.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.finance.vo.Income;
import com.finance.vo.Pay;
import com.finance.vo.User;
import com.finance.model.AnalysisMoney;
import com.finance.model.IncomeAndPay;
import com.finance.service.IncomeService;
import com.finance.service.PayService;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 报表Controller层
 * @author HZX
 *
 */
@Controller
public class ProduceController {
	@Resource
	private UserService userService;
	@Resource
	private IncomeService incomeService;
	
	@Resource
	private PayService payService;
	/**
	 * 家庭分析报表
	 * @param map
	 * @param request
	 * @return
	 */
	@RequestMapping("/analysisMange.do")
	public String analysisMange(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.addAttribute("c_username",curuser.getUsername() );
		return "analysisMange";
	}
	@RequestMapping("/getAnalysisData.do")
	public String getAnalysisData(@RequestParam(value = "manageid", required = false) int manageid, HttpServletResponse response) {
		List<AnalysisMoney> anlysisMLists=new ArrayList<AnalysisMoney>();
		List<String> timeList=payService.getTime();
		Map<String, Object> allusermap = new HashMap<String, Object>();
		//返回所有的用户数量，扣除系统管理员
		int alluserCounts=userService.getCounts(allusermap)-1;
		System.out.println("所有用户的数量："+alluserCounts);
		Map<String, Object> usermap = new HashMap<String, Object>();
		usermap.put("manageid", manageid);
		//返回该管理号的所有用户名
		List<User> userList=userService.findUser(usermap);
		//返回该管理号的用户数量
		int userCounts=userService.getCounts(usermap);
		for(int i=0;i<timeList.size();i++){
			//当天该管理号所有用户的支出
			int totalPayMoney=0;
			//当天该管理号所有用户的收入
			int totalIncomeMoney=0;
			for(int j=0;j<userList.size();j++){
				Map<String, Object> paymap = new HashMap<String, Object>();
				paymap.put("payer", userList.get(j).getUsername());
				paymap.put("starttime", timeList.get(i)+" 00:00:00");
				paymap.put("endtime",  timeList.get(i)+" 23:59:59");
				List<Pay> payList=payService.findPay(paymap);
				for(int k=0;k<payList.size();k++){
					totalPayMoney+=payList.get(k).getMoney();
				}
				Map<String, Object> incomemap = new HashMap<String, Object>();
				incomemap.put("incomer", userList.get(j).getUsername());
				incomemap.put("starttime", timeList.get(i)+" 00:00:00");
				incomemap.put("endtime",  timeList.get(i)+" 23:59:59");
				List<Income> incomeList=incomeService.findIncome(incomemap);
				for(int m=0;m<incomeList.size();m++){
					totalIncomeMoney+=incomeList.get(m).getMoney();
				}
			}
			//当天所有用户的支出
			int alltotalPayMoney=0;
			//当天所有用户的收入
			int alltotalIncomeMoney=0;
			Map<String, Object> allpaymap = new HashMap<String, Object>();
			allpaymap.put("starttime", timeList.get(i)+" 00:00:00");
			allpaymap.put("endtime",  timeList.get(i)+" 23:59:59");
			List<Pay> allpayList=payService.findPay(allpaymap);
			for(int k=0;k<allpayList.size();k++){
				alltotalPayMoney+=allpayList.get(k).getMoney();
			}
			Map<String, Object> allincomemap = new HashMap<String, Object>();
			allincomemap.put("starttime", timeList.get(i)+" 00:00:00");
			allincomemap.put("endtime",  timeList.get(i)+" 23:59:59");
			List<Income> allincomeList=incomeService.findIncome(allincomemap);
			for(int k=0;k<allincomeList.size();k++){
				alltotalIncomeMoney+=allincomeList.get(k).getMoney();
			}
			AnalysisMoney analysisMoney=new AnalysisMoney();
			analysisMoney.setLinetime(timeList.get(i));
			analysisMoney.setPersonmoney((totalIncomeMoney-totalPayMoney)/userCounts);
			analysisMoney.setAvgmoney((alltotalIncomeMoney-alltotalPayMoney)/alluserCounts);
			anlysisMLists.add(analysisMoney);
			
		}
		System.out.println("======打印："+anlysisMLists.toString());
		JSONArray jsonArray = JSONArray.fromObject(anlysisMLists);
		ResponseUtil.write(response, jsonArray.toString());
		return null;
	}
	/**
	 * （时间-金额）收入曲线页面
	 * @return
	 */
	@RequestMapping("/incomeTimeManage.do")
	public String incomeTimeManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.addAttribute("c_username",curuser.getUsername() );
		if(curuser.getAppellation().equals("管理员")){
			return "magincomeTimeManage";
		}
		return "incomeTimeManage";
	}
	
/**
 * 生成收入曲线
 * @param s_income
 * @param response
 * @return
 */
	@RequestMapping("/produceIncomeTime.do")
	public String produceIncomeTime(Income s_income, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("incomer", StringUtil.formatLike(s_income.getIncomer()));
		map.put("starttime", s_income.getStarttime());
		map.put("endtime", s_income.getEndtime());
		List<Income> incomeList = incomeService.getIncomeLine(map);
		List<Income> incomers = incomeService.getIncomer();
		
		String curincomer;
		JSONArray incomeArray,obj;
		JSONObject result;
		
		JSONArray outerobj = new JSONArray();
		for(int i=0;i<incomers.size();i++){
			curincomer = incomers.get(i).getIncomer();
			incomeArray = new JSONArray();
			for(int j = 0; j < incomeList.size(); j++) {
				obj = new JSONArray();
				if(incomeList.get(j).getIncomer().equals(curincomer)){
					obj.add(incomeList.get(j).getIncometime());
					obj.add(incomeList.get(j).getMoney());
					incomeArray.add(obj);
				}
	        }
			if(incomeArray.size()>0){
				result = new JSONObject();
				result.put("name", curincomer);
				result.put("data", incomeArray);
				outerobj.add(result);
			}
		}
		ResponseUtil.write(response, outerobj);
		return null;
	}
	
	
	/**
	 * （时间-金额）支出曲线页面
	 * @return
	 */
	@RequestMapping("/payTimeManage.do")
	public String payTimeManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.addAttribute("c_username",curuser.getUsername() );
		if(curuser.getAppellation().equals("管理员")){
			return "magpayTimeManage";
		}
		return "payTimeManage";
	}
	
	/**
	 * （时间-金额）生成支出曲线
	 * @param s_pay
	 * @param response
	 * @return
	 */
	@RequestMapping("/producePayTime.do")
	public String producePayLine(Pay s_pay, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("payer", StringUtil.formatLike(s_pay.getPayer()));
		map.put("starttime", s_pay.getStarttime());
		map.put("endtime", s_pay.getEndtime());
		List<Pay> payList = payService.getPayLine(map);
		List<Pay> payers = payService.getPayer();
		
		String curpayer;
		JSONArray payArray,obj;
		JSONObject result;
		
		JSONArray outerobj = new JSONArray();
		for(int i=0;i<payers.size();i++){
			curpayer = payers.get(i).getPayer();
			payArray = new JSONArray();
			for(int j = 0; j < payList.size(); j++) {
				obj = new JSONArray();
				if(payList.get(j).getPayer().equals(curpayer)){
					obj.add(payList.get(j).getPaytime());
					obj.add(payList.get(j).getMoney());
					payArray.add(obj);
				}
	        }
			if(payArray.size()>0){
				result = new JSONObject();
				result.put("name", curpayer);
				result.put("data", payArray);
				outerobj.add(result);
			}
		}
		ResponseUtil.write(response, outerobj);
		return null;
	}
	
	/**
	 * 用户收入情况比较
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/moneyAnalysis.do")
	public String moneyAnalysis(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		HttpSession session = request.getSession();
		User curUser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.put("username", curUser.getUsername());
		List<Income> incomeList = incomeService.getIncomeLine(map);
		List<Pay> payList = payService.getPayLine(map);
		
		JSONObject result = new JSONObject();
		int totalIncomeMoney=0,totalPayMoney=0,totalLostMoney=0;
		
		for(int i = 0; i < incomeList.size(); i++) {
			if(incomeList.get(i).getIncomer().equals(curUser.getUsername())){
				totalIncomeMoney = totalIncomeMoney+incomeList.get(i).getMoney();
	        }
		}
		for(int j = 0; j < payList.size(); j++) {
			if(payList.get(j).getPayer().equals(curUser.getUsername())){
				totalPayMoney = totalPayMoney+payList.get(j).getMoney();
	        }
		}
		totalLostMoney = totalIncomeMoney-totalPayMoney;
		
		result.put("totalIncomeMoney", totalIncomeMoney);
		result.put("totalPayMoney", totalPayMoney);
		result.put("totalLostMoney", totalLostMoney);
		ResponseUtil.write(response, result);
		return null;
	}
	
	/**
	 * （类型-金额）饼图页面
	 * @return
	 */
	@RequestMapping("/typePieManage.do")
	public String typePieManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.addAttribute("c_username",curuser.getUsername() );
		if(curuser.getAppellation().equals("管理员")){
			return "magtypePieManage";
		}
		return "typePieManage";
	}
	
	/**
	 * （类型-金额）生成收入饼图
	 * @param s_income
	 * @param response
	 * @return
	 */
	@RequestMapping("/produceIncomeType.do")
	public String produceIncomeType(Income s_income, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("incomer", StringUtil.formatLike(s_income.getIncomer()));
		map.put("starttime", s_income.getStarttime());
		map.put("endtime", s_income.getEndtime());
		List<Income> incomeList = incomeService.getIncomeLine(map);
		List<String> incomeTypes = incomeService.getSourceType(map);
		
		JSONArray incomeArray = new JSONArray(),obj;
		JSONObject result = new JSONObject();
		Integer incomeMoney,totalIncomeMoney=0;
		
		for(int k = 0; k < incomeList.size(); k++) {
			totalIncomeMoney = totalIncomeMoney + incomeList.get(k).getMoney();
		}
		
		for (int i = 0; i < incomeTypes.size(); i++) {
			obj = new JSONArray();
			incomeMoney=0;
			for(int j = 0; j < incomeList.size(); j++) {
				if(incomeList.get(j).getSource().equals(incomeTypes.get(i))){
					incomeMoney = incomeMoney + incomeList.get(j).getMoney();
				}
		    }
			obj.add(incomeTypes.get(i)+"："+(double)Math.round(10000*incomeMoney/totalIncomeMoney)/100+"%");
			obj.add(incomeMoney);
			incomeArray.add(obj);
		}
			
		result.put("name", "(类型——金额)收入饼状图");
		result.put("data", incomeArray);
		ResponseUtil.write(response, result);
		return null;
	}
	
	/**
	 * （类型-金额）生成支出饼图
	 * @param s_pay
	 * @param response
	 * @return
	 */
	@RequestMapping("/producePayType.do")
	public String producePayType(Pay s_pay, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("payer", StringUtil.formatLike(s_pay.getPayer()));
		map.put("starttime", s_pay.getStarttime());
		map.put("endtime", s_pay.getEndtime());
		List<Pay> payList = payService.getPayLine(map);
		List<String> payTypes = payService.getSourceType(map);
		
		JSONArray payArray = new JSONArray(),obj;
		JSONObject result = new JSONObject();
		Integer payMoney,totalPayMoney=0;
		
		for(int k = 0; k < payList.size(); k++) {
			totalPayMoney = totalPayMoney + payList.get(k).getMoney();
		}
		
		for (int i = 0; i < payTypes.size(); i++) {
			obj = new JSONArray();
			payMoney=0;
			for(int j = 0; j < payList.size(); j++) {
				if(payList.get(j).getSource().equals(payTypes.get(i))){
					payMoney = payMoney + payList.get(j).getMoney();
				}
		    }
			obj.add(payTypes.get(i)+"："+(double)Math.round(10000*payMoney/totalPayMoney)/100+"%");
			obj.add(payMoney);
			payArray.add(obj);
		}
			
		result.put("name", "(类型——金额)支出饼状图");
		result.put("data", payArray);
		ResponseUtil.write(response, result);
		return null;
	}
	/**
	 * 家庭简况
	 * @return
	 */
	@RequestMapping("/familyBrief.do")
	public String familyBrief() {
		return "familyBrief";
	}
	@RequestMapping("/brieflist.do")
	public String briefList(@RequestParam(value = "manageid", required = false) int manageid,
			@RequestParam(value = "appellation", required = false) String appellation,
			Income s_income, HttpServletResponse response) {
		List<IncomeAndPay> incomeAndPayLists=new ArrayList<IncomeAndPay>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("manageid", manageid);
		List<User> userList=userService.findUser(map);
		//根据管理员id号查找对应的所有的用户名
		for(int i=0;i<userList.size();i++){
			Map<String, Object> incomemap = new HashMap<String, Object>();
			incomemap.put("incomer", userList.get(i).getUsername());
			List<Income> incomeList=incomeService.findIncome(incomemap);
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
		JSONArray jsonArray = JSONArray.fromObject(incomeAndPayLists);
		ResponseUtil.write(response, jsonArray.toString());
		return null;
	}
}
