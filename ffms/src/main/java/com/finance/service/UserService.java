/**
 * 
 */
package com.finance.service;

import java.util.List;
import java.util.Map;

import com.finance.vo.User;

/**
 * @author HZX
 *
 */
public interface UserService {
	/**
	 * 通过用户名查找用户信息
	 * @param user
	 * @return
	 */
	public User getUserByName(String username);

	/**
	 * 用户登录验证密码
	 * @param user
	 * @return
	 */
	public User loginPassword(User user);
	
	/**
	 * 用户登录验证角色
	 * @param user
	 * @return
	 */
	public User loginRolename(User user);
	
	/**
	 * 查询用户
	 * @param map
	 * @return
	 */
	public List<User> findUser(Map<String,Object> map);
	
	/**
	 * 获取用户数量
	 * @param map
	 * @return
	 */
	public int getCounts(Map<String,Object> map);
	
	/**
	 * 更新用户
	 * @param user
	 * @return
	 */
	public int updateUser(User user);
	
	/**
	 * 添加用户
	 * @param user
	 * @return
	 */
	public int addUser(User user);
	
	/**
	 * 添加用户角色匹配
	 * @param user
	 * @return
	 */
	public int addUserRole(User user);
	
	/**
	 * 注册用户
	 * @param user
	 * @return
	 */
	public int addSign(User user);
	
	/**
	 * 删除用户
	 * @param username
	 * @return
	 */
	public void deleteUser(String username);
	
	/**
	 * 判断用户是否已经存在
	 * @param user
	 * @return  0：不存在  >已经存在
	 */
	public boolean getUserIsExists(User user);
	
	/**
	 * 从id获得用户信息
	 * @param id
	 * @return
	 */
	public User getUserById(Integer id);
	
	/**
	 * 获得所有用户
	 * @return
	 */
	public List<User> getAllUser(Map<String,Object> map);
	/**
	 * 查询管理员
	 * @param map
	 * @return
	 */
	public List<User> findManage(Map<String,Object> map);
	/**
	 * 获取管理员最大的id号
	 * @return
	 */
	public int  getMaxManageID();
	/**
	 * 添加管理员
	 * @param user
	 * @return
	 */
	public int addManage(User user);
	/**
	 * 根据管理员号获取称谓和用户名
	 * @param manageid
	 * @return
	 */
	public List<User> getRelation(int manageid);
	/**
	 * 查询存在的所有省份
	 * @return
	 */
	public List<String> getProvince();
}
