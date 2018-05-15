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

import com.finance.vo.Security;
import com.finance.vo.Trade;
import com.finance.vo.PageBean;
import com.finance.vo.User;
import com.finance.service.SecurityService;
import com.finance.service.TradeService;
import com.finance.service.UserService;
import com.finance.util.Constants;
import com.finance.util.ResponseUtil;
import com.finance.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 收入Controller层
 * 
 * @author HZX
 *
 */
@Controller
public class TradeController {
	@Resource
	private TradeService tradeService;
	@Resource
	private SecurityService securityService;
	@Resource
	private UserService userService;



	/**
	 * 收入信息管理页面
	 */
	@RequestMapping("/tradeManage.do")
	public String tradeManage(ModelMap map, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		User curuser = (User)session.getAttribute(Constants.currentUserSessionKey);
		Map<String, Object> userMap = new HashMap<String, Object>();
//		List<User> userlist = userService.getAllUser(userMap);
		map.addAttribute("s_username", curuser.getUsername());
		return "tradeManage";
	}

	/**
	 * 查询用户收入集合
	 * 
	 * @param page
	 * @param rows
	 * @param s_trade
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/tradelist.do")
	public String list(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "rows", required = false) String rows,
			@RequestParam(value = "name", required = false) String securityname,Trade s_trade, HttpServletResponse response)
			throws Exception {
		System.out.println(s_trade.toString());
		PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
		Map<String, Object> mapSecurity = new HashMap<String, Object>();
		mapSecurity.put("username", StringUtil.formatLike(securityname));
//		mapSecurity.put("securitynumber", StringUtil.formatLike(s_trade.getSecuritynumber()));
		//查询该用户名所有的持有证券
		List<Security> listSecurity=securityService.findSecurity(mapSecurity);
		//查询该用户的证券流水
		List<Trade> tradeLists=new ArrayList<Trade>();
		for(int i=0;i<listSecurity.size();i++){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("securityid", listSecurity.get(i).getId());
			map.put("source", s_trade.getSource());
			map.put("starttime", s_trade.getStarttime());
			map.put("endtime", s_trade.getEndtime());
//			map.put("start", pageBean.getStart());
//			map.put("size", pageBean.getPageSize());
			List<Trade> tradeList = tradeService.findTradeBySecurityId(map);
			for(int j=0;j<tradeList.size();j++){
				Trade trade=new Trade();
				trade.setTradeid(tradeList.get(j).getTradeid());
				trade.setSecuritynumber(listSecurity.get(i).getSecuritynumber());
				trade.setPrice(tradeList.get(j).getPrice());
				trade.setNumber(tradeList.get(j).getNumber());
				trade.setMoney(tradeList.get(j).getMoney());
				trade.setSource(tradeList.get(j).getSource());
				trade.setTradetime(tradeList.get(j).getTradetime());
				tradeLists.add(trade);
			}
		}
		JSONArray jsonArray = JSONArray.fromObject(tradeLists);
		JSONObject result = new JSONObject();
		result.put("rows", jsonArray);
		ResponseUtil.write(response, result);
		return null;
	}

	/**
	 * 添加改用户
	 * 
	 * @param trade
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/tradesave.do")
	public String save(Trade trade, @RequestParam(value = "s_username", required = false) String s_username,
			@RequestParam(value = "s_securitynumber", required = false) String s_securitynumber,HttpServletResponse response) throws Exception {
		int resultTotal = 0; // 操作的记录条数
		trade.setSecuritynumber(s_securitynumber);
		System.out.println("打印:"+s_securitynumber);
		System.out.println("添加这边输出："+trade);
		System.out.println("======"+s_username);
		JSONObject result = new JSONObject();
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("username", s_username);
		List<Security> securityList=securityService.findSecurity(map);
		for(int i=0;i<securityList.size();i++){
			//获取该用户所有的证券账号和传进来的账号对比
			if(s_securitynumber!=null&&securityList.get(i).getSecuritynumber().equals(s_securitynumber)){
				Trade trade2=new Trade(trade.getSecurityid(), trade.getPrice(), trade.getNumber(), 
						trade.getMoney(), trade.getSource(), trade.getStarttime(), s_securitynumber);
				resultTotal = tradeService.addTrade(trade2);
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
	 * 修改用户
	 * 
	 * @param trade
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/tradeupdate.do")
	public String save(Trade trade, HttpServletResponse response,@RequestParam(value = "id", required = false) int id) throws Exception {
		int resultTotal = 0; // 操作的记录条数
		JSONObject result = new JSONObject();
		if(id!=0){
			trade.setTradeid(id);
			resultTotal=tradeService.updateTrade(trade);
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
	@RequestMapping("/tradedelete.do")
	public String delete(@RequestParam(value = "tradeids") String tradeids, HttpServletResponse response) throws Exception {
		System.out.println("这边执行到后台删除了"+tradeids);
		JSONObject result = new JSONObject();
		String[] idsStr = tradeids.split(",");
		for (int i = 0; i < idsStr.length; i++) {
			tradeService.deleteTrade(Integer.parseInt(idsStr[i]));
		}
		result.put("errres", true);
		result.put("errmsg", "数据删除成功！");
		ResponseUtil.write(response, result);
		return null;
	}

}
