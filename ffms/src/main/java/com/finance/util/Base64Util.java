package com.finance.util;

import java.io.UnsupportedEncodingException;

public class Base64Util {

	public static void main(String[] args) {
		String ec = Base64Util.encode("123456", "UTF-8");
		System.out.println(ec);
		String dc = Base64Util.decodeStr(ec, "UTF-8");
		System.out.println(dc);

	}

	/**
	 * 编码
	 * 
	 * @param bstr
	 * @return String
	 */
	public static String encode(byte[] bstr) {
		return new sun.misc.BASE64Encoder().encode(bstr);
	}

	/**
	 * 编码
	 * 
	 * @param str
	 * @return String
	 */
	public static String encode(String str) {
		return encode(str.getBytes());
	}

	/**
	 * 编码
	 * 
	 * @param str
	 * @return String
	 */
	public static String encode(String str, String charset) {
		String rs = "";
		try {
			rs = encode(str.getBytes(charset));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return rs;
	}

	/**
	 * 解码
	 * 
	 * @param str
	 * @return string
	 */
	public static String decodeStr(String str) {
		byte[] bt = null;
		try {
			sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
			bt = decoder.decodeBuffer(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new String(bt);
	}

	/**
	 * 解码
	 * 
	 * @param str
	 * @return string
	 */
	public static String decodeStr(String str, String charset) {
		String rs = "";
		try {
			sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
			byte[] bt = decoder.decodeBuffer(str);
			rs = new String(bt, charset);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rs;

	}

	/**
	 * 解码
	 * 
	 * @param str
	 * @return string
	 */
	public static byte[] decode(String str) {
		byte[] bt = null;
		try {
			sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
			bt = decoder.decodeBuffer(str);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bt;
	}

}
