package com.finance.controller;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.dom4j.Attribute;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.finance.core.des.DESUtils;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;
import com.finance.vo.PageBean;
import com.finance.vo.User;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 用户Controller层
 * @author HZX
 *
 */
@Controller
public class UserController {
	@Resource
	private UserService userService;
	

	/**
	 * 用户登录页面
	 */
	@RequestMapping("/index.do")
	public String index(ModelMap map) {
		return "login";
	}

	/**
	 * 用户登录
	 * 
	 * @param user
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unused")
	@RequestMapping("/login.do")
	public String login(User user, HttpServletRequest request, HttpServletResponse response) {
		JSONObject result = new JSONObject();
		//查找用户名是否存在，若存在返回所有的信息
		User resultUser = userService.getUserByName(user.getUsername());
		if (resultUser == null) {
			result.put("errres", 101);
			result.put("errmsg", "用户名不存在！");
			result.put("inputfocus", "inputUsername");
		} else {
			//解密返回来的密码和传入的密码相对比
			if (!DESUtils.getDecryptString(resultUser.getPassword())
					.equals(user.getPassword())){
				result.put("errres", 102);
				result.put("errmsg", "密码不正确！");
				result.put("inputfocus", "inputPassword");
			} else {
				//判断角色是否选择正确
				if (user.getAppellation().equals("管理员")&&!resultUser.getAppellation().equals("管理员")) {
					result.put("errres", 103);
					result.put("errmsg", "用户角色不匹配！");
					result.put("inputfocus", "roleid");
				}else if(user.getAppellation().equals("普通用户")&&resultUser.getAppellation().equals("管理员")){
					result.put("errres", 103);
					result.put("errmsg", "用户角色不匹配！");
					result.put("inputfocus", "roleid");
				} else {
					//解密数据库的密码存入常量中
					resultUser.setPassword(DESUtils.getDecryptString(resultUser.getPassword()));
					HttpSession session = request.getSession();
					session.setAttribute(Constants.currentUserSessionKey, resultUser);
					result.put("errres", 200);
				}
			}
		}
		ResponseUtil.write(response, result);
		return null;
	}

	/**
	 * 进入主页面
	 */
	@RequestMapping("/main.do")
	public String main(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User usersession = (User)session.getAttribute(Constants.currentUserSessionKey);
		String role=null;
		map.addAttribute("usermessage", usersession);
		if(usersession.getUsername().equals("admin")){
			return "admin";
		}
	    if(usersession.getAppellation().equals("管理员")&&!usersession.getManageid().equals("")){
			role="管理员";
		}else{
			role="普通用户";
		}
		map.addAttribute("roles", role);
	
		return "main";
	}
	/**
	 * 用户注册页面
	 */
	@RequestMapping("/sign.do")
	public String sign() {
		return "sign";
	}
	
	/**
	 * 注册用户操作
	 */
	@RequestMapping("/gosign.do")
	public String gosign(User user, HttpServletResponse response) throws Exception {
		int resultTotal = 0; // 操作的记录条数
		JSONObject result = new JSONObject();
		if (userService.getUserIsExists(user)) {
			result.put("errres", false);
			result.put("errmsg", "用户名已经被使用！");
			result.put("inputfocus", "inputUsername");
			ResponseUtil.write(response, result);
			return null;
		}
		//加密密码
		user.setPassword(DESUtils.getEncryptString(user.getPassword()));
		resultTotal = userService.addSign(user);

		if ((resultTotal > 0)) { // 执行成功
			result.put("errres", true);
			result.put("errmsg", "注册成功，请返回登录！");
		} else {
			result.put("errres", false);
			result.put("errmsg", "注册失败");
			result.put("inputfocus", "inputUsername");
		}
		ResponseUtil.write(response, result);
		return null;
	}




