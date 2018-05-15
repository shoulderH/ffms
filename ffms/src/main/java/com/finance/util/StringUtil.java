package com.finance.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.codec.digest.DigestUtils;

/**
 * 字符串工具类
 * @author HZX
 *
 */
public class StringUtil {

	/**
	 * 判断是否是空
	 * @param str
	 * @return
	 */
	public static boolean isEmpty(String str){
		if(str==null||"".equals(str.trim())){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 判断是否不是空
	 * @param str
	 * @return
	 */
	public static boolean isNotEmpty(String str){
		if((str!=null)&&!"".equals(str.trim())){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 格式化模糊查询
	 * @param str
	 * @return
	 */
	public static String formatLike(String str){
		if(isNotEmpty(str)){
			return "%"+str+"%";
		}else{
			return null;
		}
	}
	
	/**
	 * 判断是否是空
	 * @param str
	 * @return
	 */
	public static String covertNull(String str){
		if(str==null||"NULL".equalsIgnoreCase(str)){
			return "";
		}else{
			return str;
		}
	}
	
	/**
	 * 返回文件的扩展名
	 * @param str
	 * @return
	 */
	public static String getFileExtName(String str){
		if(str==null||"NULL".equalsIgnoreCase(str)){
			return "";
		}else{			
			return str.substring(str.lastIndexOf(".")+1);
		}
	}

 
	/**
	 * 样例：StringUtil.trimBeginStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;void&nbsp; clear(&nbsp;)&nbsp;&nbsp;&nbsp;", "&nbsp;")
	 * @param oldStr
	 * @param replaceStr
	 * @return
	 */
	public static String trimBeginStr(String oldStr,String replaceStr ){		
		while(oldStr.startsWith(replaceStr)){
			oldStr=oldStr.replaceFirst(replaceStr, "");
		}	 
		return oldStr; 
	}
	/**
	 * 样例：StringUtil.trimEndStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;void&nbsp; clear(&nbsp;)&nbsp;&nbsp;&nbsp;", "&nbsp;")
	 * @param oldStr
	 * @param replaceStr
	 * @return
	 */
    public static String trimEndStr(String oldStr,String replaceStr ){ 
    	oldStr=trimBeginStr(new StringBuffer(oldStr).reverse().toString(),new StringBuffer(replaceStr).reverse().toString());
 		return new StringBuffer(oldStr).reverse().toString(); 
	}
    

    public static boolean isURL(String url){
    	 //String rex="[a-zA-z]+://[^\s]*";   
    	 String regex = "^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]" ;
    	 Pattern patt = Pattern. compile(regex );
    	 Matcher matcher = patt.matcher(url);
    	 boolean isMatch = matcher.matches();
    	 return isMatch;
    	 
    }
}
