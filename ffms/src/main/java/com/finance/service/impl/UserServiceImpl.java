/**
 * 
 */
package com.finance.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.finance.dao.UserDao;
import com.finance.service.UserService;
import com.finance.vo.User;

/**
 * @author HZX
 *
 */
@Service("userService")
public class UserServiceImpl implements UserService {
	@Resource
	private UserDao userDao;
	public User getUserByName(String username) {
		return userDao.getUserByName(username);
	}
	public User loginPassword(User user) {
		return userDao.loginPassword(user);
	}
	public User loginRolename(User user) {
		return userDao.loginRolename(user);
	}
	public List<User> findUser(Map<String, Object> map) {
		return userDao.findUser(map);
	}
	/**
	 * 获取用户数量
	 * @param map
	 * @return
	 */
	public int getCounts(Map<String,Object> map){
		return userDao.getCounts(map);
	}
	public int updateUser(User user) {
		return userDao.updateUser(user);
	}
	public int addUser(User user) {
		return userDao.addUser(user);
	}
	public int addUserRole(User user) {
		return userDao.addUserRole(user);
	}
	public int addSign(User user) {
		return userDao.addSign(user);
	}
	public void deleteUser(String username) {
		 userDao.deleteUser(username);
	}
	public boolean getUserIsExists(User user) {
		return userDao.getUserIsExists(user);
	}
	public User getUserById(Integer id) {
		return userDao.getUserById(id);
	}
	public List<User> getAllUser(Map<String, Object> map) {
		return userDao.getAllUser(map);
	}
	public List<User> findManage(Map<String, Object> map) {
		return userDao.findManage(map);
	}
	public int getMaxManageID() {
		return userDao.getMaxManageID();
	}
	public int addManage(User user) {
		return userDao.addManage(user);
	}
	public List<User> getRelation(int manageid) {
		return userDao.getRelation(manageid);
	}
	public List<String> getProvince() {
		return userDao.getProvince();
	}


}
