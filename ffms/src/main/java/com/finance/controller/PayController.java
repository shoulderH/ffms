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
import com.finance.vo.Pay;
import com.finance.vo.User;
import com.finance.service.PayService;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 支出Controller层
 * @author HZX
 *
 */
@Controller
public class PayController {
	
	
	@Resource
	private PayService payService;
	@Resource
	private UserService userService;
	

	/**
	 * 支出信息管理页面
	 */
	@RequestMapping("/payManage.do")
	public String payManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		map.addAttribute("s_username",curuser.getUsername() );
		if(curuser.getAppellation().equals("管理员")){
//			Map<String, Object> userMap = new HashMap<String, Object>();
//			userMap.put("userid", curuser.getId());
//			List<User> userlist = userService.getAllUser(userMap);
//			map.addAttribute("allUsers", userlist);
			return "magpayManage";
		}
		return "payManage";
	}

	/**
	 * 查询用户收入集合
	 * 
	 * @param page
	 * @param rows
	 * @param s_pay
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	@RequestMapping("/paylist.do")
	public String list(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "rows", required = false) String rows, 
			@RequestParam(value = "manageid", required = false) int manageid,
			@RequestParam(value = "appellation", required = false) String appellation,
			Pay s_pay, HttpServletResponse response)
			throws Exception {
		PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
		System.out.println("++++++++:"+s_pay);
		Map<String, Object> map = new HashMap<String, Object>();
		List<Pay> payLists =new ArrayList<Pay>();
		
		if(appellation==null||appellation.equals("")){
		map.put("payer", StringUtil.formatLike(s_pay.getPayer()));
		map.put("source", StringUtil.formatLike(s_pay.getSource()));
		map.put("money", s_pay.getMoney());
		map.put("paytime", s_pay.getPaytime());
		map.put("starttime", s_pay.getStarttime());
		map.put("endtime", s_pay.getEndtime());
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pay> payList =null;
		 try {
			 payList = payService.findPay(map);
		} catch (Exception e) {
			System.out.println("查找失败");
		}
		}else{
			Map<String, Object> manageMap = new HashMap<String, Object>();
			manageMap.put("manageid",manageid);
			List<User> userList=userService.findUser(manageMap);
			//要搜索时
			if(s_pay.getPayer()==null||s_pay.getPayer().equals("")){
				for(int i=0;i<userList.size();i++){
					map.put("payer", userList.get(i).getUsername());
					map.put("source", StringUtil.formatLike(s_pay.getSource()));
					map.put("money", s_pay.getMoney());
					map.put("paytime", s_pay.getPaytime());
					map.put("starttime", s_pay.getStarttime());
					map.put("endtime", s_pay.getEndtime());
					List<Pay> payList=payService.findPay(map);
					payLists.addAll(payList);
				}
			
			}else{
				for(int i=0;i<userList.size();i++){
					if(s_pay.getPayer().equals(userList.get(i).getUsername())){
						map.put("payer", s_pay.getPayer());
						map.put("source", StringUtil.formatLike(s_pay.getSource()));
						map.put("money", s_pay.getMoney());
						map.put("paytime", s_pay.getPaytime());
						map.put("starttime", s_pay.getStarttime());
						map.put("endtime", s_pay.getEndtime());
						payLists=payService.findPay(map);
						break;
					}
					//不相等就没有变化原样输出
				}
			}
		}
		JSONObject result = new JSONObject();
		JSONArray jsonArray = JSONArray.fromObject(payLists);
		result.put("rows", jsonArray);
		ResponseUtil.write(response, result);
		return null;
	}

	/**
	 * 添加与修改支出
	 * 
	 * @param pay
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/paysave.do")
	public String save(@RequestParam(value = "mark") int mark,Pay pay, HttpServletResponse response) throws Exception {
		int resultTotal = 0; // 操作的记录条数
		JSONObject result = new JSONObject();
		if (mark == 1) {
			resultTotal = payService.addPay(pay);
		} else {
			 payService.deletePay(pay);
			 resultTotal =payService.updatePay(pay);
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
	@RequestMapping("/paydelete.do")
	public String delete(@RequestParam(value = "payers") String payers,
			@RequestParam(value = "paytimes") String paytimes,
			HttpServletResponse response) throws Exception {
		JSONObject result = new JSONObject();
		String[] payerStr = payers.split(",");
		String[] paytimeStr = paytimes.split(",");
		for (int i = 0; i < payerStr.length; i++) {
			Pay pay=new Pay();
			pay.setPayer(payerStr[i]);
			pay.setPaytime(paytimeStr[i]);
			payService.deletePay(pay);
		}
		result.put("errres", true);
		result.put("errmsg", "数据删除成功！");
		ResponseUtil.write(response, result);
		return null;
	}
	

}
