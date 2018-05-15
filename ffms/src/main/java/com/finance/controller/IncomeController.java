package com.finance.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.finance.vo.Income;
import com.finance.vo.PageBean;
import com.finance.vo.User;
import com.finance.service.IncomeService;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 收入Controller层
 * @author HZX
 *
 */
@Controller
public class IncomeController {
	@Resource
	private IncomeService incomeService;
	@Resource
	private UserService userService;



	/**
	 * 收入信息管理页面
	 */
	@RequestMapping("/incomeManage.do")
	public String incomeManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.addAttribute("s_username",curuser.getUsername() );
		if(curuser.getAppellation().equals("管理员")){
//			Map<String, Object> userMap = new HashMap<String, Object>();
//			userMap.put("userid", curuser.getId());
//			List<User> userlist = userService.getAllUser(userMap);
//			map.addAttribute("allUsers", userlist);
			return "magincomeManage";
		}
		return "incomeManage";
	}

	/**
	 * 查询用户收入集合
	 * 
	 * @param page
	 * @param rows
	 * @param s_income
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	@RequestMapping("/incomelist.do")
	public String list(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "rows", required = false) String rows,
			@RequestParam(value = "manageid", required = false) int manageid,
			@RequestParam(value = "appellation", required = false) String appellation,
			Income s_income, HttpServletResponse response)
			throws Exception {
		PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
		Map<String, Object> map = new HashMap<String, Object>();
		List<Income> incomeLists =new ArrayList<Income>();
		if(appellation==null||appellation.equals("")){
			map.put("incomer", StringUtil.formatLike(s_income.getIncomer()));
			map.put("source", StringUtil.formatLike(s_income.getSource()));
			map.put("money", s_income.getMoney());
			map.put("incometime", s_income.getIncometime());
			map.put("starttime", s_income.getStarttime());
			map.put("endtime", s_income.getEndtime());
			map.put("start", pageBean.getStart());
			map.put("size", pageBean.getPageSize());
			 try {
				 incomeLists = incomeService.findIncome(map);
			} catch (Exception e) {
				System.out.println("查找失败");
			}
		}else{
			Map<String, Object> manageMap = new HashMap<String, Object>();
			manageMap.put("manageid",manageid);
			List<User> userList=userService.findUser(manageMap);
			//要搜索时
			if(s_income.getIncomer()==null||s_income.getIncomer().equals("")){
				for(int i=0;i<userList.size();i++){
					map.put("incomer", userList.get(i).getUsername());
					map.put("source", StringUtil.formatLike(s_income.getSource()));
					map.put("money", s_income.getMoney());
					map.put("incometime", s_income.getIncometime());
					map.put("starttime", s_income.getStarttime());
					map.put("endtime", s_income.getEndtime());
					List<Income> incomeList=incomeService.findIncome(map);
					incomeLists.addAll(incomeList);
				}
			
			}else{
				for(int i=0;i<userList.size();i++){
					if(s_income.getIncomer().equals(userList.get(i).getUsername())){
						map.put("incomer", s_income.getIncomer());
						map.put("source", StringUtil.formatLike(s_income.getSource()));
						map.put("money", s_income.getMoney());
						map.put("incometime", s_income.getIncometime());
						map.put("starttime", s_income.getStarttime());
						map.put("endtime", s_income.getEndtime());
						incomeLists=incomeService.findIncome(map);
						break;
					}
					//不相等就没有变化原样输出
				}
			}
			
		}
		JSONObject result = new JSONObject();
		JSONArray jsonArray = JSONArray.fromObject(incomeLists);
		result.put("rows", jsonArray);
		ResponseUtil.write(response, result);
		return null;
	}

	/**
	 * 添加与修改用户
	 * 
	 * @param income
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/incomesave.do")
	public String save(@RequestParam(value = "mark") int mark,Income income, HttpServletResponse response) throws Exception {
		int resultTotal = 0; // 操作的记录条数
		JSONObject result = new JSONObject();
		
		if (mark == 1) {
			resultTotal = incomeService.addIncome(income);
		} else {
			 incomeService.deleteIncome(income);
			 resultTotal =incomeService.addIncome(income);
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

	/**
	 * 删除用户
	 * 
	 * @param ids
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/incomedelete.do")
	public String delete(@RequestParam(value = "incomers") String incomers,
			@RequestParam(value = "incometimes") String incometimes,
			HttpServletResponse response) throws Exception {
		JSONObject result = new JSONObject();
		String[] incomerStr = incomers.split(",");
		String[] incometimeStr = incometimes.split(",");
		for (int i = 0; i < incomerStr.length; i++) {
			Income income=new Income();
			income.setIncomer(incomerStr[i]);
			income.setIncometime(incometimeStr[i]);
			incomeService.deleteIncome(income);
		}
		result.put("errres", true);
		result.put("errmsg", "数据删除成功！");
		ResponseUtil.write(response, result);
		return null;
	}

}
