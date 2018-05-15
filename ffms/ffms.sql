/*
Navicat MySQL Data Transfer

Source Server         : new
Source Server Version : 50718
Source Host           : localhost:3306
Source Database       : ffms

Target Server Type    : MYSQL
Target Server Version : 50718
File Encoding         : 65001

Date: 2018-04-30 14:34:17
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for t_income
-- ----------------------------
DROP TABLE IF EXISTS `t_income`;
CREATE TABLE `t_income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `incomer` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `money` bigint(20) DEFAULT NULL,
  `incometime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `PK_INCOME_USER` (`incomer`),
  CONSTRAINT `PK_INCOME_USER` FOREIGN KEY (`incomer`) REFERENCES `t_user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_income
-- ----------------------------
INSERT INTO `t_income` VALUES ('1', 'fj1', '工资', '150', '2018-04-01 12:37:26');
INSERT INTO `t_income` VALUES ('2', 'fj1', '炒房', '2000', '2018-04-02 12:39:39');
INSERT INTO `t_income` VALUES ('3', 'fj2', '工资', '200', '2018-04-01 11:52:02');
INSERT INTO `t_income` VALUES ('5', 'fj4', '工资', '120', '2018-04-01 12:41:01');
INSERT INTO `t_income` VALUES ('12', 'fj1', '炒房', '150', '2018-04-03 04:42:07');
INSERT INTO `t_income` VALUES ('13', 'fj1', '兼职', '200', '2018-04-04 04:42:40');
INSERT INTO `t_income` VALUES ('14', 'fj2', '借钱', '1100', '2018-04-02 11:52:20');
INSERT INTO `t_income` VALUES ('16', 'fj2', '工资', '200', '2018-04-03 00:28:45');
INSERT INTO `t_income` VALUES ('17', 'fj2', '工资', '200', '2018-04-04 12:10:40');
INSERT INTO `t_income` VALUES ('18', 'fj1', '奖金', '500', '2018-04-05 00:31:23');
INSERT INTO `t_income` VALUES ('20', 'fj3', '工资', '300', '2018-04-04 10:44:00');
INSERT INTO `t_income` VALUES ('21', 'fj4', '兼职', '110', '2018-04-02 10:44:16');
INSERT INTO `t_income` VALUES ('22', 'fj4', '工资', '120', '2018-04-03 10:44:48');
INSERT INTO `t_income` VALUES ('23', 'fj5', '工资', '500', '2018-04-05 10:45:38');
INSERT INTO `t_income` VALUES ('24', 'fj6', '兼职', '200', '2018-04-01 10:45:52');
INSERT INTO `t_income` VALUES ('25', 'fj1', '工资', '150', '2018-04-02 00:22:10');
INSERT INTO `t_income` VALUES ('26', 'fj1', '炒房', '1500', '2018-04-03 00:23:07');
INSERT INTO `t_income` VALUES ('27', 'fj1', '工资', '150', '2018-04-04 00:24:08');
INSERT INTO `t_income` VALUES ('28', 'fj2', '工资', '200', '2018-04-05 00:24:42');
INSERT INTO `t_income` VALUES ('29', 'fj6', '工资', '400', '2018-04-01 00:27:30');
INSERT INTO `t_income` VALUES ('30', 'fj6', '工资', '400', '2018-04-02 00:27:46');
INSERT INTO `t_income` VALUES ('31', 'fj6', '借钱', '900', '2018-04-03 00:28:13');
INSERT INTO `t_income` VALUES ('32', 'fj6', '工资', '400', '2018-04-04 00:28:29');
INSERT INTO `t_income` VALUES ('33', 'fj6', '工资', '400', '2018-04-05 00:28:44');

-- ----------------------------
-- Table structure for t_pay
-- ----------------------------
DROP TABLE IF EXISTS `t_pay`;
CREATE TABLE `t_pay` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payer` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `money` bigint(20) DEFAULT NULL,
  `paytime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `PK_PAY_USER` (`payer`),
  CONSTRAINT `PK_PAY_USER` FOREIGN KEY (`payer`) REFERENCES `t_user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_pay
-- ----------------------------
INSERT INTO `t_pay` VALUES ('1', 'fj1', '纳税', '100', '2018-04-01 12:42:02');
INSERT INTO `t_pay` VALUES ('2', 'fj1', '吃饭', '1000', '2018-04-02 12:42:33');
INSERT INTO `t_pay` VALUES ('3', 'fj1', '房租', '1200', '2018-04-03 12:43:05');
INSERT INTO `t_pay` VALUES ('4', 'fj4', '门票', '50', '2018-04-03 12:43:46');
INSERT INTO `t_pay` VALUES ('5', 'fj2', '纳税', '300', '2018-04-01 12:44:15');
INSERT INTO `t_pay` VALUES ('6', 'fj2', '吃饭', '50', '2018-04-02 10:05:13');
INSERT INTO `t_pay` VALUES ('7', 'fj2', '打车', '100', '2018-04-03 10:05:35');
INSERT INTO `t_pay` VALUES ('13', 'fj1', '看病', '1000', '2018-04-04 04:51:49');
INSERT INTO `t_pay` VALUES ('15', 'fj9', '刷卡', '500', '2018-04-05 11:59:06');
INSERT INTO `t_pay` VALUES ('16', 'fj2', '吃饭', '60', '2018-04-04 00:06:30');
INSERT INTO `t_pay` VALUES ('17', 'fj1', '游玩', '600', '2018-04-05 00:06:54');
INSERT INTO `t_pay` VALUES ('18', 'fj2', '购物', '400', '2018-04-05 00:07:48');
INSERT INTO `t_pay` VALUES ('19', 'fj6', '吃饭', '80', '2018-04-01 00:09:58');
INSERT INTO `t_pay` VALUES ('20', 'fj6', '购物', '650', '2018-04-02 00:10:16');
INSERT INTO `t_pay` VALUES ('21', 'fj6', '房租', '800', '2018-04-03 00:11:50');
INSERT INTO `t_pay` VALUES ('22', 'fj6', '打印', '60', '2018-04-04 00:12:05');
INSERT INTO `t_pay` VALUES ('23', 'fj6', '门票', '420', '2018-04-05 00:12:30');

-- ----------------------------
-- Table structure for t_security
-- ----------------------------
DROP TABLE IF EXISTS `t_security`;
CREATE TABLE `t_security` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `securitynumber` varchar(255) DEFAULT NULL,
  `securitypassword` varchar(255) DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `PK_SECURITY_USER` (`username`),
  CONSTRAINT `PK_SECURITY_USER` FOREIGN KEY (`username`) REFERENCES `t_user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_security
-- ----------------------------
INSERT INTO `t_security` VALUES ('1', '111', '1111', 'fj1');
INSERT INTO `t_security` VALUES ('2', '112', '1112', 'fj1');
INSERT INTO `t_security` VALUES ('3', '113', '1113', 'fj1');
INSERT INTO `t_security` VALUES ('4', '114', '1114', 'fj1');
INSERT INTO `t_security` VALUES ('5', '115', '1115', 'fj1');
INSERT INTO `t_security` VALUES ('6', '221', '2221', 'fj2');
INSERT INTO `t_security` VALUES ('8', '333', '2223', 'fj2');
INSERT INTO `t_security` VALUES ('9', '111', '2223', 'fj2');
INSERT INTO `t_security` VALUES ('10', '113', '121312', 'fj2');
INSERT INTO `t_security` VALUES ('11', '333', '333', 'fj3');
INSERT INTO `t_security` VALUES ('12', '1231', '21312', 'fj3');
INSERT INTO `t_security` VALUES ('13', '444', '31231', 'fj4');
INSERT INTO `t_security` VALUES ('14', '555', '123123', 'fj5');
INSERT INTO `t_security` VALUES ('16', '222', '2222', 'fj2');
INSERT INTO `t_security` VALUES ('17', '115', '123', 'fj1');
INSERT INTO `t_security` VALUES ('18', '999', '999', 'fj1');
INSERT INTO `t_security` VALUES ('19', '113', '1114', 'fj1');
INSERT INTO `t_security` VALUES ('20', '1112', '1', 'fj1');
INSERT INTO `t_security` VALUES ('21', '123', '23123', 'fj6');
INSERT INTO `t_security` VALUES ('22', '555', 'qeqw', 'fj6');
INSERT INTO `t_security` VALUES ('23', '111', '21', 'fj6');

-- ----------------------------
-- Table structure for t_trade
-- ----------------------------
DROP TABLE IF EXISTS `t_trade`;
CREATE TABLE `t_trade` (
  `tradeid` int(12) NOT NULL AUTO_INCREMENT,
  `securityid` int(12) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `money` bigint(20) DEFAULT NULL,
  `source` enum('买入','卖出') DEFAULT NULL,
  `tradetime` datetime DEFAULT NULL,
  PRIMARY KEY (`tradeid`),
  KEY `PK_TRADE_SECURITY` (`securityid`),
  CONSTRAINT `PK_TRADE_SECURITY` FOREIGN KEY (`securityid`) REFERENCES `t_security` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_trade
-- ----------------------------
INSERT INTO `t_trade` VALUES ('1', '1', '2', '2', '4', '买入', '2018-04-10 18:59:14');
INSERT INTO `t_trade` VALUES ('2', '1', '2', '50', '100', '买入', '2018-04-11 19:00:33');
INSERT INTO `t_trade` VALUES ('3', '2', '4', '60', '240', '卖出', '2018-04-13 19:00:58');
INSERT INTO `t_trade` VALUES ('4', '2', '5', '5', '25', '买入', '2018-04-10 19:01:19');
INSERT INTO `t_trade` VALUES ('6', '6', '6', '4', '24', '卖出', '2018-04-13 19:02:07');
INSERT INTO `t_trade` VALUES ('7', '8', '10', '20', '200', '卖出', '2018-04-14 19:03:01');
INSERT INTO `t_trade` VALUES ('8', '8', '2', '50', '100', '买入', '2018-04-15 19:03:23');
INSERT INTO `t_trade` VALUES ('9', '16', '25', '12', '300', '卖出', '2018-04-17 19:03:49');
INSERT INTO `t_trade` VALUES ('10', '1', '2', '4', '8', '卖出', '2018-04-20 11:08:50');
INSERT INTO `t_trade` VALUES ('11', '21', '2', '4', '8', '卖出', '2018-04-21 01:15:20');
INSERT INTO `t_trade` VALUES ('12', '21', '4', '5', '20', '买入', '2018-04-19 01:15:37');
INSERT INTO `t_trade` VALUES ('13', '22', '5', '10', '50', '买入', '2018-04-17 01:15:53');
INSERT INTO `t_trade` VALUES ('14', '22', '5', '2', '10', '卖出', '2018-04-18 01:16:16');
INSERT INTO `t_trade` VALUES ('15', '23', '10', '10', '100', '卖出', '2018-04-24 01:16:31');
INSERT INTO `t_trade` VALUES ('17', '1', '2', '2', '4', '买入', '2018-04-22 13:33:16');

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `truename` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `sex` enum('男','女') DEFAULT NULL,
  `appellation` varchar(20) DEFAULT NULL,
  `manageid` int(11) DEFAULT NULL,
  `isvalid` int(2) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES ('admin', 'k2z9PCWc2IM=', 'admin', null, '福建', '漳州', '漳浦县', null, '管理员', '0', null);
INSERT INTO `t_user` VALUES ('fj1', 'k2z9PCWc2IM=', '林佩有', '4848@qq.com', '福建', '福州', '马尾区', '男', '管理员', '1', '0');
INSERT INTO `t_user` VALUES ('fj10', 'k2z9PCWc2IM=', '周灿', '122131@qq.com', '湖北', '武汉', '洪山区', '女', '奶奶', '1', '0');
INSERT INTO `t_user` VALUES ('fj2', 'k2z9PCWc2IM=', '庄斌', '1231@162.com', '福建', '福州', '晋安区', '男', '儿子', '2', '0');
INSERT INTO `t_user` VALUES ('fj3', 'k2z9PCWc2IM=', '吴奇隆', '1213@qq.com', '福建', '漳州', '芗城区', '男', '父亲', '1', '1');
INSERT INTO `t_user` VALUES ('fj4', 'k2z9PCWc2IM=', 'zz', null, '江西', '宜春', '丰城市', '女', null, null, null);
INSERT INTO `t_user` VALUES ('fj5', 'k2z9PCWc2IM=', '周鑫吃', '213@qq.com', '江西', '宜春', '丰城市', '男', '管理员', '2', '0');
INSERT INTO `t_user` VALUES ('fj6', 'k2z9PCWc2IM=', '吴孟达', '21@qq.com', '福建', '泉州', '安溪', '女', '管理员', '3', null);
INSERT INTO `t_user` VALUES ('fj7', 'k2z9PCWc2IM=', '今晚打老虎', 'weq@qq.com', '江西', '南昌', '南昌县', '男', '管理员', '4', null);
INSERT INTO `t_user` VALUES ('fj8', 'k2z9PCWc2IM=', 'aa', '122131@qq.com', '山西', '大同', '阳高县', '男', 'aa', null, null);
INSERT INTO `t_user` VALUES ('fj9', 'k2z9PCWc2IM=', '叶问', '2131@qq.com', '福建', '福州', '马尾区', '男', '女婿', '1', '0');
SET FOREIGN_KEY_CHECKS=1;
