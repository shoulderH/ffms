package com.finance.controller;

import java.text.SimpleDateFormat;
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

import com.finance.vo.PageBean;
import com.finance.vo.Security;
import com.finance.vo.User;
import com.finance.service.SecurityService;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 证券信息Controller层
 * @author HZX
 *
 */
@Controller
public class SecurityController {
	@Resource
	private SecurityService securityService;
	@Resource
	private UserService userService;


	/**
	 * 证券信息管理页面
	 */
	@RequestMapping("/securityManage.do")
	public String securityManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
//		Map<String, Object> userMap = new HashMap<String, Object>();
//		userMap.put("userid", curuser.getId());
//		userMap.put("roleid", curuser.getRoleid());
//		List<User> userlist = userService.getAllUser(userMap);
		map.addAttribute("s_username",curuser.getUsername() );
		if(curuser.getAppellation().equals("管理员")){
//			Map<String, Object> userMap = new HashMap<String, Object>();
//			userMap.put("userid", curuser.getId());
//			List<User> userlist = userService.getAllUser(userMap);
//			map.addAttribute("allUsers", userlist);
			return "securityManage";
		}
		return "securityManage";
	}

	/**
	 * 查询证券信息集合
	 * 
	 * @param page
	 * @param rows
	 * @param s_security
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/securitylist.do")
	public String list(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "rows", required = false) String rows,
			Security s_security, HttpServletResponse response)
			throws Exception {
		PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("securitynumber", StringUtil.formatLike(s_security.getSecuritynumber()));
		map.put("securitypassword", s_security.getSecuritypassword());
		map.put("username", StringUtil.formatLike(s_security.getUsername()));
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Security> securityList=null;
		 try {
			 securityList = securityService.findSecurity(map);
		} catch (Exception e) {
			System.out.println("查找失败");
		}
		JSONObject result = new JSONObject();
		JSONArray jsonArray = JSONArray.fromObject(securityList);
		result.put("rows", jsonArray);
		ResponseUtil.write(response, result);
		return null;
	}

	/**
	 * 添加与修改证券信息
	 * 
	 * @param security
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/securitysave.do")
	public String save(@RequestParam(value = "mark") int mark,Security security, HttpServletResponse response) throws Exception {
		int resultTotal = 0; // 操作的记录条数
		JSONObject result = new JSONObject();
		if(!securityService.getIsExistSecurity(security)){
			//mark为1则为添加
			if (mark == 1) {
				resultTotal = securityService.addSecurity(security);
			} else {
			//mark为0则为修改
				securityService.deleteSecurity(security);
				resultTotal = securityService.addSecurity(security);
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

	/**
	 * 删除证券信息
	 * 
	 * @param ids
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/securitydelete.do")
	public String delete(@RequestParam(value = "securitynumbers") String securitynumbers,
			@RequestParam(value = "securitypasswords") String securitypasswords,
			@RequestParam(value = "usernames") String usernames,
			HttpServletResponse response) throws Exception {
		JSONObject result = new JSONObject();
		String[] numbersStr = securitynumbers.split(",");
		String[] passwordsStr = securitypasswords.split(",");
		String[] usernamesStr = usernames.split(",");
		for (int i = 0; i < numbersStr.length; i++) {
			Security security=new Security();
			security.setSecuritynumber(numbersStr[i]);
			security.setSecuritypassword(passwordsStr[i]);
			security.setUsername(usernamesStr[i]);
			securityService.deleteSecurity(security);
		}
		result.put("errres", true);
		result.put("errmsg", "数据删除成功！");
		ResponseUtil.write(response, result);
		return null;
	}

}