	/**
	 * 修改用户密码
	 * 
	 * @param user
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modifyPassword.do")
	public String modifyPassword(User user, HttpServletResponse response) throws Exception {
		//加密密码存入数据库中
		user.setPassword(DESUtils.getEncryptString(user.getPassword()));
		int resultTotal = userService.updateUser(user);
		JSONObject result = new JSONObject();
		if (resultTotal > 0) { // 执行成功
			result.put("success", true);
		} else {
			result.put("success", false);
		}
		ResponseUtil.write(response, result);
		return null;
	}

	/**
	 * 用户注销
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/logout.do")
	public String logout(HttpSession session) throws Exception {
		session.removeAttribute(Constants.currentUserSessionKey);
		return "redirect:/index.do";
	}

	/**
	 * 用户信息管理页面
	 */
	@RequestMapping("/userManage.do")
	public String userManage(ModelMap map, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		System.out.println("打印："+curuser.toString());
//		Map<String, Object> userMap = new HashMap<String, Object>();
//		userMap.put("username", curuser.getUsername());
//		userMap.put("manageid", curuser.getManageid());
		map.addAttribute("s_username",curuser.getUsername() );
		map.addAttribute("s_manageid", curuser.getManageid());
		return "userManage";
	}
	/**
	 * 查询用户集合
	 * 
	 * @param page
	 * @param rows
	 * @param s_user
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userlist.do")
	public String list(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "rows", required = false) String rows, User s_user, HttpServletResponse response)
			throws Exception {
		System.out.println(s_user);
		PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
		Map<String, Object> map = new HashMap<String, Object>();
		//模糊匹配
		map.put("username", StringUtil.formatLike(s_user.getUsername()));
		map.put("truename", StringUtil.formatLike(s_user.getTruename()));
		map.put("appellation", StringUtil.formatLike(s_user.getAppellation()));
		map.put("manageid", s_user.getManageid());
		map.put("sex", s_user.getSex());
		map.put("email", StringUtil.formatLike(s_user.getEmail()));
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<User> userList =null;
		try {
			 userList = userService.findUser(map);
			 System.out.println(userList.toString());
		} catch (Exception e) {
			System.out.println("查找失败");
		}
		for(int i = 0; i < userList.size(); i++) {
			userList.get(i).setPassword(DESUtils.getDecryptString(userList.get(i).getPassword()));
        }
//		Long total = userService.getTotalUser(map);
		JSONObject result = new JSONObject();
		JSONArray jsonArray = JSONArray.fromObject(userList);
		result.put("rows", jsonArray);
//		result.put("total", total);
		ResponseUtil.write(response, result);
		return null;
	}


	

	/**
	 * 修改用户
	 * 
	 * @param customer
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usersave.do")
	public String save(User user, HttpServletResponse response) throws Exception {
		System.out.println(user.toString());
		user.setPassword(DESUtils.getEncryptString(user.getPassword()));
		int resultTotal=0;
		JSONObject result = new JSONObject();
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("manageid",user.getManageid());
			map.put("appellation","管理员");
			List<User> manageList=userService.findUser(map);
			user.setProvince(manageList.get(0).getProvince());
			user.setCity(manageList.get(0).getCity());
			user.setCounty(manageList.get(0).getCounty());
			 resultTotal = userService.updateUser(user);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("插入数据库失败");
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
	 * 添加用户
	 * @param user
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addUser.do")
	public String addUser(User user, HttpServletResponse response) throws Exception {
		System.out.println("============"+user.toString());
		int resultTotal=0;
		JSONObject result = new JSONObject();
		if(!userService.getUserIsExists(user)){
			try {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("manageid",user.getManageid());
				map.put("appellation","管理员");
				List<User> manageList=userService.findUser(map);
				user.setProvince(manageList.get(0).getProvince());
				user.setCity(manageList.get(0).getCity());
				user.setCounty(manageList.get(0).getCounty());
				user.setPassword(DESUtils.getEncryptString(user.getPassword()));
				user.setIsvalid(0);
				 resultTotal = userService.addUser(user);
			} catch (Exception e) {
				// TODO: handle exception
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
	/**
	 * 删除用户
	 * 
	 * @param ids
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userdelete.do")
	public String delete(@RequestParam(value = "usernames") String usernames, HttpServletResponse response) throws Exception {
		JSONObject result = new JSONObject();
		String[] usernamesStr = usernames.split(",");
		for (int i = 0; i < usernamesStr.length; i++) {
			userService.deleteUser(usernamesStr[i]);
		}
		result.put("errres", true);
		result.put("errmsg", "数据删除成功！");
		ResponseUtil.write(response, result);
		return null;
	}
	
	/**
	 * 更改主题
	 * @param currentTheme
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/changeTheme.do")
	public String changeTheme(
			@RequestParam(value = "currentTheme") String currentTheme,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		JSONObject result = new JSONObject();
		HttpSession session = request.getSession();
		session.setAttribute("currentTheme", currentTheme);
		result.put("errres", true);
		result.put("errmsg", "主题切换成功！");
		ResponseUtil.write(response, result);
		return null;
	}
	/**
	 * 
	 * 加载注册界面时，ajax自动加载省份
	 * @param request
	 * @param response
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping("/province.do")
	public void ProvinceController(HttpServletRequest request,HttpServletResponse response) throws UnsupportedEncodingException {
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml;charset=UTF-8");
		try {
		SAXReader reader = new SAXReader();//解析器
        InputStream input = this.getClass().getResourceAsStream("/china.xml");
        org.dom4j.Document doc = reader.read(input);

        /*
         * 查询所有的province的name属性，得到一堆的属性对象
         */
        @SuppressWarnings("unchecked")
		List<Attribute> arrList = doc.selectNodes("//province/@name");//@表示属性
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arrList.size() ; i++) {
            sb.append(arrList.get(i).getValue());
            if (i < arrList.size() - 1) {
                sb.append(",");
            }
        }
        	response.getWriter().print(sb);
				
			} catch (Exception e) {
	            throw new RuntimeException(e);
	        }
	}
	
	
	/**
	 * ajax选择省份之后，城市的变化
	 * @param request
	 * @param response
	 * @throws UnsupportedEncodingException
	 */
	
	@RequestMapping("/city.do")
	public void CityController(HttpServletRequest request,HttpServletResponse response) throws UnsupportedEncodingException {
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml;charset=UTF-8");
        /*
         * 1、获取省份的名称
         * 2、使用省份的名称，并且对于区域进行查找
         * 3、转换成字符串进行发送！
         */
        try{
            SAXReader reader = new SAXReader();//解析器
            InputStream input = this.getClass().getResourceAsStream("/china.xml");
            org.dom4j.Document doc = reader.read(input);
            /*
             * 获取参数
             */
            String pname = request.getParameter("pname");
            Element proEle = (Element) doc.selectSingleNode("//province[@name='"+pname+"']");
            String xmlStr = proEle.asXML();
            response.getWriter().print(xmlStr);
        } catch (Exception e) {
            throw new RuntimeException(e);
    }
	}
	
	/**
	 * ajax选择城市之后县区的变化
	 * @param request
	 * @param response
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping("/county.do")
	public void CountyController(HttpServletRequest request,HttpServletResponse response) throws UnsupportedEncodingException {
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml;charset=UTF-8");
        /*
         * 1、获取城市的名称
         * 2、使用城市的名称，并且对于区域进行查找
         * 3、转换成字符串进行发送！
         */
        try{
            SAXReader reader = new SAXReader();//解析器
            InputStream input = this.getClass().getResourceAsStream("/china.xml");
            org.dom4j.Document doc = reader.read(input);
            /*
             * 获取参数
             */
            String cname = request.getParameter("cname");
            Element proEle = (Element) doc.selectSingleNode("//city[@name='"+cname+"']");
            String xmlStr = proEle.asXML();
            response.getWriter().print(xmlStr);
        } catch (Exception e) {
            throw new RuntimeException(e);
    }
	}
	
	
	
}
